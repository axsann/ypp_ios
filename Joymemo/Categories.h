//
//  Categories.h
//  
//
//  Created by kanta on 2014/09/16.
//
//

#import <UIKit/UIKit.h>
@interface Categories : NSObject
@property (strong, nonatomic) NSMutableArray * catNameArray;
@property (strong, nonatomic) NSMutableDictionary * itemInCategoryDict;

-(void)loadJSON:(NSString *)fileName;
@end
