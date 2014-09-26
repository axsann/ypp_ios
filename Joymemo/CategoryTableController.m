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
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CreateMissionViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface CategoryTableController ()
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)checkOnOffContainedInCheckArray:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)checkOnOffSelectedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)showHideCancelButton;
- (void)showHideToolbar;
- (void)addButtonToToolbar;
- (void)addToMissionButtonTapped;
- (void)removeButtonFromToolbar;
- (void)addItemToBuyList; // 買う物リストへ追加ボタンを押した時に実行されるメソッド
- (void)closeAlertAtTimerEnd:(NSTimer*)timer;
- (void)ExitCheckMode;
- (BOOL)isCheckModeOn;
- (void)imageViewTapped:(UITapGestureRecognizer*)sender;
- (void)setCheckmarkOnCell:(UITableViewCell *)cell;
- (void)setNotCheckmarkOnCell:(UITableViewCell *)cell;
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)addThumbToCellImageView:(NSArray *)cellAndIndexPathAndThumbStrArray;
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
    NSString *cellIdentifier = @"Cell";
    // セルを準備する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero; // 境界線を左端から表示
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // セルの選択時にハイライトを行わない
    // 配列からアイテムを読み込む
    Item * item = self.itemArray[indexPath.row];
    // テキストラベルをセット
    cell.textLabel.text = item.itemName;
    // 画像をセット
    NSURL * thumbUrl = [NSURL URLWithString:item.thumb];
    [cell.imageView sd_setImageWithURL:thumbUrl placeholderImage:[UIImage imageNamed:@"no_item_image.jpg"] options:SDWebImageCacheMemoryOnly];
    
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
    if ([app.checkArray containsObject:item.itemId]){
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
        [app.checkArray addObject:item.itemId];
        [self setCheckmarkOnCell:cell];
    }
    else { // チェックマークがあれば、チェックマークを消す
        //cell.accessoryType = UITableViewCellAccessoryNone;
        [app.checkArray removeObject:item.itemId];
        [self setNotCheckmarkOnCell:cell];

    }
    // 選択モード時にツールバーを表示する
    [self showHideToolbar];
    // 選択モード時にキャンセルボタンを表示する
    [self showHideCancelButton];
}


//-- 選択モード時にキャンセルボタンを表示する
- (void)showHideCancelButton
{
    if ([self isCheckModeOn]) {
        UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(ExitCheckMode)];
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
    if ([self isCheckModeOn]){ // チェックアレイにアイテムが入っていればツールバーを表示
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
    [addToBuyButton addTarget:self action:@selector(addToBuyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    // 買う物リストに追加ボタンをUIBarButtonItemに変換する
    UIBarButtonItem *addToBuyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addToBuyButton];

    
    UIButton *addToMissionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addToMissionButton.frame = CGRectMake(0, 0, 119, 30);
    [addToMissionButton setImage:[UIImage imageNamed:@"addtomissionbutton.png"] forState:UIControlStateNormal];
    [addToMissionButton addTarget:self action:@selector(addToMissionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
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



- (void)addThumbToCellImageView:(NSArray *)cellAndIndexPathArray
{
    UITableViewCell * cell = cellAndIndexPathArray[0];
    NSIndexPath * indexPath = cellAndIndexPathArray[1];
    // 配列からアイテムを読み込む
    Item * item = self.itemArray[indexPath.row];
    
    // サムネイル画像をセット
    NSURL * thumbUrl = [NSURL URLWithString:item.thumb];
    NSData * thumbData = [NSData dataWithContentsOfURL:thumbUrl];
    cell.imageView.image = [UIImage imageWithData:thumbData];
}

//-- 他のテーブルビューで追加したボタンをツールバーから削除する
- (void)removeButtonFromToolbar
{
    NSMutableArray * toolbarItems = [NSMutableArray array];
    // 空の配列をセットすることでツールバーからボタンを削除する
    [app.toolbar setItems:toolbarItems];
}

- (void)addToBuyButtonTapped
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self performSelector:@selector(addItemToBuyList) withObject:nil afterDelay:0.1];
}

- (void)addToMissionButtonTapped
{
    CreateMissionViewController * createMissionViewController = [CreateMissionViewController new];
    // checkArrayをコピー
    createMissionViewController.itemIdArray = [app.checkArray mutableCopy];
    // チェックモードをオフにする
    [self ExitCheckMode];
    
    createMissionViewController.hidesBottomBarWhenPushed = YES;
    // アニメーションを作成
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    // navigationControllerにアニメーションを設定
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:createMissionViewController animated:NO];
}

//-- サーバーの買う物リストにアイテムを追加する
- (void)addItemToBuyList
{
    
    for (int i=0; i<app.checkArray.count; i++) {
        NSString * itemId = app.checkArray[i];
        [app.netManager postBuyListData:itemId];
    }
    
    // 追加しましたメッセージ
    NSString * addToBuyDoneMessage = [NSString stringWithFormat:@"%lu個のアイテムを追加しました！", (unsigned long)app.checkArray.count];
    
    // チェックモードをオフにする
    [self ExitCheckMode];
    
    //アラートを作成
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:addToBuyDoneMessage
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil
                          ];
    
    
    // アラートを自動で閉じる秒数をセットするタイマー
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlertAtTimerEnd:) userInfo:alert repeats:NO];
    [SVProgressHUD dismiss];
    // アラートを表示する
    [alert show];

}


//-- タイマー終了でアラートを閉じる
- (void)closeAlertAtTimerEnd:(NSTimer*)timer
{
    UIAlertView *alert = [timer userInfo];
    // アラートを自動で閉じる
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// チェックモードをオフにする
- (void)ExitCheckMode
{
    // チェックアレイから全てのオブジェクトを削除
    [app.checkArray removeAllObjects];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j) {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i) {
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
- (BOOL)isCheckModeOn
{
    return app.checkArray.count>0;
}

//-- セルのイメージビューをタップしたときに実行する
- (void)imageViewTapped:(UITapGestureRecognizer*)sender
{
    if (![self isCheckModeOn]) {
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
    
    return self.cateName; // タイトル名をカテゴリ名にする
}

//-- セクションのタイトルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //return 0; // セクションのタイトルを非表示にする
    return 40;
}

//-- セルの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

@end
