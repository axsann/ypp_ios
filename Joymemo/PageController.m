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
    NSMutableArray * catItemArray;
    NSMutableArray * catNameArray;
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
    // ナビゲーションバーに編集ボタンを設置
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // toolbarの表示をONにする
    //[self.navigationController setToolbarHidden:NO animated:NO];
    
    // ファイルから配列にデータを読み込む
    // カテゴリ別のアイテムリストを読み込む
    NSString * dataFile = [[NSBundle mainBundle]pathForResource:@"DataList" ofType:@"plist"];
    catItemArray = [NSMutableArray arrayWithContentsOfFile:dataFile];
    // カテゴリ名を読み込む
    NSString * catNameFile = [[NSBundle mainBundle]pathForResource:@"CatNameList" ofType:@"plist"];
    catNameArray = [NSMutableArray arrayWithContentsOfFile:catNameFile];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    // タブの数
    return catNameArray.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    // タブに表示するView、今回はUILabelを使用
    UILabel* label = [UILabel new];
    //label.text = [NSString stringWithFormat:@"Tab #%lu", (unsigned long)index];
    label.text = [NSString stringWithString:catNameArray[index]];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    // タブ番号に対応するUIViewControllerを返す
    CategoryTableController * categoryTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryTableController"];
    
    // アイテムをテーブルビューにコピー
    categoryTableController.itemArray = [NSMutableArray arrayWithArray:catItemArray[index]];
    // カテゴリ名をテーブルビューにコピー
    categoryTableController.catName = [NSString stringWithString:catNameArray[index]];
    
    //ContentViewController* contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    //contentViewController.labelText = [NSString stringWithFormat:@"Tab #%lu", (unsigned long)index];
    return categoryTableController;
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
