//
//  JDPeccancyHttpTool.m
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDPeccancyHttpTool.h"

#import "HeaderFile.h"
#import "EPData.h"

#import "CYFMDBuse.h"
#import "JDPeccancyData.h"
#import "EPLoginViewController.h"

static CYFMDBuse *_db;
@implementation JDPeccancyHttpTool

+(void)peccancyGetDataInVc:(UIViewController *)Vc licenseNo:(NSString *)licenseNo engineNo:(NSString *)engineNo Success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    // @"苏AJ08G9" @"005362"
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"] = PHONENO;
//    params[@"password"] = PASSWORD;
    params[@"licenseNo"] = licenseNo;
    params[@"engineNo"] = engineNo;
    params[@"loginTime"] = LOGINTIME;
    NSString *urlStr = @"http://114.55.57.237/tad/client/getViolation.json";
    [EPData getDataWithUrl:urlStr params:params success:^(id response) {
        
        NSDictionary *dict = (NSDictionary *)response;
        NSArray *dataArr = dict[@"historys"];
        int returnCode = [response[@"returnCode"] intValue];
        
        
        if (returnCode==0) {
            
            CYFMDBuse *db = [[CYFMDBuse alloc] init];
            _db = db;
            
            // 删除表
            [db deleteTable];
            // 创建表
            [db createTable];
            
            // 插入数据
            for (NSDictionary *dict in dataArr) {
                
                [db insertValuesForKeysWithDict:dict];
            }
            
            if (success) {
                success();
            }
            
        }else if(returnCode==2){
            
                   }else{
            
//            // 如果不能请求到数据 在8s延时之后会到数据库加载数据
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                if (success) {
//                    success();
//                }
//                
//            });
//            
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
  
}

+(NSArray *)peccancyDataType:(dataType)dataType
{
    // 查询表 获取数据
    NSArray *dictArr = [_db query];
    
    // 接受模型的数组
    NSMutableArray *modelArr = [NSMutableArray array];
    
    // 遍历数组取出字典
    for (NSDictionary *dict in dictArr) {
        
        // 创建模型 将字典转换为模型
        JDPeccancyData *peccData = [JDPeccancyData peccDataWithDict:dict];
        
//        NSLog(@"1111%@",peccData.result);
        
        [modelArr addObject:peccData];
    }
    
    // 排序
    // 装未处理的模型数组
    NSMutableArray *no = [NSMutableArray array];
    // 装正在处理的模型数组
    NSMutableArray *ing = [NSMutableArray array];
    // 装已经完成的模型数组
    NSMutableArray *complete = [NSMutableArray array];
    // 装一扣分
    NSMutableArray *score = [NSMutableArray array];
    
    for (JDPeccancyData *data in modelArr) {
        
        int fen = [data.fen intValue];
        
        if (fen) { // 有扣分，不能处理
            [score addObject:data];
        }else{ // 无扣分
            if ([data.result isEqualToString:@"未处理"]) { // 未处理的违章记录
                [no addObject:data];
            }else if ([data.result isEqualToString:@"处理中"]){ // 正在处理中的违章记录
                [ing addObject:data];
            }else{ // 已完成的违章处理
                [complete addObject:data];
            }
        }
        
    }
    
    [modelArr removeAllObjects];
    [modelArr addObjectsFromArray:no];
    [modelArr addObjectsFromArray:ing];
    [modelArr addObjectsFromArray:complete];
    [modelArr addObjectsFromArray:score];
    
    if (dataType == JDPeccancyDataTypeProcessing) { //处理中
        return ing;
    }else if (dataType == JDPeccancyDataTypeComplete) { // 已完成
        return complete;
    }else{ // 所有的数据
        return modelArr;
    }

    return nil;
}

@end
