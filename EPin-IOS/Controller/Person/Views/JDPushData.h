//
//  JDPushData.h
//  eTaxi-iOS
//
//  Created by jeader on 16/5/26.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDPushData : NSObject

/**
 * 用户Id
 */
@property(nonatomic,copy)NSString * userId;
/**
 *  推送消息的主题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  推送的内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  当前时间
 */
@property (nonatomic, copy) NSString *currentTime;
/**
 *  推送消息的初始化状态，用来判断已读还是未读
 */
@property (nonatomic, copy) NSString *flag;
/**
 *  如果是use，展示在消息栏,,,如果是order，语音播报内容
 */
@property (nonatomic, copy) NSString *methodName;

+(instancetype)pushDataWithDictionary:(NSDictionary *)dict;

@end
