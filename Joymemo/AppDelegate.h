//
//  AppDelegate.h
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cate.h"
#import "NetworkManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray * buyArray;
@property (strong, nonatomic) NSMutableArray * checkArray;
@property (strong, nonatomic) Cate * cate; // カテゴリごとのアイテムを格納する
@property (strong, nonatomic) UIToolbar * toolbar; // タブバーに設置するツールバー
@property (strong, nonatomic) UIColor * joymemoColor; // joymemoのテーマカラー
@property (strong, nonatomic) UIColor * separatorColor; // 境界線の色
@property (strong, nonatomic) UIColor * bgColor; // 背景色
@property (strong, nonatomic) NetworkManager * netManager;
@end
