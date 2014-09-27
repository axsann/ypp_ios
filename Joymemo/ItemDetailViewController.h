//
//  ItemDetailViewController.h
//  
//
//  Created by kanta on 2014/09/20.
//
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemDetailViewController : UIViewController
@property (strong, nonatomic) NSString * itemId;
@property (strong, nonatomic) UIImageView * itemLargeImageView;
@end
