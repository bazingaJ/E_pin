//
//  UIViewController+NavigationBar.h
//  YIPIN
//
//  Created by jeader on 16/3/22.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    NavigationBarStyleDefault, //默认没有图片 带返回
    NavigationBarStyleMainView, //主页的效果
    NavigationBarStyleJustBlack, //只有黑色背景 不带返回
    NavigationBarStyleVipCenter  //会员中心
}NavigationBarStyle;

@interface UIViewController (NavigationBar)

/**
 *  首页的导航条
 */
-(void)addNavigationBar:(NavigationBarStyle)barStyle;
-(void)addMaintitle:(NSString *)title;
-(void)addNavigationBar:(NavigationBarStyle)barStyle title:(NSString *)title;
-(void)addNavigationBar1:(NavigationBarStyle)barStyle title:(NSString *)title;
-(void)addStarRightItemWithFrame:(CGRect)frame action:(SEL)action name:(NSString *)name;
-(void)addLeftItemWithFrame:(CGRect)frame textOrImage:(int)index action:(SEL)action name:(NSString *)name;

-(void)addRightItemWithFrame:(CGRect)frame textOrImage:(int)index action:(SEL)action name:(NSString *)name;

/**
  *添加两个导航栏按钮
 */
-(void)addTwoRightItemWithFrame:(CGRect)frame action:(SEL)action name:(NSString *)name;
/**
 *  设置右边带有圆角效果的按钮
 */
-(void)addRightBtnWithFrame:(CGRect)frame action:(SEL)action name:(NSString *)name;

-(void)addNavWithDynamicBar:(NSString *)title;
/*
 根据文字内容返回size
 */
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;

@end
