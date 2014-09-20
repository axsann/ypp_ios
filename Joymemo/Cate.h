//
//  Cate.h
//  Joymemo
//
//  Created by kanta on 2014/09/18.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Cate : NSObject
@property (strong, nonatomic) NSMutableArray * cateNameArray;
@property (strong, nonatomic) NSMutableDictionary * cateDict;
- (void)loadJSON:(NSString *)fileName;
@end
