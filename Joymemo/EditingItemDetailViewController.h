//
//  EditingItemDetailViewController.h
//  Joymemo
//
//  Created by kanta on 2014/09/25.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingItemDetailViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSString * itemId;
@property (strong, nonatomic) NSString * itemName;
@property (strong, nonatomic) NSString * memoText;
@property (strong, nonatomic) UITextView * memoTextView;
@property (strong, nonatomic) UITextView * itemNameTextView;
@property (strong, nonatomic) UIImageView * itemImageView;
@property (strong, nonatomic) UIImage * itemImage;
@end
