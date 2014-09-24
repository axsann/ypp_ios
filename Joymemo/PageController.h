//
//  PageController.h
//  Joymemo
//
//  Created by kanta on 2014/09/14.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "ViewPagerController.h"
#import "Cate.h"

@interface PageController : ViewPagerController<ViewPagerDelegate, ViewPagerDataSource>
@property (strong, nonatomic) Cate * cate;
@end
