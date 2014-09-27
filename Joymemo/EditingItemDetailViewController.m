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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完了"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(doneButtonTapped)];
    self.navigationItem.title = @"アイテム編集";
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    // スクロールさせるとキーボードを閉じる
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addView];

    // Do any additional setup after loading the view.
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

/* // 今回は利用しない
- (void)addItemNameView
{
    // アイテム名のセクションタイトル
    UIImageView * itemNameSectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 30.5)];
    itemNameSectionImageView.image = [UIImage imageNamed:@"item_name_section.png"];
    [self.scrollView addSubview:itemNameSectionImageView];
    // アイテム名の入力欄
    self.itemNameTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 56, 300, 40)];
    self.itemNameTextView.font = [UIFont systemFontOfSize:19];
    self.itemNameTextView.text = self.itemName; // アイテム名を入力しておく
    // textView を角丸にする
    [[self.itemNameTextView layer] setCornerRadius:8.0];
    [self.itemNameTextView setClipsToBounds:YES];
    // textView に枠線を付ける
    [[self.itemNameTextView layer] setBorderColor:[[UIColor colorWithRed:(236.0f/255.0f) green: (231.0f/255.0f) blue:(224.0f/255.0f) alpha:1.0f] CGColor]];
    [[self.itemNameTextView layer] setBorderWidth:1.0];

    [self.scrollView addSubview:self.itemNameTextView];
}*/

- (void)addItemImageView
{
    //アイテム写真のセクションタイトル
    UIImageView * itemPictureSectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 320, 30.5)];
    itemPictureSectionImageView.image = [UIImage imageNamed:@"item_picture_section.png"];
    [self.scrollView addSubview:itemPictureSectionImageView];
    // アイテム写真を表示
    self.itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(114, 61, 92, 92)];
    self.itemImageView.image = self.itemImage;
    [self.scrollView addSubview:self.itemImageView];
    // 写真を変更するためのボタンを設置
    UIButton * changeItemImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeItemImageButton setTitle:@"写真を変更する" forState:UIControlStateNormal];
    [changeItemImageButton sizeToFit]; // キャプションに合わせてサイズを設定する
    changeItemImageButton.center = CGPointMake(160, 164);
    changeItemImageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [changeItemImageButton addTarget:self action:@selector(changeItemImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:changeItemImageButton];
}




- (void)addMemoTextView
{
    // メモのセクションタイトル
    UIImageView * memoSectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, 320, 30.5)];
    memoSectionImageView.image = [UIImage imageNamed:@"item_memo_section.png"];
    [self.scrollView addSubview:memoSectionImageView];
    // メモの編集欄を表示
    self.memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 236, 300, 140)];
    self.memoTextView.delegate = self; // メモテキストビューのデリゲートを渡す
    self.memoTextView.font = [UIFont systemFontOfSize:13];
    self.memoTextView.text = self.memoText;
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
                          initWithTitle:@"写真の選択"
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
            [self callCamera];
            break;
            
        case 2:
            //3番目のボタン(ライブラリから選ぶ)が押されたときのアクション
            [self callPhotoLibrary];
            break;
            
        default:
            break;
    }
    
}

- (void)addView
{

    //[self addItemNameView]; // 今回は利用しない
    [self addItemImageView];
    [self addMemoTextView];
    [self.view addSubview:self.scrollView];
}

// メモのテキストビューを編集開始時に実行される
- (void) textViewDidBeginEditing: (UITextView*) textView
{
    // 編集開始時の処理
    [self.scrollView setContentOffset:CGPointMake(0, 124) animated:YES];
}

- (void)callPhotoLibrary
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

- (void)callCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

//カメラ撮影後のデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //撮影した画像データをUIImageにセットする
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.itemImageView.image = pickedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped
{
    app.itemDetailChanged = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(postItemData) withObject:nil afterDelay:0.001];
    [self backToItemDetail];
}

// アイテムデータをサーバにPOSTする
- (void)postItemData
{
    [app.netManager postEditItemDataToServerWithImage:self.itemImageView.image
                                               itemId:self.itemId
                                             memoText:self.memoTextView.text];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
