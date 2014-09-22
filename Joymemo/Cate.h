//
//  Cate.h
//  Joymemo
//
//  Created by kanta on 2014/09/18.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cate : NSObject
@property (strong, nonatomic) NSMutableArray * cateNameArray; // カテゴリ名を格納した配列
@property (strong, nonatomic) NSMutableDictionary * itemInCateDict; // カテゴリ名をKeyとしてアイテムの配列を格納
-(void)loadJsonWithFileName:(NSString *)fileName; //テスト用
- (void)loadJson: (NSData *)jsonData;
@end
