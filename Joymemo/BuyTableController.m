//
//  BuyTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/17.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "BuyTableController.h"
#import "AppDelegate.h"
#import "TKRSegueOptions.h"
#import "Item.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ItemTableViewCell.h"


@interface BuyTableController ()
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)addBoughtButtonOnCell:(UITableViewCell *)cell;
- (void)boughtButtonTapped:(UIControl *)button withEvent:(UIEvent *)event;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isBuyListNone;
@end

@implementation BuyTableController{
    AppDelegate * app;
    NSMutableArray * _buyListArray;
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
    [self.tableView registerClass:[ItemTableViewCell class] forCellReuseIdentifier:@"Cell"];

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _buyListArray.count;
}

//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    // セルを準備する
    ItemTableViewCell * cell = [[ItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * itemDict = _buyListArray[indexPath.row];
    NSDictionary * userDict = itemDict[@"user"];
    // テキストラベルをセット
    cell.textLabel.text = itemDict[@"item_name"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", userDict[@"user_name"]];
    
    // 画像をセット
    NSURL * thumbUrl = [NSURL URLWithString:itemDict[@"thumb"]];
    [cell.imageView sd_setImageWithURL:thumbUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    
    // アクセサリービューにボタンを追加
    [self addBoughtButtonOnCell:cell];
    
    return cell;
}

//-- セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary * itemDict = _buyListArray[indexPath.row];
    NSString * itemId = itemDict[@"item_id"];
    [self performSegueWithIdentifier:@"BuyTableToDetail" options:itemId];
}
//-- 買ったボタンを設置する
- (void)addBoughtButtonOnCell:(UITableViewCell *)cell
{
    UIButton * boughtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float boughtButtonWidth = 97;
    float boughtButtonHeight = 52;
    [boughtButton setFrame:CGRectMake(cell.contentView.frame.size.width-97, 0, boughtButtonWidth, boughtButtonHeight)];
    [boughtButton setBackgroundImage:[UIImage imageNamed:@"boughtbuttonorange194x104.png"] forState:UIControlStateNormal];
    [boughtButton setBackgroundColor:[UIColor whiteColor]];
    [boughtButton addTarget:self action:@selector(boughtButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:boughtButton];
    
}

//-- 買ったボタンをタップした時の処理(tableView:accessoryButtonTappedForRowWithIndexPathに処理を流す)
- (void)boughtButtonTapped:(UIControl *)button withEvent:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}


//-- アクセサリーボタン(買ったボタン)をタップした時の処理
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * itemDict = _buyListArray[indexPath.row];
    NSString * buyListId = itemDict[@"buylist_id"];
    [_buyListArray removeObjectAtIndex:indexPath.row];
    NSArray * deleteArray = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationTop];
    [self showHideBuyListEmptyImage];
    // サーバからアイテムを削除
    [self performSelectorInBackground:@selector(removeBuyListItem:) withObject:buyListId];
}

- (void)removeBuyListItem:(NSString *)buyListId
{
    [app.netManager removeBuyListItemData:buyListId];

}

- (void)loadJsonAndRefreshTable
{
    NSData * buyListJsonData = [app.netManager getBuyListJson];
    _buyListArray = [NSJSONSerialization JSONObjectWithData:buyListJsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:nil];
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self showHideBuyListEmptyImage];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


- (BOOL)isBuyListNone
{
    return _buyListArray.count<=0;
}

- (void)showHideBuyListEmptyImage
{
    if ([self isBuyListNone]) {
        UIView * bgView = [[UIView alloc]initWithFrame:self.tableView.frame];
        UIImageView * buyListEmptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 331)];
        buyListEmptyImageView.image = [UIImage imageNamed:@"empty_buylist.png"];
        [bgView addSubview:buyListEmptyImageView];
        self.tableView.backgroundView = bgView;
    }
    else {
        self.tableView.backgroundView = nil;
    }
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
