//
//  ZYTokenManager.m
//  自定义搜索框并缓存搜索记录
//
//  Created by xiayong on 16/3/11.
//  Copyright © 2016年 bianguo. All rights reserved.
//

#import "ZYTokenManager.h"

@implementation ZYTokenManager


//缓存搜索数组
+(void)SearchText :(NSString *)seaTxt
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray *myArray = [userDefaultes arrayForKey:@"myArray"];
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        
    }else{
        myArray = [NSArray array];
    }
   
    // NSArray --> NSMutableArray
    NSMutableArray *myMutableArray = [myArray mutableCopy];
    NSMutableArray *Arr = [NSMutableArray array];
    if (myMutableArray.count==0) {
        [Arr insertObject:seaTxt atIndex:0];
    }else{
        for (NSString*str in myMutableArray) {
            if (![str isEqualToString:seaTxt]) {
                [Arr addObject:str];
                   
            }else{
                [Arr insertObject:str atIndex:0];
            }
        }
        NSString *first = [Arr firstObject];
        if (![seaTxt isEqualToString:first]) {
            [Arr insertObject:seaTxt atIndex:0];
        }
    }

    
    if(Arr.count > 20)
    {
        [Arr removeLastObject];
    }
//    将上述数据全部存储到NSUserDefaults中
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:Arr forKey:@"myArray"];
    [userDefaultes synchronize];
}
+(void)removeAllArray{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"myArray"];
    [userDefaults synchronize];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com