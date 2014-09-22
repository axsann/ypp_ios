//
//  NetworkManager.h
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
-(NSData *)getItemsListJson;
-(NSData *)getItemsDetailJson: (NSString*)itemId;
-(NSData *)getUsersListJson;
-(NSData *)getUsersDetailJson;
-(NSData *)getMissionsListJson;
-(NSData *)getMissionsDetailJson: (NSString*)missionId;
-(NSData *)getBuylistsListJson;

//-(NSData *)postMissionData: (NSString *)targetId Memo:(NSString *)memo IsAccepted:(BOOL)isAccepted itemIdArray:(NSArray *)itemIdArray;
-(NSData *)postMissionAcceptData: (NSString *)missionId;
-(NSData *)postBuylistData: (NSString *)itemId;

@end