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
#import "SVProgressHUD.h"

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
    NSMutableArray * buyListArray;
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // AppDelegateをインスタンス化
    app = [[UIApplication sharedApplication] delegate];
    // 境界線の色を設定
    self.tableView.separatorColor = app.tableCellSeparatorColor;
    // 背景色を設定
    self.tableView.backgroundColor = app.bgColor;
    // 空のセルを表示しない
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidAppear:(BOOL)animated
{
    [self loadJson];
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    //return app.buyArray.count;
    return buyListArray.count;
}

//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    // セルを準備する
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
     // buyArrayからアイテムを読み込む
     Item * item = app.buyArray[indexPath.row];
     
     
    // テキストラベルをセット
    cell.textLabel.text = item.itemName;
    // 画像をセット
    cell.imageView.image = [UIImage imageNamed:item.thumb];
    
    */
    
    NSDictionary * itemDict = buyListArray[indexPath.row];
    
    // テキストラベルをセット
    cell.textLabel.text = itemDict[@"item_name"];
    
    // サムネイルをセット(未実装)
    
    
    // アクセサリービューにボタンを追加
    [self addBoughtButtonOnCell:cell];
    
    return cell;
}

//-- セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Item * item = app.buyArray[indexPath.row];
    //[self performSegueWithIdentifier:@"BuyTableToDetail" options:item.itemId];
    NSDictionary * itemDict = buyListArray[indexPath.row];
    [self performSegueWithIdentifier:@"BuyTableToDetail" options:itemDict[@"item_id"]];
}
//-- 買ったボタンを設置する
- (void)addBoughtButtonOnCell:(UITableViewCell *)cell
{
    UIButton * boughtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float boughtButtonWidth = 97;
    float boughtButtonHeight = 52;
    [boughtButton setFrame:CGRectMake(cell.contentView.frame.size.width-97, 0, boughtButtonWidth, boughtButtonHeight)];
    [boughtButton setBackgroundImage:[UIImage imageNamed:@"boughtbutton194x104.png"] forState:UIControlStateNormal];
    [boughtButton setBackgroundColor:[UIColor clearColor]];
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
    // サーバからアイテムを削除 未実装
    NSDictionary * itemDict = buyListArray[indexPath.row];
    NSString * buyListId = itemDict[@"buylist_id"];
    [buyListArray removeObjectAtIndex:indexPath.row];
    NSArray * deleteArray = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationTop];
    [self performSelectorInBackground:@selector(removeBuyListItem:) withObject:buyListId];
}

- (void)removeBuyListItem:(NSString *)buyListId
{
    [app.netManager removeBuyListItemData:buyListId];

}

- (void)loadJson
{
    NSData * buyListJsonData = [app.netManager getBuyListJson];
    NSError * parseError;
    buyListArray = [NSJSONSerialization JSONObjectWithData:buyListJsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&parseError];
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


- (BOOL)isBuyListNone
{
    return buyListArray.count<=0;
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
