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

//-(NSData *)postMissionData: (NSString *)targetId Memo:(NSString *)memo IsAccepted:(BOOL)isAccepted itemIdArray:(NSArray *)itemIdArray;
-(NSData *)postMissionAcceptData: (NSString *)missionId;
-(NSData *)postBuyListData: (NSString *)itemId;

-(NSData *)removeBuyListItemData: (NSString *)buyListId;


@end