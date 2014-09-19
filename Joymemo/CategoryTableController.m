//
//  CategoryTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "CategoryTableController.h"
#import "AppDelegate.h"
#import "Item.h"


@interface CategoryTableController ()
@end

@implementation CategoryTableController{
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

- (void)viewWillAppear:(BOOL)animated {

    // Viewを表示するたびに表示データを更新する // ファイルから配列にデータを再読込させる必要あり？
    //[self.tableView reloadData]; //←よりも→のほうがいい？[(UITableView)tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO]; //http://ebisu.surbiton.jp/sysblog/2012/04/uitableview.htmlを参照
    
    // Toolbarの表示をONにする
    //[self.navigationController setToolbarHidden:NO animated:NO];
    [self removeButtonFromToolbar];
    [self addButtonToToolbar];
    
    // すべてのセルを見て、checkArray内のものと一致するものにチェックをつける
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j) {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            // checkArrayに含まれるものにチェックを入れ、そうでないもののチェックを外す
            [self checkOnOffContainedInCheckArray:cell atIndexPath:indexPath];
        }
    }
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
    return self.itemArray.count;
}
//-- 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CategoryCell";
    // セルを準備する
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 境界線を左端から表示
    cell.separatorInset = UIEdgeInsetsZero;
    // セルの選択時にハイライトを行わない
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // 配列からアイテムを読み込む
    Item * item = [[Item alloc]init];
    item = self.itemArray[indexPath.row];
    
    // 画像をセット
    cell.imageView.image = [UIImage imageNamed:item.itemImgName];
    
    // テキストラベルをセット
    cell.textLabel.text = item.itemName;
    

    // checkArrayに含まれるものにチェックを入れ、そうでないもののチェックを外す
    [self checkOnOffContainedInCheckArray:cell atIndexPath:indexPath];
    
    return cell;
}

// セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択されたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // チェックマークのオン・オフ
    [self checkOnOffSelectedCell:cell atIndexPath:indexPath];
    NSLog(@"%lu", (unsigned long)app.checkArray.count);
}

// セルの選択がはずれた時に呼び出される
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択がはずれたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // チェックマークのオン・オフ
    [self checkOnOffSelectedCell:cell atIndexPath:indexPath];
    NSLog(@"%lu", (unsigned long)app.checkArray.count);
    
}

// checkArrayに含まれているアイテムのチェックマークを自動でオン・オフする
- (void)checkOnOffContainedInCheckArray:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item * item = [[Item alloc]init];
    item = self.itemArray[indexPath.row];
    // アイテムがチェックアレイ内のものと一致していたら、チェックマークをつける
    if ([app.checkArray containsObject:item]){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self setCheckmarkOnCell:cell];
    }
    else { // 一致していなければチェックマークを外す
        //cell.accessoryType = UITableViewCellAccessoryNone;
        [self setNotCheckmarkOnCell:cell];
    }
}

// セルを選択した時にチェックマークをつける
- (void)checkOnOffSelectedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item * item = [[Item alloc]init];
    item = self.itemArray[indexPath.row];
    // チェックマークがなければ、チェックマークをつける
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self setCheckmarkOnCell:cell];
        [app.checkArray addObject:item];
    }
    else { // チェックマークがあれば、チェックマークを消す
        //cell.accessoryType = UITableViewCellAccessoryNone;
        [self setNotCheckmarkOnCell:cell];
        [app.checkArray removeObject:item];
    }
    // 選択モード時にツールバーを表示する
    [self showHideToolbar];
    // 選択モード時にキャンセルボタンを表示する
    [self showHideCancelButton];
}

// 選択モード時にキャンセルボタンを表示する
- (void)showHideCancelButton
{
    if ([self isCheckModeON]) {
        UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(checkModeOff)];
        self.navItem.rightBarButtonItem = cancelButton;
    }
    else {
        self.navItem.rightBarButtonItem = nil;
    }

}



