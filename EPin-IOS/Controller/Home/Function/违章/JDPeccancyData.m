//
//  JDPeccancyData.m
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDPeccancyData.h"

#import "MJExtension.h"

@implementation JDPeccancyData

+(instancetype)peccDataWithDict:(NSDictionary *)dict
{
    id pecc = [self mj_objectWithKeyValues:dict];
    
    return pecc;
}

@end
