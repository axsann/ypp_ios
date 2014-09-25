//
//  NetworkManager.m
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager


//---------- データを取得するメソッド ----------
-(NSData *)getJsonFromUrlWithSubDirName: (NSString *)subDirName FileName:(NSString*)fileName Parameter:(NSString*)param
{
    NSString * rootUrl = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString * url;
    if (param!=nil) {
        url = [NSString stringWithFormat:@"%@/%@/%@.json?user_id=367533951&%@", rootUrl, subDirName, fileName, param];
    }
    else {
        url = [NSString stringWithFormat:@"%@/%@/%@.json?user_id=367533951", rootUrl, subDirName, fileName];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //サーバーからJSONを取得
    NSError * getError;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&getError];
    NSLog(@"%@", [getError localizedDescription]);
    
    //-- テスト用始め JSONをパース
    NSError * parseError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
    
    NSLog(@"%@",[parseError localizedDescription]);
    NSLog(@"%@",jsonArray);
    //-- テスト用終わり
    
    return jsonData;
}

-(NSData *)getJsonFromUrlWithSubDirName: (NSString *)subDirName FileName:(NSString*)fileName
{
    NSData * jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName Parameter:nil];
    return jsonData;
}

//---------- データを追加するメソッド ----------
-(NSData *)postDataToUrlWithSubDirName: (NSString *)subDirName SubSubDirName:(NSString*)subSubDirName Parameter:(NSString*)param
{
    //リクエスト用のパラメータを設定
    NSString *postParam = [NSString stringWithFormat:@"user_id=367533951&%@",param];
    NSString *rootUrl = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rootUrl,subDirName,subSubDirName];
    
    //リクエストを生成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[postParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    //同期通信で送信
    NSURLResponse *response;
    NSError *postError;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&postError];
    
    //-- テスト用始め JSONをパース
    NSError * parseError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
    
    NSLog(@"%@",[parseError localizedDescription]);
    NSLog(@"%@",jsonArray);
    //-- テスト用終わり
    
    return jsonData;
}


//---------- ここから個別のgetメソッド ----------
-(NSData *)getItemsListJson
{
    NSString * subDirName = @"items";
    NSString * fileName = @"list";
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName];
    return jsonData;
}

-(NSData *)getItemsDetailJson : (NSString *)itemId
{
    NSString * subDirName = @"items";
    NSString * fileName = @"detail";
    NSString * param = [NSString stringWithFormat:@"item_id=%@",itemId];
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName Parameter:param];
    return jsonData;
}

-(NSData *)getUsersListJson
{
    NSString * subDirName = @"items";
    NSString * fileName = @"list";
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName];
    return jsonData;
}

-(NSData *)getUsersDetailJson
{
    NSString * subDirName = @"users";
    NSString * fileName = @"detail";
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName];
    return jsonData;
}

-(NSData *)getMissionsListJson
{
    NSString * subDirName = @"missions";
    NSString * fileName = @"list";
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName];
    return jsonData;
}

-(NSData *)getMissionsDetailJson : (NSString *)missionId
{
    NSString * subDirName = @"missions";
    NSString * fileName = @"detail";
    NSString * param = [NSString stringWithFormat:@"mission_id=%@",missionId];
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName Parameter:param];
    return jsonData;
}

-(NSData *)getBuylistsListJson
{
    NSString * subDirName = @"buylists";
    NSString * fileName = @"list";
    NSData *jsonData = [self getJsonFromUrlWithSubDirName:subDirName FileName:fileName];
    return jsonData;
}

//---------- ここから個別のpostメソッド ----------

-(NSData *)postMissionData: (NSString *)targetId Memo:(NSString *)memo IsAccepted:(BOOL)isAccepted itemIdArray:(NSArray *)itemIdArray;
{
    NSString * subDirName = @"missions";
    NSString * subSubDirName = @"add_mission";
    NSString * param = [NSString stringWithFormat:@"target_id=%@&memo=%@&accepted=%@&items[]",targetId];
    NSData *jsonData = [self postDataToUrlWithSubDirName:subDirName SubSubDirName:subSubDirName Parameter:@""];
    return jsonData;
}

-(NSData *)postMissionAcceptData: (NSString *)missionId;
{
    NSString * subDirName = @"missions";
    NSString * subSubDirName = @"accept";
    NSString * param = [NSString stringWithFormat:@"mission_id=%@",missionId];
    NSData *jsonData = [self postDataToUrlWithSubDirName:subDirName SubSubDirName:subSubDirName Parameter:param];
    return jsonData;
}

-(NSData *)postBuylistData: (NSString *)itemId;
{
    NSString * subDirName = @"buylists";
    NSString * subSubDirName = @"add_buylist";
    NSString * param = [NSString stringWithFormat:@"item_id=%@",itemId];
    NSData *jsonData = [self postDataToUrlWithSubDirName:subDirName SubSubDirName:subSubDirName Parameter:param];
    return jsonData;
}

@end