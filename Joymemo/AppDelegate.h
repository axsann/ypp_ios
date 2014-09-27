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
@property (strong, nonatomic) NSMutableArray * postBuyListArray;
@property (strong, nonatomic) NSMutableArray * checkArray;
@property (strong, nonatomic) UIToolbar * toolbar; // タブバーに設置するツールバー
@property (strong, nonatomic) UIColor * joymemoColor; // joymemoのテーマカラー
@property (strong, nonatomic) UIColor * tableCellSeparatorColor; // テーブルビューのセルの境界線の色
@property (strong, nonatomic) UIColor * textViewBorderColor; // テキストビューのボーダーの色
@property (strong, nonatomic) UIColor * bgColor; // 背景色
@property (strong, nonatomic) Cate * cate; // カテゴリー別のアイテムを読み込む
@property (strong, nonatomic) NetworkManager * netManager; // サーバと通信を行う
@property BOOL itemDetailChanged;
@end