// 選択モード時にツールバーを表示する
- (void)showHideToolbar
{
    
    UITabBar *tabbar = self.tabBarController.tabBar;

    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    float tabbarHeight = tabbar.frame.size.height;
    if ([self isCheckModeON]){ // チェックアレイにアイテムが入っていればツールバーを表示
        [UIView animateWithDuration:0.3
                         animations:^{
                             app.toolbar.frame = CGRectMake(0.0f, screenHeight-tabbarHeight, 320.0f, tabbarHeight);
                         }];
    } else{ // チェックアレイにアイテムが入っていなければツールバーを非表示
        [UIView animateWithDuration:0.3
                         animations:^{
                             app.toolbar.frame = CGRectMake(0.0f, screenHeight, 320.0f, tabbarHeight);
                         }];

    }
}

// ボタンをツールバーに追加する
- (void)addButtonToToolbar
{
    
    NSMutableArray * toolbarItems = [NSMutableArray array];
    UIBarButtonItem * addToBuyButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addItemToBuyArray)
                                        ];
    [toolbarItems addObject:addToBuyButton];
    [app.toolbar setItems:toolbarItems];
}
// ボタンをツールバーから削除する
- (void)removeButtonFromToolbar
{
    NSMutableArray * toolbarItems = [NSMutableArray array];
    [app.toolbar setItems:toolbarItems];
}

// BuyArrayにアイテムを追加する
- (void)addItemToBuyArray
{
    for (int i=0; i<app.checkArray.count; i++) {
        Item * item = app.checkArray[i];
        if (![app.buyArray containsObject:item]) { // buyArrayに追加済みでなければ
            [app.buyArray addObject:item]; // itemをbuyArrayに追加する
        }
    }
    
    //app.buyArray = [app.checkArray mutableCopy];
    [self checkModeOff];
    NSLog(@"%lu", (unsigned long)app.buyArray.count);
}

// チェックと同時にタブバーを押した場合はチェックモードをオフにする
- (void)checkModeOff
{
    // チェックアレイから全てのオブジェクトを削除
    [app.checkArray removeAllObjects];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            // checkArrayに含まれるものにチェックを入れ、そうでないもののチェックを外す
            [self checkOnOffContainedInCheckArray:cell atIndexPath:indexPath];
        }
    }
    // ツールバーを非表示にしてタブバーを再表示させる
    [self showHideToolbar];
    [self showHideCancelButton];
}

- (BOOL)isCheckModeON
{
    return app.checkArray.count>0;
}

// セルのアクセサリービューにカスタムチェックマークを入れる
- (void)setCheckmarkOnCell:(UITableViewCell *)cell
{
    UIImage * checkImage = [UIImage imageNamed:@"circlecheck.png"];

    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:checkImage];
    // 画像が大きい場合にはみ出さないようにViewの大きさを固定化
    checkImageView.frame = CGRectMake(0, 0, 35, 30);
    
    // アクセサリービューにイメージを設定
    cell.accessoryView = checkImageView;
    // accessoryTypeをCheckmarkにする。カスタム画像は維持される。
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

// セルのアクセサリービューにカスタムノットチェックマークを入れる
- (void)setNotCheckmarkOnCell:(UITableViewCell *)cell
{
    UIImage * notCheckImage = [UIImage imageNamed:@"circle.png"];
    UIImageView *notCheckImageView = [[UIImageView alloc] initWithImage:notCheckImage];
    // 画像が大きい場合にはみ出さないようにViewの大きさを固定化
    notCheckImageView.frame = CGRectMake(0, 0, 35, 30);
    // アクセサリービューにイメージを設定
    cell.accessoryView = notCheckImageView;
    // accessoryTypeをNoneにする。カスタム画像は維持される。
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}

//-- セクションのタイトル文字を設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.cateName;
}

//-- セクションのタイトルの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

@end
