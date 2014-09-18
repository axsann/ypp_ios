//
//  networkManager.m
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/19.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "networkManager.h"
#import "AFNetworking.h"

@implementation networkManager {
    
    AFHTTPRequestOperationManager *manager;
    
}

static networkManager *sharedManager = nil;

+(networkManager *) shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [networkManager new];
    });
    return sharedManager;
}

-(id) init
{
    self = [super init];
    if (self) {
        manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return self;
}

-(void) getListData
{
    [manager GET:@"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com/items.json"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSMutableArray *responseObject) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ListData" object:[responseObject mutableCopy]];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error");
         }];
}

-(UIImage *) getThumbURL:(NSString *)url
{
    //AFHTTPRequestOperationを使って画像を取得してUIImageを返す
    return nil;
}

-(void) sendChecks:(NSArray *)checks
{
    [manager POST:@""
       parameters:checks
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
}

@end