//
//  NetworkManager.h
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/20.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
-(NSData *)connectServer: (NSString*)dir1 :(NSString*)dir2 item_id:(NSString*)item_id;
-(NSData *)getItemsDetailJson: (NSString*)item_id;
-(NSData *)getItemsListJson;
@end
