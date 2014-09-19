//
//  BuyTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/17.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "BuyTableController.h"
#import "AppDelegate.h"
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
    // テーブルを更新
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    
    // テキストラベルをセット
    cell.textLabel.text = item.itemName;
    
    // 画像をセット
    cell.imageView.image = [UIImage imageNamed:item.itemImgName];
    
    // アクセサリービューにボタンをセット
    //cell.accessoryView
    
    return cell;
}

/*
- (void) setBoughtButtonOnCell:(UITableViewCell *)cell
{
    UIImage * notCheckImage = [UIImage imageNamed:@"circle.png"];
    UIImageView *notCheckImageView = [[UIImageView alloc] initWithImage:notCheckImage];
    // 画像が大きい場合にはみ出さないようにViewの大きさを固定化
    notCheckImageView.frame = CGRectMake(0, 0, 35, 30);
    // アクセサリービューにイメージを設定
    cell.accessoryView = notCheckImageView;
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
