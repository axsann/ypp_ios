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
#import "MBProgressHUD.h"

@interface EditingItemDetailViewController ()
@property (strong, nonatomic) UIScrollView * scrollView;
@end

@implementation EditingItemDetailViewController {
    AppDelegate * app;
    NSDictionary * _itemDict;

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self refreshDataAndView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void)addItemNameView
{
    // アイテム名のセクションタイトル
    UIImageView * itemNameSectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 30.5)];
    itemNameSectionImageView.image = [UIImage imageNamed:@"item_name_section.png"];
    [self.scrollView addSubview:itemNameSectionImageView];
    // アイテム名の入力欄
    self.itemNameTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 56, 300, 40)];
    self.itemNameTextView.font = [UIFont systemFontOfSize:19];
    self.itemNameTextView.text = _itemDict[@"item_name"]; // アイテム名を入力しておく
    // textView を角丸にする
    [[self.itemNameTextView layer] setCornerRadius:8.0];
    [self.itemNameTextView setClipsToBounds:YES];
    // textView に枠線を付ける
    [[self.itemNameTextView layer] setBorderColor:[[UIColor colorWithRed:(236.0f/255.0f) green: (231.0f/255.0f) blue:(224.0f/255.0f) alpha:1.0f] CGColor]];
    [[self.itemNameTextView layer] setBorderWidth:1.0];

    [self.scrollView addSubview:self.itemNameTextView];
}

- (void)addItemImageView
{
    //アイテム写真のセクションタイトル
    UIImageView * itemPictureSectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 111, 320, 30.5)];
    itemPictureSectionImageView.image = [UIImage imageNamed:@"item_picture_section.png"];
    [self.scrollView addSubview:itemPictureSectionImageView];
    // アイテム写真を表示
    NSURL * itemImageUrl = [NSURL URLWithString:_itemDict[@"image"]];
    UIImageView * itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(114, 157, 92, 92)];
    [itemImageView sd_setImageWithURL:itemImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    [self.scrollView addSubview:itemImageView];
    // 写真を変更するためのボタンを設置
    UIButton * changeItemImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeItemImageButton setTitle:@"写真を変更する" forState:UIControlStateNormal];
    [changeItemImageButton sizeToFit]; // キャプションに合わせてサイズを設定する
    changeItemImageButton.center = CGPointMake(160, 265);
    changeItemImageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [changeItemImageButton addTarget:self action:@selector(changeItemImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:changeItemImageButton];
}




- (void)addMemoTextView
{
    // メモのセクションタイトル
    UIImageView * memoSectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 286, 320, 30.5)];
    memoSectionImageView.image = [UIImage imageNamed:@"item_memo_section.png"];
    [self.scrollView addSubview:memoSectionImageView];
    // メモの編集欄を表示
    NSString * memoText = _itemDict[@"memo"] ;
    if (memoText == (id)[NSNull null]) {
        memoText = @"";
    }
    self.memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 332, 300, 140)];
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

- (void)changeItemImageButtonTapped:(UIButton *)button
{
    //アラートビューの生成と設定
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"写真を選択"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"カメラで撮影する"];
    [alert addButtonWithTitle:@"ライブラリから選ぶ"];
    [alert show];
}

// アラートビューのデリゲートメソッド
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //1番目のボタン（cancelButtonTitle）が押されたときのアクション
            break;
            
        case 1:
            //2番目のボタン(カメラで撮影する)が押されたときのアクション
            NSLog(@"2番目");
            self.view.backgroundColor = [UIColor redColor];
            break;
            
        case 2:
            //3番目のボタン(ライブラリから選ぶ)が押されたときのアクション
            NSLog(@"3番目");
            self.view.backgroundColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
    
}

- (void)refreshDataAndView
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }

    NSData * jsonData = [app.netManager getItemDetailJson:self.itemId];
    // 辞書データに変換する
    _itemDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    [self addItemNameView];
    [self addItemImageView];
    [self addMemoTextView];
    [self.view addSubview:self.scrollView];
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
