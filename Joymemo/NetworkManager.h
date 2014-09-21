//
//  NetworkManager.h
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
-(NSData *)getData: (NSString*)directory1 :(NSString*)directory2 parameter:(NSString*)param;

-(NSData *)getItemsListJson;
-(NSData *)getItemsDetailJson: (NSString*)item_id;
-(NSData *)getUsersListJson;
-(NSData *)getUsersDetailJson;
-(NSData *)getMissionsListJson;
-(NSData *)getMissionsDetailJson: (NSString*)mission_id;
-(NSData *)getBuylistsListJson;

-(NSData *)addMissionJson:(NSString *)target_id memotxt:(NSString *)memo acceptbool:accepted itemArray:(NSArray *)item_ids;
-(NSData *)addMissionAcceptJson:(NSString *)mission_id;
-(NSData *)addBuylistJson: (NSString *)item_id;

@end
