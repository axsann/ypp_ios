//
//  NetworkManager.m
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager


/************** データを取得するmain関数 *******************/
-(NSData *)getData: (NSString *)directory1 :(NSString*)directory2 parameter:(NSString*)param
{
    NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@.json?user_id=367533951&%@",orign,directory1,directory2,param];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[request HTTPMethod:@"POST"];
    
    //サーバーとの通信
    NSError * errorJson;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorJson];
    NSLog(@"%@", [errorJson localizedDescription]);
    
    //テスト用 JSONをパース
    NSError * errorParse;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&errorParse];
    
    NSLog(@"%@",[errorParse localizedDescription]);
    NSLog(@"%@",jsonArray);
    
    return jsonData;
}

/************** データを追加するmain関数 *******************/
-(NSData *)setData: (NSString *)directory1 :(NSString*)directory2 parameter:(NSString*)param
{
    //リクエスト用のパラメータを設定
    NSString *postparameter = [NSString stringWithFormat:@"user_id=367533951&%@",param];
    NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",orign,directory1,directory2];
    
    //リクエストを生成
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[postparameter dataUsingEncoding:NSUTF8StringEncoding]];
    
    //同期通信で送信
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //テスト用 JSONをパース
    NSError * errorParse;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&errorParse];
    
    NSLog(@"%@",[errorParse localizedDescription]);
    NSLog(@"%@",jsonArray);
    
    return jsonData;
}


/************** ここから個別のget関数 *******************/
-(NSData *)getItemsListJson
{
    NSString * directory1 = @"items";
    NSString * directory2 = @"list";
    NSData *jsonData = [self getData:directory1 :directory2 parameter:@""];
    return jsonData;
}

-(NSData *)getItemsDetailJson : (NSString *)item_id
{
    NSString * directory1 = @"items";
    NSString * directory2 = @"detail";
    NSString * param = [NSString stringWithFormat:@"item_id=%@",item_id];
    NSData *jsonData = [self getData:directory1 :directory2 parameter:param];
    return jsonData;
}

-(NSData *)getUsersListJson
{
    NSString * directory1 = @"items";
    NSString * directory2 = @"list";
    NSData *jsonData = [self getData:directory1 :directory2 parameter:@""];
    return jsonData;
}

-(NSData *)getUsersDetailJson
{
    NSString * directory1 = @"users";
    NSString * directory2 = @"detail";
    NSData *jsonData = [self getData:directory1 :directory2 parameter:@""];
    return jsonData;
}

-(NSData *)getMissionsListJson
{
    NSString * directory1 = @"missions";
    NSString * directory2 = @"list";
    NSData *jsonData = [self getData:directory1 :directory2 parameter:@""];
    return jsonData;
}

-(NSData *)getMissionsDetailJson : (NSString *)mission_id
{
    NSString * directory1 = @"missions";
    NSString * directory2 = @"detail";
    NSString * param = [NSString stringWithFormat:@"mission_id=%@",mission_id];
    NSData *jsonData = [self getData:directory1 :directory2 parameter:param];
    return jsonData;
}

-(NSData *)getBuylistsListJson
{
    NSString * directory1 = @"buylists";
    NSString * directory2 = @"list";
    NSData *jsonData = [self getData:directory1 :directory2 parameter:@""];
    return jsonData;
}

/************** ここから個別のset関数 *******************/
-(NSData *)addMissionJson:(NSString *)target_id memotxt:(NSString *)memo acceptbool:accepted itemArray:(NSArray *)item_ids
{
    NSString * directory1 = @"missions";
    NSString * directory2 = @"add_mission";
    NSString * param = [NSString stringWithFormat:@"target_id=%@&memo=%@&accepted=%@&items[]",target_id];
    NSData *jsonData = [self setData :directory1 :directory2 parameter:@""];
    return jsonData;
}

-(NSData *)addMissionAcceptJson : (NSString *)mission_id
{
    NSString * directory1 = @"missions";
    NSString * directory2 = @"accept";
    NSString * param = [NSString stringWithFormat:@"mission_id=%@",mission_id];
    NSData *jsonData = [self setData :directory1 :directory2 parameter:param];
    return jsonData;
}

-(NSData *)addBuylistJson : (NSString *)item_id
{
    NSString * directory1 = @"buylists";
    NSString * directory2 = @"add_buylist";
    NSString * param = [NSString stringWithFormat:@"item_id=%@",item_id];
    NSData *jsonData = [self setData :directory1 :directory2 parameter:param];
    return jsonData;
}

@end
