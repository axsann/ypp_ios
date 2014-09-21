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

@interface BuyTableController ()

@end

@implementation BuyTableController{
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self buyListNoneModeOnOff];
    [super viewWillAppear:animated];
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
    return app.buyArray.count;
}

//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"BuyCell";
    // セルを準備する
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // buyArrayからアイテムを読み込む
    Item * item = app.buyArray[indexPath.row];
    
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 空のセルを表示しない
    self.tableView.tableFooterView = [[UIView alloc] init];
    // テキストラベルをセット
    cell.textLabel.text = item.itemName;
    // 画像をセット
    cell.imageView.image = [UIImage imageNamed:item.itemImgName];
    
    // アクセサリービューにボタンをセット
    [self setBoughtButtonOnCell:cell];
    
    return cell;
}

//-- セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item * item = app.buyArray[indexPath.row];
    [self performSegueWithIdentifier:@"BuyTableToDetail" options:item.itemId];
    
}
//-- 買ったボタンを設置する
- (void) setBoughtButtonOnCell:(UITableViewCell *)cell
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
    // buyArrayからアイテムを削除
    [app.buyArray removeObjectAtIndex:indexPath.row];
    NSArray * deleteArray = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationTop];
    NSLog(@"%lu", (unsigned long)app.buyArray.count);
    [self buyListNoneModeOnOff];
    
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)buyListNoneModeOnOff
{
    // 買う物リストがからの場合は
    if ([self isBuyListNone]) {
        // 境界線を透明にする
        self.tableView.separatorColor = [UIColor clearColor];
    }
    else {
        // 境界線を標準色に戻す
        self.tableView.separatorColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];

    }
}

- (BOOL)isBuyListNone
{
    return app.buyArray.count<=0;
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
