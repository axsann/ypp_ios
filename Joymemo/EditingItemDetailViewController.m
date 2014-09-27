//
//  EditingItemDetailViewController.m
//  Joymemo
//
//  Created by kanta on 2014/09/25.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "EditingItemDetailViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface EditingItemDetailViewController ()
@property (strong, nonatomic) UIScrollView * scrollView;
@end

@implementation EditingItemDetailViewController {
    AppDelegate * app;
    NSDictionary * jsonDict;

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
    // 背景色を設定
    self.view.backgroundColor = app.bgColor;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToItemDetail)];
    self.navigationItem.title = @"アイテム編集";
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    // スクロールさせるとキーボードを閉じる
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(refreshDataAndView) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToItemDetail
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)addItemLargeImageView
{
    
    NSURL * itemImageUrl = [NSURL URLWithString:jsonDict[@"image"]];
    UIImageView * itemLargeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320.0, 320.0)];
    [itemLargeImageView sd_setImageWithURL:itemImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    [self.scrollView addSubview:itemLargeImageView];
    
}

- (void)addMemoTextView
{
    NSString * memoText = jsonDict[@"memo"] ;
    if (memoText == (id)[NSNull null]) {
        memoText = @"";
    }
    self.memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 327, 280, 80)];
    self.memoTextView.delegate = self; // メモテキストビューのデリゲートを渡す
    self.memoTextView.font = [UIFont systemFontOfSize:13];
    self.memoTextView.text = memoText;
    // textView を角丸にする
    [[self.memoTextView layer] setCornerRadius:8.0];
    [self.memoTextView setClipsToBounds:YES];
    // textView に枠線を付ける
    [[self.memoTextView layer] setBorderColor:[[UIColor colorWithRed:(236.0f/255.0f) green: (231.0f/255.0f) blue:(224.0f/255.0f) alpha:1.0f] CGColor]];
    [[self.memoTextView layer] setBorderWidth:1.0];
    
    [self.scrollView addSubview:self.memoTextView];
}

- (void)refreshDataAndView
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }

    NSData * jsonData = [app.netManager getItemDetailJson:self.itemId];
    // 辞書データに変換する
    jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    [self addItemLargeImageView];
    [self addMemoTextView];
    [self.view addSubview:self.scrollView];
    [SVProgressHUD dismiss];
}

// メモのテキストビューを編集開始時に実行される
- (void) textViewDidBeginEditing: (UITextView*) textView
{
    // 編集開始時の処理
    [self.scrollView setContentOffset:CGPointMake(0, 220) animated:YES];
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
