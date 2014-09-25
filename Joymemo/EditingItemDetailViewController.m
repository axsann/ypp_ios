//
//  EditingItemDetailViewController.m
//  Joymemo
//
//  Created by kanta on 2014/09/25.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "EditingItemDetailViewController.h"
#import "AppDelegate.h"

@interface EditingItemDetailViewController ()

@end

@implementation EditingItemDetailViewController {
    AppDelegate * app;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    // 背景色を設定
    self.view.backgroundColor = app.bgColor;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"キャンセル"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToItemDetail)];
    self.navigationItem.title = @"アイテム編集";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToItemDetail
{
    [self.navigationController popViewControllerAnimated:NO];
}

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
