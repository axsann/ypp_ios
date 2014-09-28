//
//  AppDelegate.m
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "AppDelegate.h"
#import "Item.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.netManager = [[NetworkManager alloc]init]; // netManagerを初期化

    self.postBuyListArray = [NSMutableArray array]; // buyArrayを初期化
    self.cate = [[Cate alloc]init]; // cateを初期化
    self.checkArray = [NSMutableArray array]; // checkArrayを初期化
    // joymemoのテーマカラーを格納
    self.joymemoColor = [UIColor colorWithRed:(218.0f/255.0f) green: (80.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f];
    // ナビゲーションバーのタイトルの色を設定
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:self.joymemoColor};

    // 背景色を格納
    self.bgColor = [UIColor colorWithRed:246/255.0 green:241/255.0 blue:234/255.0 alpha:1.0];
    // テーブルビューのセルの境界線の色を格納(背景色と同じ)
    self.tableCellSeparatorColor = self.bgColor;
    // テキストビューのボーダーの色を格納
    self.textViewBorderColor = [UIColor colorWithRed:244/255.0 green:196/255.0 blue:173/255.0 alpha:1.0];
    
    // タイトルロゴのビューを作成
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 34)];
    logoImageView.image = [UIImage imageNamed:@"logotype_Joymemo500x171.png"];
    logoImageView.backgroundColor = [UIColor clearColor];
    [logoImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.logoView = [[UIView alloc]initWithFrame:logoImageView.frame];
    self.logoView.backgroundColor = [UIColor clearColor];
    [self.logoView addSubview:logoImageView];
    
    // タブバーの選択時のハイライト色を変更
    [[UITabBar appearance] setTintColor:self.joymemoColor];


    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
