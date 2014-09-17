//
//  Item.h
//  Joymemo
//
//  Created by kanta on 2014/09/16.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item : NSObject
@property (strong, nonatomic) NSString * itemId;
@property (strong, nonatomic) NSString * itemName;
@property (strong, nonatomic) NSString * itemImgName;
- (void) setItemId:(NSString *)itemId setItemName:(NSString *)itemName setItemImgName:(NSString *)itemImgName;

@end
