//
//  PageController.m
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//
#import "PageController.h"
#import "AppDelegate.h"
#import "CategoryTableController.h"
#import "AccountTableViewController.h"
#import "MBProgressHUD.h"


@interface PageController ()
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager;
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index;
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value;
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color;
- (void)makeToolbarAboveTabbar;
- (void)checkModeOff;

@end

@implementation PageController{
    AppDelegate * app;
    MBProgressHUD * _progressHUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    // AppDelegateをインスタンス化
    app = [[UIApplication sharedApplication] delegate];
    // 遷移先のビューでの戻るボタンのラベルを設定
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    _progressHUD = [[MBProgressHUD alloc]initWithView:self.view]; // 更新時のくるくるを初期化
    [self.view addSubview:_progressHUD];
    _progressHUD.labelText = @"アイテムを再読み込みしています";
    [self addAccountButton];
    
    [self loadJson]; // カテゴリー別アイテムのJsonを読み込む
    
    // タブバーにツールバーを設置する
    [self makeToolbarAboveTabbar];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // アイテム詳細が変更されたときのみ、Jsonとビューを再読み込みする
    if (app.itemDetailChanged) {
        [_progressHUD show:YES];
        [self performSelector:@selector(loadJsonAndRefreshView) withObject:nil afterDelay:0.001];
        app.itemDetailChanged = NO;
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    // タブバーでビューを切り替えたときにチェックモードをオフにする
    [self checkModeOff];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    // タブの数
    return app.cate.cateNameArray.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    NSString * cateName = app.cate.cateNameArray[index];
    // タブに表示するView、今回はUILabelを使用
    UILabel* label = [UILabel new];
    //label.text = [NSString stringWithFormat:@"Tab #%lu", (unsigned long)index];
    //label.text = [NSString stringWithString:catNameArray[index]];
    //label.textColor = [UIColor redColor];
    label.text = [NSString stringWithString:cateName];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    // タブ番号に対応するUIViewControllerを返す
    CategoryTableController * categoryTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryTableController"];
    // index番号のカテゴリ名を取得
    NSString * cateName = [NSString stringWithString:app.cate.cateNameArray[index]];
    // アイテムをテーブルビューにコピー
    //categoryTableController.itemArray = [NSMutableArray arrayWithArray:[app.cats.itemInCategoryDict objectForKey:cateName]];
    categoryTableController.itemArray = [NSMutableArray arrayWithArray:[app.cate.itemInCateDict objectForKey:cateName]];
    // カテゴリ名をテーブルビューにコピー
    categoryTableController.cateName = [NSString stringWithString:cateName];
    // navigationItemのポインタを渡す
    categoryTableController.navItem = self.navigationItem;
    // ヘッダーのimageViewを作成
    UIImageView * headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 126.5)];
    headerImageView.image = [UIImage imageNamed:app.cate.cateHeaderImageNameArray[index]];
    // ヘッダーのイメージビューをテーブルビューにコピー
    categoryTableController.headerImageView = headerImageView;
    
    return categoryTableController;
}

// 上部タブのサイズを変更
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionTabHeight:
            return 44.0;
        case ViewPagerOptionTabOffset:
            return 106.0;
        case ViewPagerOptionTabWidth:
            return 106.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return NAN;
    }
}

// 上部タブのインディケーターの色を変更
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    
    switch (component) {
        case ViewPagerIndicator:
            return [app.joymemoColor colorWithAlphaComponent:0.64];
            
        case ViewPagerTabsView:
            return [UIColor whiteColor];
        case ViewPagerContent:
            return app.bgColor; // 背景色を設定
        default:
            return color;
    }
}

- (void)loadJson
{
    // JSONファイルを読み込む
    [app.cate loadJson:[app.netManager getItemListJson]];
}

- (void)loadJsonAndRefreshView
{
    [self loadJson];
    [self reloadData];
    [_progressHUD hide:YES afterDelay:0.5];
}

// タブバーにツールバーを作成する
- (void)makeToolbarAboveTabbar {
    //UITabBar *tabbar = self.tabBarController.tabBar;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //float tabbarHeight = tabbar.frame.size.height;
    float toolbarHeight = 60.0f;
    app.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, screenHeight, 320.0f, toolbarHeight)];
    
    [self.tabBarController.view addSubview:app.toolbar];
}

// チェックと同時にタブバーを押した場合はチェックモードをオフにする
- (void)checkModeOff
{
    // チェックアレイから全てのオブジェクトを削除
    [app.checkArray removeAllObjects];
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    float toolbarHeight = app.toolbar.frame.size.height;
    // ツールバーを非表示にしてタブバーを再表示させる
    app.toolbar.frame = CGRectMake(0.0f, screenHeight, 320.0f, toolbarHeight);
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addAccountButton
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"アカウント"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(accountButtonTapped)];
}

- (void)accountButtonTapped
{
    AccountTableViewController * accountTableViewController = [AccountTableViewController new];
    accountTableViewController.hidesBottomBarWhenPushed = YES; // 遷移先でタブバーを隠す
    // アニメーションを作成
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    // navigationControllerにアニメーションを設定
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:accountTableViewController animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
