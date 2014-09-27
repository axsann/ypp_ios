//
//  Cate.m
//  Joymemo
//
//  Created by kanta on 2014/09/18.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "Cate.h"
#import "Item.h"

@interface Cate ()
-(void)loadJson:(NSData *)jsonData;

@end

@implementation Cate

-(void)loadJson:(NSData *)jsonData
{
    // カテゴリ名は固定なので予め同じものを用意する
    self.cateNameArray = [NSMutableArray arrayWithObjects:@"キッチン", @"リビング", @"お風呂", @"トイレ", @"洗面所", @"その他", nil];
    self.cateHeaderImageNameArray = [NSMutableArray arrayWithObjects:@"kitchen.png", @"living.png", @"bath.png", @"toilet.png", @"lavatory.png", @"others.png", nil];
    
    self.itemInCateDict = [NSMutableDictionary dictionary];

    // JSONを配列に変換する
    NSError * parseError;
    NSMutableArray * fileArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:0
                                                                   error:&parseError];
    
    
    // itemInCateDictにはカテゴリ名をKeyとしてアイテムの配列が入る
    for (int i=0; i<self.cateNameArray.count; i++) {
        NSString * cateName = self.cateNameArray[i];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (int j=0; j<fileArray.count; j++) {
            NSMutableDictionary * itemDict = fileArray[j];
            if ([cateName isEqualToString:itemDict[@"category"]]) {
                Item * item = [[Item alloc]init];
                [item setItemId:itemDict[@"item_id"] setItemName:itemDict[@"item_name"]
                       setThumb:itemDict[@"thumb"] setCategory:itemDict[@"category"]];
                [tempArray addObject:item];
            }
        }
        [self.itemInCateDict setObject:tempArray forKey:cateName];
    }
    
}

//-- テスト用
-(void)loadJsonWithFileName:(NSString *)fileName
{
    // カテゴリ名は固定なので予め同じものを用意する
    self.cateNameArray = [NSMutableArray arrayWithObjects:@"キッチン", @"リビング", @"お風呂", @"トイレ", @"洗面所", @"その他", nil];
    self.itemInCateDict = [NSMutableDictionary dictionary];
    // JSONファイルを読み込む
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    // 配列に変換する
    NSError * error;
    NSMutableArray * fileArray = [NSJSONSerialization JSONObjectWithData:fileData
                                                              options:0
                                                                error:&error];
    
    
    // itemInCateDictにはカテゴリ名をKeyとしてアイテムの配列が入る
    for (int i=0; i<self.cateNameArray.count; i++) {
        NSString * cateName = self.cateNameArray[i];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (int j=0; j<fileArray.count; j++) {
            NSMutableDictionary * itemDict = fileArray[j];
            if ([cateName isEqualToString:itemDict[@"category"]]) {
                Item * item = [[Item alloc]init];
                [item setItemId:itemDict[@"item_id"] setItemName:itemDict[@"item_name"]
                   setThumb:itemDict[@"thumb"] setCategory:itemDict[@"category"]];
                [tempArray addObject:item];
            }
        }
        [self.itemInCateDict setObject:tempArray forKey:cateName];
    }
    
}

@end
