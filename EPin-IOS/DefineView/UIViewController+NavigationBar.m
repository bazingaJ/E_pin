//
//  UIViewController+NavigationBar.m
//  YIPIN
//
//  Created by jeader on 16/3/22.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "HeaderFile.h"

#define BTNW 80 //按钮的宽度
#define BARBACKGROUNDCOLOR [UIColor colorWithRed:29/255.0 green:32/255.0 blue:40/255.0 alpha:1.0] //导航栏的底色

static UIImageView *_imageV;
static UILabel *titleView;



@implementation UIViewController (NavigationBar)

//添加导航条
-(void)addNavigationBar:(NavigationBarStyle)barStyle
{
    //背景图
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 64)];
    _imageV = imageV;
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled = YES;
    if (barStyle==NavigationBarStyleMainView) { //主页的效果
        imageV.backgroundColor = RGBColor(99, 99, 99);
        [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(popToViewController) name:@"返回"];

    }
    
    if (barStyle==NavigationBarStyleDefault) {
        imageV.backgroundColor = BARBACKGROUNDCOLOR;
        [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(popToViewController) name:@"返回"];
    }
    if (barStyle==NavigationBarStyleJustBlack) {
        imageV.backgroundColor = BARBACKGROUNDCOLOR;
    }
    
    if (barStyle ==NavigationBarStyleVipCenter){
        imageV.backgroundColor = RGBColor(23, 47, 99);
         [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(popToViewController) name:@"返回"];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=nil;
}

/**
 *  加导航栏
 *
 *  @param barStyle
 *  @param title    
 */
-(void)addNavigationBar:(NavigationBarStyle)barStyle title:(NSString *)title
{
    [self addNavigationBar:barStyle];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.center = CGPointMake(EPScreenW/2, 42);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleView = titleLabel;
    [_imageV addSubview:titleLabel];
    titleLabel.textColor = RGBColor(218, 187, 132);
    titleLabel.text = title;
    if (barStyle ==1) {
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = RGBColor(255, 255, 255);
        CGSize titleSize  = [self sizeWithText:title font:[UIFont systemFontOfSize:12]];
        titleLabel.width = titleSize.width;
        titleLabel.centerX = _imageV.centerX;
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time_banjiapai"]];
        image.centerY = titleLabel.centerY;
        image.x = CGRectGetMinX(titleLabel.frame)-21;
        [_imageV addSubview:image];
        
    }else{
    titleLabel.font = [UIFont systemFontOfSize:20];
    }
}
-(void)addNavigationBar1:(NavigationBarStyle)barStyle title:(NSString *)title
{
    [self addNavigationBar:barStyle];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.center = CGPointMake(EPScreenW/2, 42);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleView = titleLabel;
    [_imageV addSubview:titleLabel];
    titleLabel.textColor = RGBColor(252, 215, 149);
    titleLabel.text = title;
    if (barStyle ==1) {
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = RGBColor(255, 255, 255);
        CGSize titleSize  = [self sizeWithText:title font:[UIFont systemFontOfSize:12]];
        titleLabel.width = titleSize.width;
        titleLabel.centerX = _imageV.centerX;
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time_banjiapai"]];
        image.centerY = titleLabel.centerY;
        image.x = CGRectGetMinX(titleLabel.frame)-21;
        [_imageV addSubview:image];
        
    }else{
        titleLabel.font = [UIFont systemFontOfSize:23];
    }
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attri  =[NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize =CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

/**
 *  左边Item按钮
 *
 *  @param frame  左边字体的frame
 *  @param index  创建字或图片 0是图片 1是字
 *  @param action action description
 *  @param name   name 图片名
 */
-(void)addLeftItemWithFrame:(CGRect)frame textOrImage:(int)index action:(SEL)action name:(NSString *)name
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 20, BTNW, 44)];
    [self.view addSubview:button];
    if (action!=nil) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (index==0) { // 图片
        CGSize imageS = [[UIImage imageNamed:name] size];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, (44-imageS.height)/2, imageS.width, imageS.height)];
//        imageV.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:name];
        [button addSubview:imageV];
        
    }else{ // 文字
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = name;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = RGBColor(216, 186, 131);
        [button addSubview:label];
    }
   
}
-(void)addTwoRightItemWithFrame:(CGRect)frame action:(SEL)action name:(NSString *)name 
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self.view addSubview:button];
    if (action!=nil) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)addRightItemWithFrame:(CGRect)frame textOrImage:(int)index action:(SEL)action name:(NSString *)name
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(EPScreenW-BTNW, 20, BTNW, 44)];
    [self.view addSubview:button];
    if (action!=nil) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (index==0) { // 图片
        CGSize imageS = [[UIImage imageNamed:name] size];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(BTNW-20-imageS.width, (44-imageS.height)/2, imageS.width, imageS.height)];
//        imageV.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:name];
        [button addSubview:imageV];
        
    }else{ // 文字
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = name;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = RGBColor(216, 186, 131);
//        label.backgroundColor = RGBColor(216, 186, 131);
//        label.layer.masksToBounds = YES;
//        label.layer.cornerRadius = 5.0;
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
}
-(void)addMaintitle:(NSString *)title
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 64)];
    
    [self.view addSubview:imageV];
    imageV.backgroundColor = BARBACKGROUNDCOLOR;

}

-(void)addNavWithDynamicBar:(NSString *)title{
    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 64)];
    [self.view addSubview:bgV];
//    bgV.backgroundColor = 
    
}

-(void)addRightBtnWithFrame:(CGRect)frame action:(SEL)action name:(NSString *)name
{
    [self addRightItemWithFrame:frame textOrImage:1 action:action name:name];
}

-(void)popToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
