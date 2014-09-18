//
//  Categories.m
//  
//
//  Created by kanta on 2014/09/16.
//
//

#import "Categories.h"

@implementation Categories




-(void)loadJSON:(NSString *)fileName
{
    // カテゴリ名は固定なので予め同じものを用意する
    self.catNameArray = [NSMutableArray arrayWithObjects:@"キッチン", @"リビング", @"風呂場", @"トイレ", @"洗面所", @"その他", nil];
    self.itemInCategoryDict = [NSMutableDictionary dictionary];
    //self.itemArray = [NSMutableArray array];
    // JSONファイルを読み込む
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData * itemInCatFile = [NSData dataWithContentsOfFile:path];
    // 辞書データに変換する
    NSDictionary * itemDict = [NSJSONSerialization JSONObjectWithData:itemInCatFile
                                                              options:0
                                                                error:nil];
    
    for (int i=0; i<self.catNameArray.count; i++){
        // カテゴリごとのアイテムリストを辞書リストに読み込む
        NSString * catName = [NSString stringWithString:self.catNameArray[i]];
        [self.itemInCategoryDict setObject:itemDict[catName] forKey:catName];
        //[self.itemArray addObject:[self.itemInCategoryDict objectForKey:self.catNameArray[i]]];
    }
    
}




@end

