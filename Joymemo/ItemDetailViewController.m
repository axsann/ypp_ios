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

@interface ItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (void)addItemLargeImageView;
- (void)addMemoTextView;

@end

@implementation ItemDetailViewController{
    AppDelegate * app;
    NSDictionary * jsonDict;
    UIView * editItemView;
    BOOL editing;
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

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshDataAndView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addItemLargeImageView
{
    NSMutableArray * imageArray =  jsonDict[@"images"];
    NSDictionary * image0Dict = imageArray[0];
    UIImage * itemImage = [UIImage imageNamed:image0Dict[@"image"]];
    UIImageView * itemLargeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320.0, 320.0)];
    [itemLargeImageView setImage:itemImage];
    [self.scrollView addSubview:itemLargeImageView];
    
}

- (void)addMemoTextView
{
    // 吹き出し枠を作成
    UIImage * memoBgImage = [UIImage imageNamed:@"fukidashi.png"];
    UIImageView * memoBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 335, 204, 146)];
    memoBgImageView.image = memoBgImage;
    [self.scrollView addSubview:memoBgImageView];
    
    NSString * memoText = jsonDict[@"memo"];
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
    UIImage * creatorImage = [UIImage imageNamed:creatorDict[@"icon"]];
    UIImageView * creatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(228, 335, 72, 72)];
    // 作成者の画像をセット
    creatorImageView.image = creatorImage;
    
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

- (void)EnterExitEditItemMode
{
    editing = !editing; // 編集フラグをオン・オフ
    if (editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(EnterExitEditItemMode)];
        // 編集モードのビューのサイズを設定
        editItemView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                        self.view.frame.origin.y,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height)];
        editItemView.backgroundColor = app.bgColor; // 背景色を設定
        self.navigationItem.title = @"アイテム編集"; // タイトルをアイテム編集にする
        
        [self.view addSubview:editItemView];
    }
    else {
        [self refreshDataAndView];

        [editItemView removeFromSuperview];
    }

}

- (void)refreshDataAndView
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    // 本来ならここでself.itemIdを渡して、それに合わせたJSONをもらう
    NSString * fileName = @"ItemDetailSample";
    // JSONファイルを読み込む
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:filePath];
     
    //NSData * jsonData = [app.netManager getItemDetailJson:self.itemId];
    // 辞書データに変換する
    jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    // アイテム名をナビゲーションバーのタイトルにする
    self.navigationItem.title = jsonDict[@"item_name"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"編集"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(EnterExitEditItemMode)];
    [self addItemLargeImageView]; // Web上の画像に対応させる
    [self addMemoTextView];
    [self addCreatorImageViewAndCreatorNameLabel]; // Web上の画像に対応させる
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
