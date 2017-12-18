//
//  EPTool.h
//  EPin-IOS
//
//  Created by jeader on 16/4/6.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderFile.h"

/**
 *   @brief 封装的工具类
 */

@interface EPTool : NSObject

/**
 *  快速创建alertView
 *
 *  @param VC      要显示在哪个控制器上面
 *  @param title   显示内容的主题
 *  @param message 显示的内容
 *  @param index   下面有几个按钮 （确定和取消按钮 0代表一个，其他数字代表有两个）
 *  @param what    点击确定按钮之后做得事情
 */
+ (void)addAlertViewInView:(UIViewController *)VC title:(NSString *)title message:(NSString *)message count:(int)index doWhat:(void (^)(void))what;

/**
 *  验证手机号是否合法
 *
 *  @param textString 被验证的手机号
 *
 *  @return 返回一个BOOL值
 */
+ (BOOL)validatePhone:(NSString *) textString;

/**
 *  验证密码是否合法
 *
 *  @param textString 被验证的密码
 *
 *  @return 返回一个BOOL值
 */
+ (BOOL)validatePassword:(NSString *) textString;
/**
 *  验证输入是否是汉字
 *
 *  @param textString 被验证的字符串
 *
 *  @return 返回一个BOOL值
 */
+(BOOL)validateChinese:(NSString *) textString;
//封装一个alertcontroller的类
- (UIAlertController *)showAlertControllerWithTitle:(NSString *)title WithMessages:(NSString *)msg WithCancelTitle:(NSString *)cancelTitle;
/**
 *  添加MBProgress
 *
 *  @param view 添加到哪个视图上
 */
+ (void)addMBProgressWithView:(UIView *)view style:(int)index;
+ (void)showMBWithTitle:(NSString *)title;
+ (void)hiddenMBWithDelayTimeInterval:(int)interval;

//一个可以检测是否有网络链接的方法
+(void)checkNetWorkWithCompltion:(void(^)(NSInteger statusCode))block;

//判断是否登录过
+(BOOL)isLogin;
+ (void)getPublicKey;
//获取ip地址
+ (NSString  *)getIpAddresses;
//获取当前时间的秒数
+ (NSString *)getDate;

//根据returnCode处理服务器的返回结果值
+ (void)handleWithDataReturnedByTheServerInViewController:(UIViewController *)viewCon  WithInReturnCode:(NSInteger)code WithErrorMessage:(NSString *)msg WithReturnCodeEqualToZeroBlock:(void(^)(void))action WithReturnCodeEqualToOneBlock:(void(^)(void))errorMessage;

@end
