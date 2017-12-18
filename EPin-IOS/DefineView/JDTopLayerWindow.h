//
//  JDTopLayerWindow.h
//  eTaxi-iOS
//
//  Created by jeader on 16/2/21.
//  Copyright © 2016年 jeader. All rights reserved.
//  蒙层

#import <UIKit/UIKit.h>

typedef void(^Sms)(); // 短信
typedef void(^Wechat)(); // 微信
typedef void(^QQ)(); // QQ

@interface JDTopLayerWindow : UIWindow

@property (nonatomic, strong) Sms sms;

@property (nonatomic, strong) Wechat wechat;

@property (nonatomic, strong) QQ qq;


+ (JDTopLayerWindow *)sharedInstance;

- (void)show;

- (void)hidden;
- (void)shareDuanxin:(Sms)sms Wechat:(Wechat)wechat QQ:(QQ)qq;

@end
