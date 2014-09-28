//
//  AccountTableViewCell.h
//  Joymemo
//
//  Created by kanta on 2014/09/28.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *itemScrollView;
@end
