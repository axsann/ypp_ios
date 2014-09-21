//
//  NetworkManager.m
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager


-(NSData *)connectServer: (NSString *)dir1 :(NSString*)dir2 item_id:(NSString*)item_id
{
    //.jsonを一時的にぬいてます
    NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@.json?user_id=367533951&item_id=%@",orign,dir1,dir2,item_id];

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

-(NSData *)setData: (NSString *)dir1 :(NSString*)dir2 item_id:(NSString*)item_id
{
    //リクエスト用のパラメータを設定
    NSString *param = [NSString stringWithFormat:@"user_id=367533951&item_id=%@",item_id];
    NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",orign,dir1,dir2];
    
    //リクエストを生成
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:20];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    //同期通信で送信
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    /*
    // 送信したいURLを作成する
    NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *stringurl = [NSString stringWithFormat:@"%@/%@/%@",orign,dir1,dir2];
    NSURL *url = [NSURLURLWithString:stringurl];
    // Mutableなインスタンスを作成し、インスタンスの内容を変更できるようにする
    NSMutableURLRequest *request = [[NSMutableURLRequestalloc] initWithURL:url];
    MethodにPOSTを指定する。
    request.HTTPMethod = @"POST";
    
    
    
    //NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *stringurl = [NSString stringWithFormat:@"%@/%@/%@",orign,dir1,dir2];
    NSURL *url = [NSURL URLWithString:stringurl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // POSTパラメーターを設定
    NSString *param = [NSString stringWithFormat:@"user_id=367533951&item_id=%@",item_id];
    
    [request requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    //サーバーとの通信
    NSError * errorJson;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorJson];
    NSLog(@"%@", [errorJson localizedDescription]);
    
    */
    
    //テスト用 JSONをパース
    NSError * errorParse;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&errorParse];
    
    NSLog(@"%@",[errorParse localizedDescription]);
    NSLog(@"%@",jsonArray);
    
    return jsonData;
}
-(NSData *)getItemsListJson
{
    
    NSString * dir1 = @"items";
    NSString * dir2 = @"list";
    NSString * item_id = @"";
    
    NSData *jsonData = [self connectServer:dir1 :dir2 item_id:item_id];
    
    return jsonData;
}

-(NSData *)getItemsDetailJson : (NSString *)item_id
{
    
    NSString * dir1 = @"items";
    NSString * dir2 = @"detail";
    
    NSData *jsonData = [self connectServer:dir1 :dir2 item_id:item_id];
    
    return jsonData;
}

-(NSData *)getBuyListsJson
{
    
    NSString * dir1 = @"buylists";
    NSString * dir2 = @"list";
    NSString * item_id = @"";
    
    NSData *jsonData = [self connectServer:dir1 :dir2 item_id:item_id];
    
    return jsonData;
}


-(NSData *)addBuyListsJson : (NSString *)item_id
{
    
    NSString * dir1 = @"buylists";
    NSString * dir2 = @"add_buylist";
    NSData *jsonData = [self setData :dir1 :dir2 item_id:item_id];
    
    return jsonData;
}

@end
