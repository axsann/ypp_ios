//
//  ItemDetailViewController.m
//  
//
//  Created by kanta on 2014/09/20.
//
//

#import "ItemDetailViewController.h"
#import "TKRSegueOptions.h"
#import "AppDelegate.h"
#import "EditingItemDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


@interface ItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (void)addItemLargeImageView;
- (void)addMemoTextView;

@end

@implementation ItemDetailViewController{
    AppDelegate * app;
    NSDictionary * jsonDict;
    UIView * editItemView;
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
    // scrollViewのコンテンツのサイズを設定
    [self.scrollView setContentSize:CGSizeMake(320, 500)];
    
    // itemIdを前のビューから取得
    self.itemId = self.segueOptions.stringValue;

}



- (void)viewDidAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(loadJsonAndRefreshView) withObject:nil afterDelay:0.001];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // 吹き出し枠を作成
    UIImage * memoBgImage = [UIImage imageNamed:@"fukidashi.png"];
    UIImageView * memoBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 335, 204, 146)];
    memoBgImageView.image = memoBgImage;
    [self.scrollView addSubview:memoBgImageView];
    
    NSString * memoText = jsonDict[@"memo"] ;
    if (memoText == (id)[NSNull null]) {
        memoText = @"アイテムのブランド名や特徴をメモしましょう。\n右上の編集ボタンで編集できます。";
    }
    UITextView * memoTextView = [[UITextView alloc]initWithFrame:CGRectMake(30, 344, 180, 128)];
    memoTextView.font = [UIFont systemFontOfSize:13];
    memoTextView.text = memoText;
    // 編集を無効にする
    memoTextView.editable = NO;
    // textViewのpaddingを0に設定
    memoTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // textView を角丸にする
    //[[memoTextView layer] setCornerRadius:8.0];
    //[memoTextView setClipsToBounds:YES];
    // textView に黒色の枠線を付ける
    //[[memoTextView layer] setBorderColor:[app.separatorColor CGColor]];
    //[[memoTextView layer] setBorderWidth:1.0];
    
    [self.scrollView addSubview:memoTextView];
}

- (void)addCreatorImageViewAndCreatorNameLabel
{
    NSDictionary * creatorDict = jsonDict[@"creator"];
    NSURL * creatorImageUrl = [NSURL URLWithString:creatorDict[@"icon"]];
    

    UIImageView * creatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(228, 335, 72, 72)];
    [creatorImageView sd_setImageWithURL:creatorImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    
    // 円形に切り抜く
    creatorImageView.layer.cornerRadius = creatorImageView.frame.size.width * 0.5f;
    creatorImageView.clipsToBounds = YES;
    
    [self.scrollView addSubview:creatorImageView];
    
    UILabel * creatorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(228, 405, 70, 30)];
    creatorNameLabel.textAlignment = NSTextAlignmentCenter;
    creatorNameLabel.font = [UIFont systemFontOfSize:13];
    // 作成者の名前をセット
    creatorNameLabel.text = creatorDict[@"user_name"];
    [self.scrollView addSubview:creatorNameLabel];
}

- (void)loadJsonAndRefreshView
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }

    NSData * jsonData = [app.netManager getItemDetailJson:self.itemId];
    // 辞書データに変換する
    jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    // アイテム名をナビゲーションバーのタイトルにする
    self.navigationItem.title = jsonDict[@"item_name"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"編集"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(EnterEditingItemDetailView)];
    [self addItemLargeImageView];
    [self addMemoTextView];
    [self addCreatorImageViewAndCreatorNameLabel];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


 - (void)EnterEditingItemDetailView
 {
     EditingItemDetailViewController * editingItemDetailViewController = [EditingItemDetailViewController new];
     editingItemDetailViewController.hidesBottomBarWhenPushed = YES;
     editingItemDetailViewController.itemId = self.itemId;
     [self.navigationController pushViewController:editingItemDetailViewController animated:NO];
     

     
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
