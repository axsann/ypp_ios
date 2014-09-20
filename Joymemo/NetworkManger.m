//
//  networkManger.m
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "NetworkManger.h"

@implementation NetworkManger

-(NSData *)getItemsListJson
{
    NSString *orign = @"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com";
    NSString *name = @"items";
    NSString *name2 = @"list";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@.json?user_id=367533951",orign,name,name2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[request HTTPMethod:@"POST"];
    
    //サーバーとの通信を行う
    NSError * errorJson;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorJson];
    NSLog(@"%@", [errorJson localizedDescription]);
    //JSONをパース
    NSError * errorParse;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingAllowFragments error:&errorParse];
    
    NSLog(@"%@",[errorParse localizedDescription]);
    NSLog(@"%@",jsonArray);
    
    
    return jsonData;
}

@end
