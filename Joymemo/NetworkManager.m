//
//  NetworkManager.m
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "NetworkManager.h"
#import "AppDelegate.h"
@interface NetworkManager ()
- (NSData *)getJsonFromServerWithSubDirName: (NSString *)subDirName fileName:(NSString*)fileName parameter:(NSString*)param;
- (NSData *)postDataToServerWithSubDirName: (NSString *)subDirName subSubDirName:(NSString*)subSubDirName parameter:(NSString*)param;
- (NSData *)removeDataFromServerWithSubDirName: (NSString *)subDirName subSubDirName:(NSString*)subSubDirName parameter:(NSString*)param;
@end

@implementation NetworkManager

- (id) init {
    if (self = [super init]) {
        // 本来なら、ユーザIDは初回起動時に生成されてローカルに保存される
        //self.userId = @"88888D45-9C07-4B93-A5E0-82BED5A7864F"; // さとみのユーザID (自分)
        //self.userId = @"36D813FB-5495-45CA-B468-06F6EFB82A92"; // 子ども1のユーザID (りょうしゅん)
        self.userId = @"63F1A4AB-C574-4654-9272-56E2FB598095"; // 子ども2のユーザID (ホワイティ)
        //self.userId = @"B3B04AD0-E39E-4A6E-A433-DE1AF077E0B9"; // 子ども3のユーザID (リーダー)
        
        self.rootUrl = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    }
    return self;
}
// オフライン時のエラー回避・例外処理を記述する必要がある
//---------- 実際にURLからJSONを取得するメソッド ----------
- (NSData *)getJsonFromServerWithSubDirName: (NSString *)subDirName fileName:(NSString*)fileName parameter:(NSString*)param
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@/%@.json?%@", self.rootUrl, subDirName, fileName, param];
    NSLog(@"%@", urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30]; // タイムアウトを30秒に設定
    //サーバーからJSONを取得
    NSError * getError;
    NSData * jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&getError];
    NSLog(@"%@", [getError localizedDescription]);
    
    //-- テスト用始め JSONをパース
    NSError * parseError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
    
    NSLog(@"%@",[parseError localizedDescription]);
    NSLog(@"%@",jsonArray);
    //-- テスト用終わり
    
    return jsonData;
}

//---------- 実際にURLにデータをPOSTするメソッド ----------
- (NSData *)postDataToServerWithSubDirName: (NSString *)subDirName subSubDirName:(NSString*)subSubDirName parameter:(NSString*)param
{
    //リクエスト用のパラメータを設定
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",self.rootUrl,subDirName,subSubDirName];
    NSURL * url = [NSURL URLWithString:urlStr];
    
    // POSTのHTTPリクエストを作成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30]; // タイムアウトを30秒に設定
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 同期通信で送信
    NSURLResponse *response;
    NSError *postError;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&postError];
    NSLog(@"postError:%@", [postError localizedDescription]);
    
    // -- テスト用始め JSONをパース
    NSError * parseError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
    
    NSLog(@"parseError:%@",[parseError localizedDescription]);
    NSLog(@"%@",jsonArray);
    // -- テスト用終わり
    
    return jsonData;
}

// 編集したアイテムをPOSTするメソッド
- (void)postEditItemDataToServerWithImage:(UIImage *)image itemId:(NSString *)itemId memoText:(NSString *)memoText
{
    NSString * userId = self.userId;
    // URLを設定する
    NSURL* url = [NSURL URLWithString:@"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com/items/edit_item"];
    
    // リクエストを作成する
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // HTTPヘッダのContent-Typeを設定する
    NSString *boundary = @"0xKhTmLbOuNdArY"; // 境界線を示す文字列
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // postするbodyデータ
    NSMutableData *body = [NSMutableData data];
    
    // user_idのパラメータを設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    //　userIdをデータに追加
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", userId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // item_idのパラメータを設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"item_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    // itemIdをデータに追加
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", itemId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // memoのパラメータを設定
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"memo"] dataUsingEncoding:NSUTF8StringEncoding]];
    // memoTextをデータに追加
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", memoText] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 画像データをデータに追加
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4); //40%の画質に設定してイメージデータを作成
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // imageのパラメータを設定
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",@"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // POST用のリクエストにbodyデータをセット
    [request setHTTPBody:body];
    
    // リクエストにURLをセット
    [request setURL:url];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);


}


 
//---------- 実際にサーバからデータを削除するメソッド ----------
- (NSData *)removeDataFromServerWithSubDirName: (NSString *)subDirName subSubDirName:(NSString*)subSubDirName parameter:(NSString*)param
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@/%@?%@", self.rootUrl, subDirName, subSubDirName, param];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30]; // タイムアウトを30秒に設定
    
    //サーバーからJSONを取得
    NSError * getError;
    NSData * jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&getError];
    NSLog(@"%@", [getError localizedDescription]);
    
    //-- テスト用始め JSONをパース
    NSError * parseError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
    
    NSLog(@"%@",[parseError localizedDescription]);
    NSLog(@"%@",jsonArray);
    //-- テスト用終わり
    
    return jsonData;
}

