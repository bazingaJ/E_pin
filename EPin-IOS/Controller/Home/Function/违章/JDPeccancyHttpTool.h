//
//  JDPeccancyHttpTool.h
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum JDPeccancyDataType{
    /**
     *  所有的数据
     */
    JDPeccancyDataTypeTotal,
    /**
     *  正在处理中的数据
     */
    JDPeccancyDataTypeProcessing,
    /**
     *  处理完成的数据
     */
    JDPeccancyDataTypeComplete
    
}dataType;

@interface JDPeccancyHttpTool : NSObject

@property (nonatomic, assign) dataType dataType;

/**
 *  请求网络数据
 */
+(void)peccancyGetDataInVc:(UIViewController *)Vc licenseNo:(NSString *)licenseNo engineNo:(NSString *)engineNo Success:(void(^)())success failure:(void(^)(NSError *error))failure;
/**
 *  获取违章数据(数据库) 返回模型数组
 *
 *  dataType : 获取的数据类型
 */
+(NSArray *)peccancyDataType:(dataType)dataType;


@end
