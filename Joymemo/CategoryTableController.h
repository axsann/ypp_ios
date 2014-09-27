//
//  CategoryTableController.h
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableController : UITableViewController
@property (strong, nonatomic) NSMutableArray * itemArray;
@property (strong, nonatomic) NSString * cateName;
@property (strong, nonatomic) UINavigationItem * navItem;
@property (strong, nonatomic) UIImageView * headerImageView;
@end
