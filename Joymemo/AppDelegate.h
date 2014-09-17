//
//  AppDelegate.h
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray * checkArray;
@property (strong, nonatomic) Categories * cats;
@property (strong, nonatomic) UIToolbar * toolbar;
@end
