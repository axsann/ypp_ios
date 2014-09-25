//
//  NetworkManager.h
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * rootUrl;
-(NSData *)getItemListJson;
-(NSData *)getItemDetailJson: (NSString*)itemId;
-(NSData *)getUserListJson;
-(NSData *)getUserDetailJson;
-(NSData *)getMissionListJson;
-(NSData *)getMissionDetailJson: (NSString*)missionId;
-(NSData *)getBuyListJson;

-(void)postMissionData: (NSString *)targetId memoText:(NSString *)memoText itemIdArray:(NSArray *)itemIdArray;
-(void)postBuyListData: (NSString *)itemId;

-(NSData *)removeBuyListItemData: (NSString *)buyListId;


@end