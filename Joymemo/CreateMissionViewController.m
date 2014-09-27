//
//  CreateMissionViewController.m
//  Joymemo
//
//  Created by kanta on 2014/09/25.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "CreateMissionViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "Item.h"
#import "QuartzCore/CALayer.h"
#import "MBProgressHUD.h"

@interface CreateMissionViewController ()
@property (strong, nonatomic) UIScrollView * scrollView;
@end

@implementation CreateMissionViewController {
    AppDelegate * app;
    CGFloat _userIconWidthHeight;
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
    // AppDelegateをインスタンス化
    app = [[UIApplication sharedApplication] delegate];
    // 背景色を設定
    self.view.backgroundColor = app.bgColor;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToCategory)];
    self.navigationItem.title = @"おつかい依頼";
    // scrollViewのコンテンツのサイズを設定
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.scrollView setContentSize:CGSizeMake(320, 540)];
    // スクロールさせるとキーボードを閉じる
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadJsonAndRefreshViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToCategory
{
    // アニメーションを作成
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    // navigationControllerにアニメーションを設定
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)loadJsonAndRefreshViews
{
    [self addUsersView];
    [self addMemoView];
    [self addItemView];
    [self addPostButton];
}

// お使いを依頼したい人のビューを追加
- (void)addUsersView
{
    UIImageView * userView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 320, 126)];
    userView.image = [UIImage imageNamed:@"otukaiiraiwoshitaihito.png"];
    [self.scrollView addSubview:userView];
    NSData * userListJsonData = [app.netManager getUserListJson];
    NSArray * userListArray = [NSJSONSerialization JSONObjectWithData:userListJsonData
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
    self.otherUserArray = [NSMutableArray array];
    for (int i=0; i<userListArray.count; i++) {
        NSDictionary * userDict = userListArray[i];
        // user_idが自分のものでなければuser_nameをotherUserNameArrayに追加する
        if (![userDict[@"user_id"] isEqualToString:app.netManager.userId]){
            [self.otherUserArray addObject:userListArray[i]];
        }
    }
    UIScrollView * userScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 46, 300, 90)];
    // ユーザリスト用のスクロールビューのコンテンツサイズをアイテムの数に合わせる
    [userScrollView setContentSize:CGSizeMake(self.otherUserArray.count*70, 90)];
    for (int i=0; i<self.otherUserArray.count; i++) {
        NSDictionary * userDict = self.otherUserArray[i];
        NSString * userName = userDict[@"user_name"];
        NSURL * userIconImageUrl = [NSURL URLWithString:userDict[@"icon"]];
        _userIconWidthHeight = 60;
        CGRect userIconFrame = CGRectMake(70*i, 10, _userIconWidthHeight, _userIconWidthHeight);
        UIImageView * userIconImageView = [[UIImageView alloc]initWithFrame:userIconFrame];
        [userIconImageView sd_setImageWithURL:userIconImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
        UIButton * userIconButton = [[UIButton alloc]initWithFrame:userIconFrame];
        [userIconButton addTarget:self action:@selector(userIconButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        userIconButton.tag = i+1; // userIconButtonのタグをi+1に設定
        
        // 円形に切り抜く
        userIconImageView.layer.cornerRadius = userIconImageView.frame.size.width * 0.5f;
        userIconImageView.clipsToBounds = YES;
        // ユーザ名のラベルを設定
        UILabel * userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70*i, 68, _userIconWidthHeight, 30)];
        userNameLabel.text = userName;
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.font = [UIFont systemFontOfSize:11.0f];
        [userScrollView addSubview:userIconImageView];
        [userScrollView addSubview:userIconButton];
        [userScrollView addSubview:userNameLabel];

    }
    NSDictionary * userDict = self.otherUserArray[0];
    NSString * userId = userDict[@"user_id"];
    self.selectedUserId = userId; // selectedUserIdに一番目のユーザのIDを格納する
    // チェックマークを一番目のユーザアイコンの位置にする
    self.userCheckImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, _userIconWidthHeight, _userIconWidthHeight)];
    self.userCheckImageView.image = [UIImage imageNamed:@"select_user_circle.png"];
    [userScrollView addSubview:self.userCheckImageView];
    [self.scrollView addSubview:userScrollView];
}


