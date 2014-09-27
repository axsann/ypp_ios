//
//  PagingViewController.m
//  
//
//  Created by kanta on 2014/09/27.
//
//

#import "PagingViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "AppDelegate.h"
#import "CategoryTableController.h"
#import "SVProgressHUD.h"


@interface PagingViewController ()
@property (strong, nonatomic) TTScrollSlidingPagesController *slider;

@end

@implementation PagingViewController {
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
    // AppDelegateをインスタンス化
    app = [[UIApplication sharedApplication] delegate];

    //initial setup of the TTScrollSlidingPagesController.
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titleScrollerTextFont = [UIFont boldSystemFontOfSize:17];
    self.slider.titleScrollerTextColour = app.joymemoColor;
    self.slider.titleScrollerInActiveTextColour = [UIColor grayColor];
    self.slider.titleScrollerBottomEdgeColour = app.tableCellSeparatorColor;
    self.slider.titleScrollerBottomEdgeHeight = 10;
    self.slider.titleScrollerHidden = NO;
    self.slider.titleScrollerHeight = 54;
    self.slider.titleScrollerItemWidth=106;
    self.slider.disableUIPageControl = NO;
    self.slider.titleScrollerBackgroundColour = [UIColor whiteColor];
    self.slider.triangleBackgroundColour = app.tableCellSeparatorColor;
    self.slider.disableTitleScrollerShadow = YES;
    self.slider.zoomOutAnimationDisabled = YES;
    self.slider.disableTitleShadow = YES;

    //set the datasource.
    self.slider.dataSource = self;
    // 背景色を設定
    self.slider.view.backgroundColor = app.bgColor;

    int uiPagerControlHeight = 20; //TTScrollSlidingPagesControllerで固定した高さ
    // スライダービューのフレームサイズを設定
    self.slider.view.frame = CGRectMake(0, -uiPagerControlHeight, 320, self.view.bounds.size.height-self.tabBarController.tabBar.bounds.size.height+uiPagerControlHeight);
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];
    
    // 遷移先のビューでの戻るボタンのラベルを設定
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    // cateを初期化
    self.cate = [[Cate alloc]init];
    [self loadJson];
    
    // タブバーにツールバーを設置する
    [self makeToolbarAboveTabbar];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(loadJsonAndRefreshPages) withObject:nil afterDelay:0.1];

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

#pragma mark TTSlidingPagesDataSource methods
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    // タブの数
    return self.cate.cateNameArray.count;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    // タブ番号に対応するUIViewControllerを返す
    CategoryTableController * categoryTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryTableController"];
    // index番号のカテゴリ名を取得
    NSString * cateName = [NSString stringWithString:self.cate.cateNameArray[index]];
    // アイテムをテーブルビューにコピー
    //categoryTableController.itemArray = [NSMutableArray arrayWithArray:[app.cats.itemInCategoryDict objectForKey:cateName]];
    categoryTableController.itemArray = [NSMutableArray arrayWithArray:[self.cate.itemInCateDict objectForKey:cateName]];
    // カテゴリ名をテーブルビューにコピー
    categoryTableController.cateName = [NSString stringWithString:cateName];
    // navigationItemのポインタを渡す
    categoryTableController.navItem = self.navigationItem;
    // ヘッダーのimageViewを作成
    UIImageView * headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 126.5)];
    headerImageView.image = [UIImage imageNamed:self.cate.cateHeaderImageNameArray[index]];
    // ヘッダーのイメージビューをテーブルビューにコピー
    categoryTableController.headerImageView = headerImageView;
    
    return [[TTSlidingPage alloc] initWithContentViewController:categoryTableController];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    NSString * cateName = self.cate.cateNameArray[index];
    TTSlidingPageTitle *title = [[TTSlidingPageTitle alloc] initWithHeaderText:cateName];
    
    return title;
}

#pragma mark - delegate
-(void)didScrollToViewAtIndex:(NSUInteger)index
{
    NSLog(@"scrolled to view");
}

- (void)loadJson
{
    // JSONファイルを読み込む
    [self.cate loadJson:[app.netManager getItemListJson]];
}

-(void)loadJsonAndRefreshPages
{
    [self loadJson];
    [self.slider reloadPages];
    [SVProgressHUD dismiss];
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
    //UITabBar *tabbar = self.tabBarController.tabBar;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //float tabbarHeight = tabbar.frame.size.height;
    float toolbarHeight = app.toolbar.frame.size.height;
    // ツールバーを非表示にしてタブバーを再表示させる
    app.toolbar.frame = CGRectMake(0.0f, screenHeight, 320.0f, toolbarHeight);
    self.navigationItem.rightBarButtonItem = nil;
    
}


@end
