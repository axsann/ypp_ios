//
//  AppDelegate.h
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray * buyArray;
@property (strong, nonatomic) NSMutableArray * checkArray;
@property (strong, nonatomic) Cate * cate;
@property (strong, nonatomic) UIToolbar * toolbar;
@end
