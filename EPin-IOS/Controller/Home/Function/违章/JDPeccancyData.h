//
//  JDPeccancyData.h
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDPeccancyData : NSObject
/**
 *  违章记录编号
 */
@property (nonatomic, copy) NSString *code;
/**
 *  违章扣分
 */
@property (nonatomic, copy) NSString *fen;
/**
 *  违章记录id
 */
@property (nonatomic, copy) NSString *id;
/**
 *  违章具体信息
 */
@property (nonatomic, copy) NSString *info;
/**
 *  违章罚款数
 */
@property (nonatomic, copy) NSString *money;
/**
 *  违章地点
 */
@property (nonatomic, copy) NSString *occur_area;
/**
 *  违章时间
 */
@property (nonatomic, copy) NSString *occur_date;
/**
 *  违章处理结果
 */
@property (nonatomic, copy) NSString *result;

+(instancetype)peccDataWithDict:(NSDictionary *)dict;

@end
