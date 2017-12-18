//
//  EPCustomAlertView.h
//  EPin-IOS
//
//  Created by jeaderL on 16/3/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 代理方法
@protocol EPCustomAlertViewDelegate <NSObject>

// 可选执行方法
@optional
// 点击按钮下标时传递参数
- (void)didSelectAlertButton:(NSString *)title;
@end

@interface EPCustomAlertView : NSObject

/**单例*/
+ (EPCustomAlertView *)singleClass;


/** 快速创建提示框*/
- (UIView *)quickAlertViewWithArray:(NSArray *)array;

// 代理属性
@property (assign, nonatomic)id<EPCustomAlertViewDelegate>delegate;


@end
