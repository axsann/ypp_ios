//
//  HistoryTableViewCell.m
//  Joymemo
//
//  Created by kanta on 2014/09/27.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // アイテムのサムネイル画像を表示するイメージビューを固定する
    self.imageView.frame = CGRectMake(16, 16, 52, 52);
    // 円形に切り抜く
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width * 0.5f;
    self.imageView.clipsToBounds = YES;
    
    float imageViewWidth =  self.imageView.image.size.width;
    if(imageViewWidth > 0) {
        self.textLabel.frame = CGRectMake(76, self.textLabel.frame.origin.y, 240, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(76, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }
}


@end
