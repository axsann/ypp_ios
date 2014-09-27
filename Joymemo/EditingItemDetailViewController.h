//
//  EditingItemDetailViewController.h
//  Joymemo
//
//  Created by kanta on 2014/09/25.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingItemDetailViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSString * itemId;
@property (strong, nonatomic) UITextView * memoTextView;
@property (strong, nonatomic) UITextView * itemNameTextView;
@end