// お使いメモのビューを追加
- (void)addMemoView
{
    UIImageView * memoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 154, 320, 118)];
    memoView.image = [UIImage imageNamed:@"otukaimemo.png"];
    [self.scrollView addSubview:memoView];
    self.memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 184, 300, 84)];
    self.memoTextView.delegate = self; // メモテキストビューのデリゲートを渡す
    self.memoTextView.text = @"おつかいをお願いします。";
    self.memoTextView.font = [UIFont systemFontOfSize:15.0f];
    [self.scrollView addSubview:self.memoTextView];
}

// お使いで買うもののビューを追加
- (void)addItemView
{
    UIImageView * itemView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 286, 320, 119)];
    itemView.image = [UIImage imageNamed:@"otukaidekaumono.png"];
    [self.scrollView addSubview:itemView];
    
    UIScrollView * itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 318, 300, 80)];
    // アイテム用のスクロールビューのコンテンツサイズをアイテムの数に合わせる
    [itemScrollView setContentSize:CGSizeMake(self.itemIdArray.count*70, 80)];
    for (int i=0; i<self.itemIdArray.count; i++) {
        NSString * itemId = self.itemIdArray[i];
        NSData * itemJsonData = [app.netManager getItemDetailJson:itemId];
        NSDictionary * itemDict = [NSJSONSerialization JSONObjectWithData:itemJsonData
                                        options:NSJSONReadingAllowFragments
                                          error:nil];
        NSString * itemName = itemDict[@"item_name"];
        NSURL * itemImageUrl = [NSURL URLWithString:itemDict[@"image"]];
        UIImageView * itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70*i, 0, 60, 60)];
        [itemImageView sd_setImageWithURL:itemImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
        UILabel * itemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70*i, 60, 60, 30)];
        itemNameLabel.text = itemName;
        itemNameLabel.textAlignment = NSTextAlignmentCenter;
        itemNameLabel.font = [UIFont systemFontOfSize:11.0f];
        [itemScrollView addSubview:itemImageView];
        [itemScrollView addSubview:itemNameLabel];
        
    }
    [self.scrollView addSubview:itemScrollView];

}

- (void)addPostButton
{
    UIButton * postButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 419, 280, 34.5)];
    postButton.backgroundColor = [UIColor clearColor];
    [postButton setImage:[UIImage imageNamed:@"postButton.png"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:postButton];
}

// ユーザのアイコンをタップしたときの処理
- (void)userIconButtonTapped:(UIButton *)button
{
    // selectedUserIdに選択したユーザのIDを格納する
    NSDictionary * userDict = self.otherUserArray[button.tag-1];
    NSString * userId = userDict[@"user_id"];
    NSLog(@"%@", userId);
    self.selectedUserId = userId;
    
    self.userCheckImageView.frame = CGRectMake(button.frame.origin.x, 10, _userIconWidthHeight, _userIconWidthHeight);
}

// 送信ボタンをタップしたときの処理
- (void)postButtonTapped:(UIButton *)button
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self postMissionData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)postMissionData
{
    if ([self.memoTextView.text isEqualToString:@""]) {
        self.memoTextView.text = @"　";
    }
    [app.netManager postMissionData:self.selectedUserId memoText:self.memoTextView.text itemIdArray:self.itemIdArray];
    //アラートを作成
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"おつかい依頼を送信しました！"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil
                          ];
    // アラートを自動で閉じる秒数をセットするタイマー
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlertAtTimerEnd:) userInfo:alert repeats:NO];
    [alert show];
    [self backToCategory];
}

//-- タイマー終了でアラートを閉じる
- (void)closeAlertAtTimerEnd:(NSTimer*)timer
{
    UIAlertView *alert = [timer userInfo];
    // アラートを自動で閉じる
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// メモのテキストビューを編集開始時に実行される
- (void) textViewDidBeginEditing: (UITextView*) textView
{
    // 編集開始時の処理
    [self.scrollView setContentOffset:CGPointMake(0, 83) animated:YES];
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
