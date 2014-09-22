//
//  Item.m
//  Joymemo
//
//  Created by kanta on 2014/09/16.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "Item.h"

@implementation Item

- (void) setItemId:(NSString *)itemId setItemName:(NSString *)itemName setThumb:(NSString *)thumb setCategory:(NSString *)category
{
    self.itemId = itemId;
    self.itemName = itemName;
    self.thumb = thumb;
    self.category = category;
}


@end

