//
//  MissionTableController.m
//  Joymemo
//
//  Created by kanta on 2014/09/24.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "MissionTableController.h"
#import "MissionTableViewCell.h"
#import "AppDelegate.h"

@interface MissionTableController ()

@end

@implementation MissionTableController{
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
    
    // 境界線の色を透明に設定
    self.tableView.separatorColor = [UIColor clearColor];
    // 背景色を設定
    self.tableView.backgroundColor = app.bgColor;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MissionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MissionCell" forIndexPath:indexPath];
    cell.backgroundColor = app.bgColor;
    cell.dateLabel.text = @"9月16日に依頼";
    cell.titleLabel.text = @"Joyからのお使い依頼";
    cell.commentTextView.text = @"醤油とオリーブオイルに命かけてます。";
    cell.commentTextView.editable = NO;
    cell.itemImageScrollVIew.contentSize = CGSizeMake(320, cell.itemImageScrollVIew.frame.size.height);
    UIImageView * itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 50, 50)];
    itemImageView.image = [UIImage imageNamed:@"joitest.jpg"];
    [cell.itemImageScrollVIew addSubview:itemImageView];
    
    UIImageView * item2ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 12, 50, 50)];
    item2ImageView.image = [UIImage imageNamed:@"joitest.jpg"];
    [cell.itemImageScrollVIew addSubview:item2ImageView];
    
    UIImageView * item3ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(135, 12, 50, 50)];
    item3ImageView.image = [UIImage imageNamed:@"joitest.jpg"];
    [cell.itemImageScrollVIew addSubview:item3ImageView];
    
    UIImageView * item4ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(195, 12, 50, 50)];
    item4ImageView.image = [UIImage imageNamed:@"joitest.jpg"];
    [cell.itemImageScrollVIew addSubview:item4ImageView];
    
    UIImageView * item5ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 12, 50, 50)];
    item5ImageView.image = [UIImage imageNamed:@"joitest.jpg"];
    [cell.itemImageScrollVIew addSubview:item5ImageView];
    
    UIImageView * creatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 24, 36, 36)];
    creatorImageView.image = [UIImage imageNamed:@"joitest.jpg"];
    creatorImageView.layer.cornerRadius = creatorImageView.frame.size.width * 0.5f;
    creatorImageView.clipsToBounds = YES;
    [cell addSubview:creatorImageView];
    
    
    // Configure the cell...
    
    return cell;
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
