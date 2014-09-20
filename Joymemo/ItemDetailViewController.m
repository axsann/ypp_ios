//
//  ItemDetailViewController.m
//  
//
//  Created by kanta on 2014/09/20.
//
//

#import "ItemDetailViewController.h"
#import "TKRSegueOptions.h"

@interface ItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ItemDetailViewController{
    NSDictionary * jsonDict;
    UIImageView * itemLargeImageView;
    UITextView * memoTextView;
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
    
    // scrollViewのサイズを設定
    [self.scrollView setContentSize:CGSizeMake(320, 700)];
    
    // itemIdを前のビューから取得
    self.itemId = self.segueOptions.stringValue;
    
    // 本来ならここでself.itemIdを渡して、それに合わせたJSONをもらう
    NSString * fileName = @"ItemDetailSample";
    // JSONファイルを読み込む
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    // 辞書データに変換する
    jsonDict = [NSJSONSerialization JSONObjectWithData:fileData
                                               options:0
                                                 error:nil];
    self.navigationItem.title = jsonDict[@"item_name"];
    [self addItemLargeImageView];
    [self addMemoTextView];
    //self.navigationItem.title = self.itemId;
    NSLog(@"%@", self.itemId);
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
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
    itemLargeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 300.0, 300.0)];
    itemLargeImageView.image = itemImage;
    [self.scrollView addSubview:itemLargeImageView];
    
}

- (void)addMemoTextView
{
    NSMutableArray * memoArray = jsonDict[@"memos"];
    NSDictionary * memo0Dict = memoArray[0];
    CGRect  cgRect = CGRectMake(10, 340, 300, 300);
    memoTextView = [[UITextView alloc]initWithFrame:cgRect];
    memoTextView.text = memo0Dict[@"memo"];
    // 編集を無効にする
    memoTextView.editable = NO;
    // textView を角丸にする
    [[memoTextView layer] setCornerRadius:10.0];
    [memoTextView setClipsToBounds:YES];
    // textView に黒色の枠線を付ける
    [[memoTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[memoTextView layer] setBorderWidth:1.0];
    
    [self.scrollView addSubview:memoTextView];
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
