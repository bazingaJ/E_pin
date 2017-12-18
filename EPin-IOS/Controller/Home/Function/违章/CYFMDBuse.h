//
//  CYFMDBuse.h
//  CYLearnSQLite
//
//  Created by jeader on 16/5/13.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@interface CYFMDBuse : NSObject

/**
 *  打开数据库
 */
//-(void)openFMDB;
/**
 *  创建表
 */
-(void)createTable;
/**
 *  增加数据
 */
-(void)insertValuesForKeysWithDict:(NSDictionary *)dict;
/**
 *  删除表
 */
-(void)deleteTable;
/**
 *  查询数据
 */
-(NSArray *)query;


@end
