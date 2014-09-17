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
    self.catNameArray = [NSMutableArray arrayWithObjects:@"キッチン", @"リビング", @"風呂場", @"トイレ", @"洗面所", @"その他", nil];
    self.itemInCategoryDict = [NSMutableDictionary dictionary];
    // JSONファイルを読み込む
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData * itemInCatFile = [NSData dataWithContentsOfFile:path];
    // 辞書データに変換する
    NSDictionary * itemDict = [NSJSONSerialization JSONObjectWithData:itemInCatFile
                                                              options:0
                                                                error:nil];
    
    for (id key in [itemDict keyEnumerator]) {
        // カテゴリ名を配列に読み込む
        //[self.catNameArray addObject:key];
        // カテゴリごとのアイテムリストを辞書リストに読み込む
        [self.itemInCategoryDict setObject:itemDict[key] forKey:key];
    }
    
}






@end

