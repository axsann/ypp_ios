//
//  MissionTableController.h
//  Joymemo
//
//  Created by kanta on 2014/09/24.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionTableController : UITableViewController
@property (strong, nonatomic) NSMutableArray * toMeMissionIdListArray;
@property (strong, nonatomic) NSMutableArray * toOtherMissionIdListArray;
@property (strong, nonatomic) NSMutableArray * toMeMissionDetailArray;
@property (strong, nonatomic) NSMutableArray * toOtherMissionDetailArray;

@end
