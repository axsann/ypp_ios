//
//  AccountTableViewController.m
//  Joymemo
//
//  Created by kanta on 2014/09/28.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "AccountTableViewController.h"
#import "AccountTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController {
    AppDelegate * app;
    NSMutableArray * _userListArray;
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
    // 再利用するセルを設定
    [self.tableView registerClass:[AccountTableViewCell class] forCellReuseIdentifier:@"Cell"];
    // 境界線の色を設定
    self.tableView.separatorColor = app.tableCellSeparatorColor;
    // 背景色を設定
    self.tableView.backgroundColor = app.bgColor;
    // 空のセルを表示しない
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"戻る"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToHome)];
    self.navigationItem.title = @"アカウント";
    
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
    return _userListArray.count;
}

//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    // セルを準備する
    AccountTableViewCell * cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // フォントサイズを設定
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    // 文字を3行に折り返して表示する
    cell.textLabel.numberOfLines = 3;
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * userDict = _userListArray[indexPath.row];
    // テキストラベルをセット
    cell.textLabel.text = userDict[@"user_name"];
    
    // 画像をセット
    NSURL * userIconImageUrl = [NSURL URLWithString:userDict[@"icon"]];
    
    [cell.imageView sd_setImageWithURL:userIconImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    
    return cell;
}
// ヘッダービューに背景画像とユーザ画像をセットする
- (void)addHeaderView
{
    NSDictionary * myDict;
    for (int i=0; i<_userListArray.count; i++) {
        NSDictionary * userDict = _userListArray[i];
        if ([userDict[@"user_id"] isEqualToString:app.netManager.userId]) {
            myDict = [NSDictionary dictionaryWithDictionary:userDict];
        }
    }
    // ヘッダービューを画像にする
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
    UIImageView * headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
    headerImageView.image = [UIImage imageNamed:@"account_bg.png"];
    [headerView addSubview:headerImageView];
    // 自分のアイコン画像をセットする
    UIImageView * myIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 30, 82, 82)];
    NSURL * myIconImageUrl = [NSURL URLWithString:myDict[@"icon"]];
    [myIconImageView sd_setImageWithURL:myIconImageUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    myIconImageView.layer.cornerRadius = myIconImageView.frame.size.width * 0.5f;
    myIconImageView.clipsToBounds = YES;
    [headerView addSubview:myIconImageView];
    // 自分のユーザ名をセットする
    UILabel * myNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 55, 200, 27)];
    myNameLabel.textAlignment = NSTextAlignmentCenter;
    myNameLabel.font = [UIFont systemFontOfSize:25];
    myNameLabel.text = myDict[@"user_name"];
    myNameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:myNameLabel];
    self.tableView.tableHeaderView = headerView;
}

- (void)loadJsonAndRefreshTable
{
    NSData * userListJsonData = [app.netManager getUserListJson];
    _userListArray = [NSJSONSerialization JSONObjectWithData:userListJsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    [self addHeaderView];
    // テーブルを更新する
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)backToHome
{
    // アニメーションを作成
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    // navigationControllerにアニメーションを設定
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

// セクションヘッダーの高さを設定
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
	return @"家族登録されている人";
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
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
