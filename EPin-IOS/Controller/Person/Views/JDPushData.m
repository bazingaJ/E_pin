//
//  JDPushData.m
//  eTaxi-iOS
//
//  Created by jeader on 16/5/26.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDPushData.h"

#import "MJExtension.h"

@implementation JDPushData

+(instancetype)pushDataWithDictionary:(NSDictionary *)dict
{
    id data = [self mj_objectWithKeyValues:dict];
    
    return data;
}

@end
