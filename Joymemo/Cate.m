//
//  Cate.m
//  Joymemo
//
//  Created by kanta on 2014/09/18.
//  Copyright (c) 2014年 kanta. All rights reserved.
//

#import "Cate.h"

@implementation Cate



-(void)loadJSON:(NSString *)fileName
{
    // カテゴリ名は固定なので予め同じものを用意する
    self.cateNameArray = [NSMutableArray arrayWithObjects:@"キッチン", @"リビング", @"風呂場", @"トイレ", @"洗面所", @"その他", nil];
    NSMutableArray * itemDictArray = [NSMutableArray array];
    self.cateDict = [NSMutableDictionary dictionary];
    // JSONファイルを読み込む
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    // 辞書データに変換する
    NSDictionary * fileDict = [NSJSONSerialization JSONObjectWithData:fileData
                                                              options:0
                                                                error:nil];
    // JSONと同じ構造でcateDictを作成する
    // cateDict内には、カテゴリ名をKeyとしてitemArrayが入る
    // itemArray内にItemクラスのitemが入る
    for (int i=0; i<self.cateNameArray.count; i++) {
        NSString * cateName = [NSString stringWithString:self.cateNameArray[i]];
        NSMutableArray * itemArray = [NSMutableArray array];
        [itemDictArray addObject:[fileDict objectForKey:cateName]];
        NSMutableArray * tempArray = [itemDictArray[i] mutableCopy]; // カテゴリ内アイテムの配列を一時的に用意
        for (int j=0; j<tempArray.count; j++) {
            Item * item = [[Item alloc]init];
            NSDictionary * tempDict = [NSDictionary dictionaryWithDictionary:tempArray[j]]; // アイテムの辞書を一時的に用意
            // itemの内容をセット
            [item setItemId:[tempDict objectForKey:@"item_id"]
                setItemName:[tempDict objectForKey:@"item_name"]
             setItemImgName:[tempDict objectForKey:@"thumb"]];
            [itemArray addObject:item]; // itemArrayにItemクラスのitemを追加
        }
        [self.cateDict setObject:itemArray forKey:cateName]; // カテゴリ名がKeyの辞書cateDictにitemArrayを追加
    }
}



@end
