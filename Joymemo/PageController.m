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

@interface PageController ()

@end

@implementation PageController{
    AppDelegate * app;
    
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

    // タブバーにツールバーを設置する
    [self makeToolbarAboveTabbar];
    
    // ナビゲーションバーに編集ボタンを設置
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    // toolbarの表示をONにする
    //[self.navigationController setToolbarHidden:NO animated:NO];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    // タブに表示するView、今回はUILabelを使用
    UILabel* label = [UILabel new];
    //label.text = [NSString stringWithFormat:@"Tab #%lu", (unsigned long)index];
    //label.text = [NSString stringWithString:catNameArray[index]];
    //label.textColor = [UIColor redColor];
    label.text = [NSString stringWithString:app.cate.cateNameArray[index]];
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
    categoryTableController.itemArray = [NSMutableArray arrayWithArray:[app.cate.cateDict objectForKey:cateName]];
    // カテゴリ名をテーブルビューにコピー
    categoryTableController.catName = [NSString stringWithString:cateName];
    return categoryTableController;
}

// 上部タブのサイズを変更
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionTabHeight:
            return 44.0;
        case ViewPagerOptionTabOffset:
            return 56.0;
        case ViewPagerOptionTabWidth:
            return 94.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return NAN;
    }
}

// 上部タブのインディケーターの色を変更
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor colorWithRed:(218.0f/255.0f) green: (80.0f/255.0f) blue:(14.0f/255.0f) alpha:1.0f] colorWithAlphaComponent:0.64];
        default:
            return color;
    }
}

// タブバーにツールバーを作成する
- (void)makeToolbarAboveTabbar{
    UITabBar *tabbar = self.tabBarController.tabBar;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    float tabbarHeight = tabbar.frame.size.height;
    app.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, screenHeight, 320.0f, tabbarHeight)];
    
    [self.tabBarController.view addSubview:app.toolbar];
}

// チェックと同時にタブバーを押した場合はチェックモードをオフにする
- (void)checkModeOff
{
    // チェックアレイから全てのオブジェクトを削除
    [app.checkArray removeAllObjects];
    UITabBar *tabbar = self.tabBarController.tabBar;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    float tabbarHeight = tabbar.frame.size.height;
    // ツールバーを非表示にしてタブバーを再表示させる
    app.toolbar.frame = CGRectMake(0.0f, screenHeight, 320.0f, tabbarHeight);
    
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
