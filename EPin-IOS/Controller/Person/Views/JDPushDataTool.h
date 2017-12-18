//
//  JDPushDataTool.h
//  eTaxi-iOS
//
//  Created by jeader on 16/5/26.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@interface JDPushDataTool : NSObject

/**
 *  创建表
 */
-(void)createTable;

/**
 *  插入数据
 */
-(void)insertValuesForKeysWithDictionary:(NSDictionary *)dict;

/**
 *  删除表
 */
-(void)deleteTable;

/**
 *  查询数据
 */
-(NSArray *)query;

@end
