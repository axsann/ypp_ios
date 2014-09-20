//
//  CategoryTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "CategoryTableController.h"
#import "AppDelegate.h"
#import "TKRSegueOptions.h"
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

    // Toolbarの表示をONにする
    //[self.navigationController setToolbarHidden:NO animated:NO];
    // 他のテーブルビューによって追加されたボタンを削除
    [self removeButtonFromToolbar];
    // ボタンを追加する
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
    Item * item = self.itemArray[indexPath.row];
    
    // 画像をセット
    cell.imageView.image = [UIImage imageNamed:item.itemImgName];
    
    // テキストラベルをセット
    cell.textLabel.text = item.itemName;
    
    
    // imageView をタップしたときイベントが発生するようにする
    [cell.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(imageViewTapped:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [cell.imageView addGestureRecognizer:tap];
    

    // checkArrayに含まれるものにチェックを入れ、そうでないもののチェックを外す
    [self checkOnOffContainedInCheckArray:cell atIndexPath:indexPath];
    
    return cell;
}

//-- セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択されたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // チェックマークのオン・オフ
    [self checkOnOffSelectedCell:cell atIndexPath:indexPath];
    NSLog(@"%lu", (unsigned long)app.checkArray.count);
}

//-- セルの選択がはずれた時に呼び出される
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択がはずれたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // チェックマークのオン・オフ
    [self checkOnOffSelectedCell:cell atIndexPath:indexPath];
    NSLog(@"%lu", (unsigned long)app.checkArray.count);
    
}

//-- checkArrayに含まれているアイテムのチェックマークを自動でオン・オフする
- (void)checkOnOffContainedInCheckArray:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item * item = self.itemArray[indexPath.row];
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

//-- セルを選択した時にチェックマークをつける
- (void)checkOnOffSelectedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item * item = self.itemArray[indexPath.row];
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

//-- 選択モード時にキャンセルボタンを表示する
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

//-- 選択モード時にツールバーを表示する
- (void)showHideToolbar
{
    
    //UITabBar *tabbar = self.tabBarController.tabBar;

    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    //float tabbarHeight = tabbar.frame.size.height;
    float toolbarHeight = app.toolbar.frame.size.height;
    if ([self isCheckModeON]){ // チェックアレイにアイテムが入っていればツールバーを表示
        [UIView animateWithDuration:0.3
                         animations:^{
                             app.toolbar.frame = CGRectMake(0.0f, screenHeight-toolbarHeight, 320.0f, toolbarHeight);
                         }];
    } else{ // チェックアレイにアイテムが入っていなければツールバーを非表示
        [UIView animateWithDuration:0.3
                         animations:^{
                             app.toolbar.frame = CGRectMake(0.0f, screenHeight, 320.0f, toolbarHeight);
                         }];

    }
}


//-- ボタンをツールバーに追加する
- (void)addButtonToToolbar
{
    
    NSMutableArray * toolbarItems = [NSMutableArray array];
    //UIBarButtonItem * addToBuyButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
    //                                                                                target:self
    //                                                                                action:@selector(addItemToBuyArray)];
    // 買う物リストに追加ボタンを作る
    UIButton *addToBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addToBuyButton.frame = CGRectMake(0, 0, 119, 30);
    [addToBuyButton setImage:[UIImage imageNamed:@"addtobuybutton.png"] forState:UIControlStateNormal];
    [addToBuyButton addTarget:self action:@selector(addItemToBuyArray) forControlEvents:UIControlEventTouchUpInside];
    // 買う物リストに追加ボタンをUIBarButtonItemに変換する
    UIBarButtonItem *addToBuyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addToBuyButton];

    
    UIButton *addToMissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addToMissionButton.frame = CGRectMake(0, 0, 119, 30);
    [addToMissionButton setImage:[UIImage imageNamed:@"addtomissionbutton.png"] forState:UIControlStateNormal];
    [addToMissionButton addTarget:self action:@selector(addItemToMissionArray) forControlEvents:UIControlEventTouchUpInside];
    // 買う物リストに追加ボタンをUIBarButtonItemに変換する
    UIBarButtonItem *addToMissionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addToMissionButton];
    
    // 固定間隔のスペーサーを作成する
    UIBarButtonItem * fixedSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpacer.width = 1;
    // 可変間隔のスペーサーを作成する
    UIBarButtonItem * flexibleSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    // ツールバーに追加するオブジェクトの配列にボタンとスペーサーを追加する
    [toolbarItems addObjectsFromArray:@[flexibleSpacer, addToBuyBarButtonItem, fixedSpacer, addToMissionBarButtonItem, flexibleSpacer]];
    // ツールバーにボタンをセットする
    [app.toolbar setItems:toolbarItems];
}

- (void) addItemToMissionArray
{
    NSLog(@"addToMission");
}

//-- 他のテーブルビューで追加したボタンをツールバーから削除する
- (void)removeButtonFromToolbar
{
    NSMutableArray * toolbarItems = [NSMutableArray array];
    // 空の配列をセットすることでツールバーからボタンを削除する
    [app.toolbar setItems:toolbarItems];
}

//-- BuyArrayにアイテムを追加する
- (void)addItemToBuyArray
{
    for (int i=0; i<app.checkArray.count; i++) {
        Item * item = app.checkArray[i];
        if (![app.buyArray containsObject:item]) { // buyArrayに追加済みでなければ
            [app.buyArray addObject:item]; // itemをbuyArrayに追加する
        }
    }
    // 追加しましたメッセージ
    NSString * addToBuyDoneMessage = [NSString stringWithFormat:@"%lu個のアイテムを追加しました！", (unsigned long)app.checkArray.count];
    
    // チェックモードをオフにする
    [self checkModeOff];
    
    //アラートを作成
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:addToBuyDoneMessage
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil
                          ];
    
    
    // アラートを自動で閉じる秒数をセットするタイマー
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlertAtTimerEnd:) userInfo:alert repeats:NO];

    // アラートを表示する
    [alert show];
    
    NSLog(@"%lu", (unsigned long)app.buyArray.count);
}

//-- タイマー終了でアラートを閉じる
-(void)closeAlertAtTimerEnd:(NSTimer*)timer
{
    UIAlertView *alert = [timer userInfo];
    // アラートを自動で閉じる
    [alert dismissWithClickedButtonIndex:0 animated:YES];
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

//-- チェックモードがオンならばYESを返す
- (BOOL)isCheckModeON
{
    return app.checkArray.count>0;
}

//-- セルのイメージビューをタップしたときに実行する
- (void)imageViewTapped:(UITapGestureRecognizer*)sender
{
    if (![self isCheckModeON]) {
        // タップされた位置からセルの indexPath を取得
        CGPoint point = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        Item * item = self.itemArray[indexPath.row];
        [self performSegueWithIdentifier:@"CategoryTableToDetail" options:item.itemId];
        
        
    }

}
//-- セルのアクセサリービューにカスタム「チェックマーク」を入れる
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

//-- セルのアクセサリービューにカスタム「チェックマークなし」を入れる
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

@end
