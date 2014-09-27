//
//  ItemTableViewCell.m
//  Joymemo
//
//  Created by kanta on 2014/09/27.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

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
    self.imageView.frame = CGRectMake(0, 0, 52, 52);
    float imageViewWidth =  self.imageView.image.size.width;
    if(imageViewWidth > 0) {
        self.textLabel.frame = CGRectMake(70, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(70, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }
}

@end
