//
//  networkManager.h
//  Joymemo
//
//  Created by yasutomo shirahama on 2014/09/19.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface networkManager : NSObject

+(networkManager *) shared;

-(void) getListData;
-(UIImage *) getThumbURL:(NSString *)url;

@end