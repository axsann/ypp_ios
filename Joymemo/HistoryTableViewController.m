//
//  HistoryTableViewController.m
//  Joymemo
//
//  Created by kanta on 2014/09/27.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "HistoryTableViewCell.h"


@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController {
    AppDelegate * app;
    NSMutableArray * _historyListArray;
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
    // 再利用するセルを設定
    [self.tableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // AppDelegateをインスタンス化
    app = [[UIApplication sharedApplication] delegate];
    // 境界線の色を設定
    self.tableView.separatorColor = app.tableCellSeparatorColor;
    // 背景色を設定
    self.tableView.backgroundColor = app.bgColor;
    // 空のセルを表示しない
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 遷移先のビューでの戻るボタンのラベルを設定
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(loadJsonAndRefreshTable) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _historyListArray.count;
}

//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    // セルを準備する
    HistoryTableViewCell * cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // フォントサイズを設定
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    // 文字を3行に折り返して表示する
    cell.textLabel.numberOfLines = 3;
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * historyDict = _historyListArray[indexPath.row];
    NSDictionary * userDict = historyDict[@"user"];
    // テキストラベルをセット
    cell.textLabel.text = historyDict[@"message"];
    
    // 日付の色をセット
    cell.detailTextLabel.textColor = [UIColor colorWithRed:(216.0f/255.0f) green: (211.0f/255.0f) blue:(204.0f/255.0f) alpha:1.0f];
    // 日付をセット
    NSString * dateStr = [self changeDateFormat:historyDict[@"time"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", dateStr]; // 日付と時間をセット
    
    // 画像をセット
    NSURL * userIconImageUrl = [NSURL URLWithString:userDict[@"icon"]];

    [cell.imageView sd_setImageWithURL:userIconImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    

    return cell;
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
    NSData * historyListJsonData = [app.netManager getHistoryListJson];
    _historyListArray = [NSJSONSerialization JSONObjectWithData:historyListJsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [SVProgressHUD dismiss];
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
