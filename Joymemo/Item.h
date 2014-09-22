//
//  Item.h
//  Joymemo
//
//  Created by kanta on 2014/09/16.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property (strong, nonatomic) NSString * itemId;
@property (strong, nonatomic) NSString * itemName;
@property (strong, nonatomic) NSString * thumb;
@property (strong, nonatomic) NSString * category;
- (void) setItemId:(NSString *)itemId setItemName:(NSString *)itemName setThumb:(NSString *)thumb setCategory:(NSString *)category;

@end
