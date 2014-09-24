//
//  MissionTableViewCell.m
//  Joymemo
//
//  Created by kanta on 2014/09/24.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "MissionTableViewCell.h"
@interface MissionTableViewCell ()

@end
@implementation MissionTableViewCell

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

@end