//---------- ここから個別のgetメソッド ----------
// すべてのアイテムリスト(カテゴリ別ページ)を取得するメソッド
- (NSData *)getItemListJson
{
    NSString * subDirName = @"items";
    NSString * fileName = @"list";
    NSString * param = [NSString stringWithFormat:@"user_id=%@", self.userId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}
// アイテム詳細を取得するメソッド
- (NSData *)getItemDetailJson : (NSString *)itemId
{
    NSString * subDirName = @"items";
    NSString * fileName = @"detail";
    NSString * param = [NSString stringWithFormat:@"user_id=%@&item_id=%@", self.userId, itemId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}
// 同じグループのユーザを取得するメソッド
- (NSData *)getUserListJson
{
    NSString * subDirName = @"users";
    NSString * fileName = @"list";
    NSString * param = [NSString stringWithFormat:@"user_id=%@", self.userId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}
// ユーザ詳細を取得するメソッド
- (NSData *)getUserDetailJson
{
    NSString * subDirName = @"users";
    NSString * fileName = @"detail";
    NSString * param = [NSString stringWithFormat:@"user_id=%@", self.userId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}
// お使いリストを取得するメソッド
- (NSData *)getMissionListJson
{
    NSString * subDirName = @"missions";
    NSString * fileName = @"list";
    NSString * param = [NSString stringWithFormat:@"user_id=%@", self.userId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}
// お使いの詳細を取得するメソッド
- (NSData *)getMissionDetailJson : (NSString *)missionId
{
    NSString * subDirName = @"missions";
    NSString * fileName = @"detail";
    NSString * param = [NSString stringWithFormat:@"mission_id=%@", missionId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}
// 買う物リストを取得するメソッド
- (NSData *)getBuyListJson
{
    NSString * subDirName = @"buylists";
    NSString * fileName = @"list";
    NSString * param = [NSString stringWithFormat:@"user_id=%@", self.userId];
    NSData *jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}

// お知らせ一覧を取得するメソッド
- (NSData *)getHistoryListJson
{
    NSString * subDirName = @"histories";
    NSString * fileName = @"list";
    NSString * param = [NSString stringWithFormat:@"user_id=%@", self.userId];
    NSData * jsonData = [self getJsonFromServerWithSubDirName:subDirName fileName:fileName parameter:param];
    return jsonData;
}

//---------- ここまで個別のgetメソッド ----------

//---------- ここから個別のpostメソッド ----------

- (void)postMissionData: (NSString *)targetId memoText:(NSString *)memoText itemIdArray:(NSArray *)itemIdArray;
{
    NSString * subDirName = @"missions";
    NSString * subSubDirName = @"add_mission";
    NSMutableString * itemIds = [NSMutableString stringWithString:@""];
    for (int i=0; i<itemIdArray.count; i++) {
        [itemIds appendFormat:@"item_ids[]=%@", itemIdArray[i]];
        if (i!=itemIdArray.count-1) {
            [itemIds appendString:@"&"];
        }
    }
    NSString * param = [NSString stringWithFormat:@"user_id=%@&target_id=%@&memo=%@&%@", self.userId, targetId, memoText, itemIds];
    [self postDataToServerWithSubDirName:subDirName subSubDirName:subSubDirName parameter:param];
}

- (void)postBuyListData: (NSString *)itemId
{
    NSString * subDirName = @"buylists";
    NSString * subSubDirName = @"add_buylist";
    NSString * param = [NSString stringWithFormat:@"user_id=%@&item_id=%@", self.userId, itemId];
    [self postDataToServerWithSubDirName:subDirName subSubDirName:subSubDirName parameter:param];
}




//---------- ここまで個別のpostメソッド ----------

//---------- ここから個別のremoveメソッド ----------
- (NSData *)removeBuyListItemData: (NSString *)buyListId
{
    NSString * subDirName = @"buylists";
    NSString * subSubDirName = @"remove_buylist";
    NSString * param = [NSString stringWithFormat:@"buylist_id=%@",buyListId];
    NSData *jsonData = [self removeDataFromServerWithSubDirName:subDirName subSubDirName:subSubDirName parameter:param];
    return jsonData;
}
//---------- ここまで個別のremoveメソッド ----------

@end