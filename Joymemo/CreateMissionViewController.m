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

@interface CreateMissionViewController ()
@property (strong, nonatomic) UIScrollView * scrollView;
@end

@implementation CreateMissionViewController {
    AppDelegate * app;
    UITextView * _memoTextView;
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
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    [self addViews];

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

- (void)addViews
{
    [self addUsersView];
    [self addMemoView];
    [self addItemView];
}

- (void)addUsersView
{
    UIImageView * userView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 320, 126)];
    userView.image = [UIImage imageNamed:@"otukaiiraiwoshitaihito.png"];
    [self.scrollView addSubview:userView];
}

- (void)addMemoView
{
    UIImageView * memoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 154, 320, 118)];
    memoView.image = [UIImage imageNamed:@"otukaimemo.png"];
    [self.scrollView addSubview:memoView];
    _memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 184, 300, 84)];
    _memoTextView.delegate = self;
    _memoTextView.font = [UIFont systemFontOfSize:15.0f];
    [self.scrollView addSubview:_memoTextView];
}

- (void)addItemView
{
    UIImageView * itemView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 286, 320, 119)];
    itemView.image = [UIImage imageNamed:@"otukaidekaumono.png"];
    [self.scrollView addSubview:itemView];
    
    UIScrollView * itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 318, 300, 80)];
    [itemScrollView setContentSize:CGSizeMake(self.itemIdArray.count*60, 80)];
    for (int i=0; i<self.itemIdArray.count; i++) {
        NSString * itemId = self.itemIdArray[i];
        NSData * jsonData = [app.netManager getItemDetailJson:itemId];
        NSDictionary * itemDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                        options:NSJSONReadingMutableContainers
                                          error:nil];
        NSString * itemName = itemDict[@"item_name"];
        NSURL * itemImageUrl = [NSURL URLWithString:itemDict[@"image"]];
        UIImageView * itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60*i, 10, 50, 50)];
        [itemImageView sd_setImageWithURL:itemImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
        UILabel * itemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*i, 60, 60, 30)];
        itemNameLabel.text = itemName;
        itemNameLabel.textAlignment = NSTextAlignmentCenter;
        itemNameLabel.font = [UIFont systemFontOfSize:11.0f];
        [itemScrollView addSubview:itemImageView];
        [itemScrollView addSubview:itemNameLabel];
        
    }
    [self.scrollView addSubview:itemScrollView];

}

- (void) textViewDidBeginEditing: (UITextView*) textView
{
    // 編集開始時の処理
    NSLog(@"edit start");
    [self.scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
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
