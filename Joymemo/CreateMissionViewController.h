//
//  CreateMissionViewController.h
//  Joymemo
//
//  Created by kanta on 2014/09/25.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMissionViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) NSMutableArray * itemIdArray;
@property (strong, nonatomic) NSMutableArray * otherUserArray;
@property (strong, nonatomic) NSMutableArray * userIconButtonArray;
@property (strong, nonatomic) NSString * selectedUserId;
@property (strong, nonatomic) UITextView * memoTextView;
@property (strong, nonatomic) UIImageView * userCheckImageView;
@end
