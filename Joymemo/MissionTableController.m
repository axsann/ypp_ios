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
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"


@interface MissionTableController ()

@end

@implementation MissionTableController{
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
    // 境界線の色を透明に設定
    self.tableView.separatorColor = [UIColor clearColor];
    // 背景色を設定
    self.tableView.backgroundColor = app.bgColor;
    
    // tableViewにcustomCellのクラスを登録
    UINib *nib = [UINib nibWithNibName:@"MissionTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MissionCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(loadJsonAndRefreshTable) withObject:nil afterDelay:0.1];
    
    // Update cells
    NSMutableArray *cells = [NSMutableArray arrayWithArray:[self.tableView visibleCells]];
    for (UITableViewCell *cell in cells) {
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
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
    return self.myMissionIdListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MissionCell";
    MissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * missionDetailDict = self.myMissionDetailArray[indexPath.row];
    NSDictionary * sourceUserDict = missionDetailDict[@"source"];
    NSArray * itemArray = missionDetailDict[@"items"];
    
    cell.backgroundColor = app.bgColor;

    cell.titleLabel.text = [NSString stringWithFormat:@"%@からのおつかい依頼", sourceUserDict[@"user_name"]];
    NSString * dateStr = [self changeDateFormat:missionDetailDict[@"request_time"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@に依頼", dateStr]; // 日付と時間をセット
    cell.commentTextView.editable = NO;
    cell.commentTextView.text = missionDetailDict[@"memo"];
    
    // おつかいを頼んだ人のアイコン画像をセットする
    UIImageView * creatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 24, 36, 36)];
    NSURL * creatorImageUrl = [NSURL URLWithString:sourceUserDict[@"icon"]];
    [creatorImageView sd_setImageWithURL:creatorImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    creatorImageView.layer.cornerRadius = creatorImageView.frame.size.width * 0.5f;
    creatorImageView.clipsToBounds = YES;
    [cell.contentView addSubview:creatorImageView];
    
    // itemScrollViewのコンテンツサイズを設定
    cell.itemScrollView.contentSize = CGSizeMake(itemArray.count*60, cell.itemScrollView.frame.size.height);
    // 再利用時にセルを初期化するためにスクロールビューからサブビューを削除する
    for (UIView *view in cell.itemScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i<itemArray.count; i++) {
        NSDictionary * itemDict = itemArray[i];
        NSString * itemName = itemDict[@"item_name"];
        NSURL * itemThumbImageUrl = [NSURL URLWithString:itemDict[@"thumb"]];
        CGFloat itemThumbWidthHeight = 50;
        CGRect itemThumbFrame = CGRectMake(60*i, 5, itemThumbWidthHeight, itemThumbWidthHeight);
        UIImageView * itemThumbImageView = [[UIImageView alloc]initWithFrame:itemThumbFrame];
        [itemThumbImageView sd_setImageWithURL:itemThumbImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
        UIButton * itemThumbButton = [[UIButton alloc]initWithFrame:itemThumbFrame];
        [itemThumbButton addTarget:self action:@selector(itemThumbButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        itemThumbButton.tag = i+1; // userIconButtonのタグをi+1に設定
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

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Here you can update cell. This method is called from both when the cell is created
    // and and when viewWillAppear is called. When the user changed the cell value in detailed
    // view and come back to this view, the value of the cell changed appropriately.
    // Watch "viewWillAppear:" method.
    
    // Usually, you set the cell with the data from an array or a model manager.
    // This is just a sample, so I directly set the content here.
    
    // cast
    MissionTableViewCell * missionCell;
    missionCell = (MissionTableViewCell *)cell;
    
    
}

-(void) itemThumbButtonTapped:(UIButton *)button
{
    
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

- (void)loadJsonAndRefreshTable
{
    self.myMissionIdListArray = [NSMutableArray array];
    self.myMissionDetailArray = [NSMutableArray array];
    NSData * missionListJsonData = [app.netManager getMissionListJson];
    NSArray * missionListArray = [NSJSONSerialization JSONObjectWithData:missionListJsonData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    for (int i=0; i<missionListArray.count; i++) {
        NSDictionary * missionDict = missionListArray[i];
        NSDictionary * missionTargetDict = missionDict[@"target"];
        if ([missionTargetDict[@"user_id"] isEqualToString:app.netManager.userId]) {
            [self.myMissionIdListArray addObject:missionDict[@"mission_id"]];
        }
    }
    for (int i=0; i<self.myMissionIdListArray.count; i++) {
        NSData * missionDetailJsonData = [app.netManager getMissionDetailJson:self.myMissionIdListArray[i]];
        NSDictionary * missionDetailDict = [NSJSONSerialization JSONObjectWithData:missionDetailJsonData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:nil];
        [self.myMissionDetailArray addObject:missionDetailDict];
    }
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [SVProgressHUD dismiss];
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
