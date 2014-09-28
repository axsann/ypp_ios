//
//  MissionTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/24.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "MissionTableController.h"
#import "MissionTableViewCell.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "TKRSegueOptions.h"



@interface MissionTableController ()
@property (strong, nonatomic) UISegmentedControl * segmentedControl;
@property (strong, nonatomic) UIView * segmentedView;
@end

@implementation MissionTableController {
    AppDelegate * app;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    // タイトルロゴを設定
    self.navigationItem.titleView = app.logoView;
    // 境界線の色を透明に設定
    self.tableView.separatorColor = [UIColor clearColor];
    // 背景色を設定
    self.tableView.backgroundColor = app.bgColor;
    // 遷移先のビューでの戻るボタンのラベルを設定
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    // segmentedControllerを初期化する
    [self segmentedViewInit];
    
    // tableViewにcustomCellのクラスを登録
    UINib *nib = [UINib nibWithNibName:@"MissionTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MissionCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)segmentedViewInit
{
    _segmentedView = [[UIView alloc]init];
    _segmentedView.backgroundColor = [UIColor whiteColor];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"頼まれたもの", @"頼んだもの"]];
    _segmentedControl.frame = CGRectMake(30, 10, 260, 30);
    _segmentedControl.selectedSegmentIndex = 0; //頼まれたものを選択
    // セグメンテッドコントロールの色を変える
    _segmentedControl.tintColor = app.joymemoColor;
    //値が変更された時にloadJsonAndRefreshTableメソッドを呼び出す
    [_segmentedControl addTarget:self action:@selector(segmentedControlChanged)
                forControlEvents:UIControlEventValueChanged];
    [_segmentedView addSubview:_segmentedControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(loadJsonAndRefreshTable) withObject:nil afterDelay:0.001];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (_segmentedControl.selectedSegmentIndex==0) {
        return self.toMeMissionIdListArray.count;
    } else {
        return self.toOtherMissionIdListArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MissionCell";
    MissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * missionDetailDict;
    if (_segmentedControl.selectedSegmentIndex==0) {
        missionDetailDict = self.toMeMissionDetailArray[indexPath.row];
    }
    else {
        missionDetailDict = self.toOtherMissionDetailArray[indexPath.row];
    }
    
    NSArray * itemArray = missionDetailDict[@"items"];
    
    cell.backgroundColor = app.bgColor;
    NSDictionary * sourceUserDict = missionDetailDict[@"source"];
    NSDictionary * targetUserDict = missionDetailDict[@"target"];

    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@から%@へのおつかい依頼", sourceUserDict[@"user_name"], targetUserDict[@"user_name"]];

    // おつかいを頼んだ人のアイコン画像をセットする
    UIImageView * creatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 24, 36, 36)];
    NSURL * creatorImageUrl = [NSURL URLWithString:sourceUserDict[@"icon"]];
    [creatorImageView sd_setImageWithURL:creatorImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    creatorImageView.layer.cornerRadius = creatorImageView.frame.size.width * 0.5f;
    creatorImageView.clipsToBounds = YES;
    [cell.contentView addSubview:creatorImageView];
    
    NSString * dateStr = [self changeDateFormat:missionDetailDict[@"request_time"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@に依頼", dateStr]; // 日付と時間をセット
    cell.commentTextView.editable = NO;
    cell.commentTextView.text = missionDetailDict[@"memo"];
    
    // itemScrollViewのコンテンツサイズを設定
    cell.itemScrollView.contentSize = CGSizeMake(itemArray.count*60, cell.itemScrollView.frame.size.height);
    // 再利用時にセルを初期化するためにスクロールビューからサブビューを削除する
    for (UIView *view in cell.itemScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i<itemArray.count; i++) {
        NSDictionary * itemDict = itemArray[i];
        NSString * itemName = itemDict[@"item_name"];
        NSString * itemId = itemDict[@"item_id"];
        NSURL * itemThumbImageUrl = [NSURL URLWithString:itemDict[@"thumb"]];
        CGFloat itemThumbWidthHeight = 50;
        CGRect itemThumbFrame = CGRectMake(60*i, 5, itemThumbWidthHeight, itemThumbWidthHeight);
        UIImageView * itemThumbImageView = [[UIImageView alloc]initWithFrame:itemThumbFrame];
        [itemThumbImageView sd_setImageWithURL:itemThumbImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
        UIButton * itemThumbButton = [[UIButton alloc]initWithFrame:itemThumbFrame];
        [itemThumbButton addTarget:self action:@selector(itemThumbButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        itemThumbButton.tag = itemId.intValue; // userIconButtonのタグをitem_idに設定
        // アイテム名のラベルを設定
        UILabel * itemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60*i, 60, itemThumbWidthHeight, 30)];
        itemNameLabel.text = itemName;
        itemNameLabel.textAlignment = NSTextAlignmentCenter;
        itemNameLabel.font = [UIFont systemFontOfSize:11.0f];
        [cell.itemScrollView addSubview:itemThumbImageView];
        [cell.itemScrollView addSubview:itemThumbButton];
        [cell.itemScrollView addSubview:itemNameLabel];
    }
    
    // Configure the cell...
    
    return cell;
}

-(void) itemThumbButtonTapped:(UIButton *)button
{
    NSString * itemId = [NSString stringWithFormat:@"%ld", (long)button.tag];
    [self performSegueWithIdentifier:@"MissionTableToDetail" options:itemId];
}

// 日付の形を変換する
- (NSString *)changeDateFormat:(NSString *)dateStr
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // 勝手に日本時間に変換されないようにする
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    [newDateFormatter setDateFormat:@"yyyy年MM月dd日 HH時mm分ss秒"];
    NSString *newDateStr = [newDateFormatter stringFromDate:date];
    NSLog(@"Date: %@, formatted date: %@", date, newDateStr);
    return newDateStr;
}

- (void)segmentedControlChanged
{
    [self refreshTable];
    // テーブルビューを先頭に戻す
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)loadJsonAndRefreshTable
{
    [self loadJson];
    [self refreshTable];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loadJson
{
    self.toMeMissionIdListArray = [NSMutableArray array];
    self.toMeMissionDetailArray = [NSMutableArray array];
    self.toOtherMissionIdListArray = [NSMutableArray array];
    self.toOtherMissionDetailArray = [NSMutableArray array];
    NSData * missionListJsonData = [app.netManager getMissionListJson];
    NSArray * missionListArray = [NSJSONSerialization JSONObjectWithData:missionListJsonData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    for (int i=0; i<missionListArray.count; i++) {
        NSDictionary * missionDict = missionListArray[i];
        NSDictionary * missionTargetDict = missionDict[@"target"];
        NSDictionary * missionSourceDict = missionDict[@"source"];
        // 頼まれた人がユーザIDと一致していればtoMeMissionIdListArrayに追加
        if ([missionTargetDict[@"user_id"] isEqualToString:app.netManager.userId]) {
            [self.toMeMissionIdListArray addObject:missionDict[@"mission_id"]];
        }
        // 頼んだ人がユーザIDと一致していればtoOtherMissionIdListArrayに追加
        if ([missionSourceDict[@"user_id"] isEqualToString:app.netManager.userId]) {
            [self.toOtherMissionIdListArray addObject:missionDict[@"mission_id"]];
        }
    }
    
    // 頼まれたものの詳細一覧を取得
    for (int i=0; i<self.toMeMissionIdListArray.count; i++) {
        NSData * toMeMissionDetailJsonData = [app.netManager getMissionDetailJson:self.toMeMissionIdListArray[i]];
        NSDictionary * toMeMissionDetailDict = [NSJSONSerialization JSONObjectWithData:toMeMissionDetailJsonData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:nil];
        [self.toMeMissionDetailArray addObject:toMeMissionDetailDict];
    }
    // 頼んだものの詳細一覧を取得
    for (int i=0; i<self.toOtherMissionIdListArray.count; i++) {
        NSData * toOtherMissionDetailJsonData = [app.netManager getMissionDetailJson:self.toOtherMissionIdListArray[i]];
        NSDictionary * toOtherMissionDetailDict = [NSJSONSerialization JSONObjectWithData:toOtherMissionDetailJsonData
                                                                               options:NSJSONReadingAllowFragments
                                                                                 error:nil];
        [self.toOtherMissionDetailArray addObject:toOtherMissionDetailDict];
    }
}

- (void)refreshTable
{
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

//-- セクションのタイトルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //return 0; // セクションのタイトルを非表示にする
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return _segmentedView;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
