//
//  CategoryTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "CategoryTableController.h"
#import "AppDelegate.h"

@interface CategoryTableController ()

@end

@implementation CategoryTableController{
    //NSArray * arrayList;
    //NSDictionary * dic;
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
    //NSLog(@"viewDidLoad executed");表示時に毎回は実行されない
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // ファイルから配列にデータを読み込む
    //NSString * dataFile = [[NSBundle mainBundle]pathForResource:@"DataList" ofType:@"plist"];
    //self->dic = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    //arrayList = [NSArray arrayWithContentsOfFile:dataFile];
}

- (void)viewWillAppear:(BOOL)animated {

    //NSLog(@"%s", "viewWillAppearが実行されました"); // 毎回実行される
    // Viewを表示するたびに表示データを更新する // ファイルから配列にデータを再読込させる必要あり？
    //[self.tableView reloadData]; //←よりも→のほうがいい？[(UITableView)tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO]; //http://ebisu.surbiton.jp/sysblog/2012/04/uitableview.htmlを参照
    
    
    
    // すべてのセルを見て、checkArray内のものと一致するものにチェックをつける
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            // checkArrayに含まれるものにチェックを入れ、そうでないもののチェックを外す
            [self checkOnOffContainedInCheckArray:cell];
            //[cells addObject:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
        }
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    //NSMutableArray *cells = [[NSMutableArray alloc] init];

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
    return self.itemArray.count;
}
//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    // セルを準備する
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 配列からデータを読み込む
    NSDictionary * listDict = [self.itemArray objectAtIndex:indexPath.row];
    
    // 画像をセット
    cell.imageView.image = [UIImage imageNamed:[listDict objectForKey:@"image"]];
    
    // テキストラベルをセット
    cell.textLabel.text = [listDict objectForKey:@"name"];
    
    // checkArrayに含まれるものにチェックを入れ、そうでないもののチェックを外す
    [self checkOnOffContainedInCheckArray:cell];
    
    
    // 表示する文字
    //NSString * title = [NSString stringWithFormat:@"セクション%dの%d行目", indexPath.section, indexPath.row];
    // セルのラベルに設定する
    //cell.textLabel.text = title;
    
    return cell;
}

// セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択されたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // チェックマークのオン・オフ
    [self checkOnOffSelectedCell:cell];
    NSLog(@"%lu", (unsigned long)app.checkArray.count);
}

// セルの選択がはずれた時に呼び出される
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択がはずれたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // チェックマークのオン・オフ
    [self checkOnOffSelectedCell:cell];
    NSLog(@"%lu", (unsigned long)app.checkArray.count);
}

// checkArrayに含まれているアイテムのチェックマークを自動でオン・オフする
- (void)checkOnOffContainedInCheckArray:(UITableViewCell *)cell
{
    // テキストラベルがチェックアレイ内のものと一致していたら、チェックマークをつける
    if ([app.checkArray containsObject:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else { // 一致していなければチェックマークを外す
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

// セルを選択した時にチェックマークをつける。もしくは消す。
- (void)checkOnOffSelectedCell:(UITableViewCell *)cell
{
    // チェックマークがなければ、チェックマークをつける
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [app.checkArray addObject:cell.textLabel.text];
    }
    else{ // チェックマークがあれば、チェックマークを消す
        cell.accessoryType = UITableViewCellAccessoryNone;
        [app.checkArray removeObject:cell.textLabel.text];
    }
}

//-- セクションのタイトル文字を設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.catName;
}

//-- セクションのタイトルの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//-- ステータスバーを非表示
/*- (BOOL) prefersStatusBarHidden {
    return YES;
}*/
@end
