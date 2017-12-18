//
//  CYFMDBuse.m
//  CYLearnSQLite
//
//  Created by jeader on 16/5/13.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "CYFMDBuse.h"

#import "HeaderFile.h"

#import "JDPeccancyData.h"

#define FilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"peccany.sqlite"]


#define CODE @"code"
#define FEN @"fen"
#define ID @"id"
#define INFO @"info"
#define MONEY @"money"
#define AREA @"area"
#define DATE @"date"
#define RESULT @"result"

@interface CYFMDBuse ()


@end

static FMDatabase *_db;

@implementation CYFMDBuse


-(void)openFMDB
{
    // 获取数据库
    FMDatabase *db = [FMDatabase databaseWithPath:FilePath];
    // 打开数据库
    [db open];
    _db = db;
    
}

-(void)createTable
{
    [self openFMDB];
    
    // 创建表
    NSString *sql = [NSString stringWithFormat:@"create table if not exists peccany('%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text,'%@' text);",CODE,FEN,ID,INFO,MONEY,AREA,DATE,RESULT];
    
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
    }
    
    [_db close];
}

// 插入数据
-(void)insertValuesForKeysWithDict:(NSDictionary *)dict
{
    [self openFMDB];
    
    JDPeccancyData *data = [JDPeccancyData peccDataWithDict:dict];
    
    NSLog(@"%@--%@",data.occur_area,data.occur_date);
    
    NSString *insert = [NSString stringWithFormat:@"insert into peccany('%@','%@','%@','%@','%@','%@','%@','%@') values('%@','%@','%@','%@','%@','%@','%@','%@')",CODE,FEN,ID,INFO,MONEY,AREA,DATE,RESULT,data.code,data.fen,data.id,data.info,data.money,data.occur_area,data.occur_date,data.result];
    
    // executeUpdate:不确定的参数用？来占位
    BOOL result = [_db executeUpdate:insert];
    
    if (result) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败");
    }
    
    
    [_db close];
    
    
}

// 删除表
-(void)deleteTable
{
    [self openFMDB];
        
    BOOL result1 = [_db executeUpdate:@"drop table if exists peccany;"];
    
    if (result1) {
        NSLog(@"删除表成功");
    }else{
        NSLog(@"删除表失败");
    }
    
    [_db close];
    
    
}

// 查询
-(NSArray *)query
{
    NSMutableArray *arr = [NSMutableArray array];
    [self openFMDB];
        
    // 1.执行查询语句
    FMResultSet *resultSet = [_db executeQuery:@"select * from peccany"];
    
    
    // 2.遍历结果
    while ([resultSet next]) {
    
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        NSString *code = [resultSet stringForColumn:CODE];
        NSString *fen = [resultSet stringForColumn:FEN];
        NSString *id = [resultSet stringForColumn:ID];
        NSString *result = [resultSet stringForColumn:RESULT];
        NSString *date = [resultSet stringForColumn:DATE];
        NSString *area = [resultSet stringForColumn:AREA];
        NSString *info = [resultSet stringForColumn:INFO];
        NSString *money = [resultSet stringForColumn:MONEY];

        dict[@"code"] = code;
        dict[@"fen"] = fen;
        dict[@"id"] = id;
        dict[@"result"] = result;
        dict[@"occur_date"] = date;
        dict[@"occur_area"] = area;
        dict[@"info"] = info;
        dict[@"money"] = money;
        
        [arr addObject:dict];
        NSLog(@"%@--%@--%@--%@--%@--%@--%@--%@",code,fen,id,result,date,area,info,money);
    }
    
    NSLog(@"%ld",(unsigned long)arr.count);
    
    [_db close];
    
    
    return arr;
    
}


@end
