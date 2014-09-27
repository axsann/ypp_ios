//
//  PagingViewController.h
//  
//
//  Created by kanta on 2014/09/27.
//
//

#import <UIKit/UIKit.h>
#import "TTSlidingPagesDataSource.h"
#import "TTSliddingPageDelegate.h"
#import "Cate.h"

@interface PagingViewController : UIViewController <TTSliddingPageDelegate, TTSlidingPagesDataSource>
@property (strong, nonatomic) Cate * cate;

@end
