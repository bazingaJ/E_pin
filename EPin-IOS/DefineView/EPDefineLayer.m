//
//  YJXlayer.m
//  animationPractice
//
//  Created by jeader on 16/3/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPDefineLayer.h"

@implementation EPDefineLayer

//重写改方法,在该方法内绘制图形
- (void)drawInContext:(CGContextRef)ctx
{
    //做一个测试
    //1.绘制图形
     //画一个圆
     CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 0, 0));
     //设置属性（颜色）
 //    [[UIColor yellowColor]set];
     CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);

     //2.渲染
     CGContextFillPath(ctx);
    
    
}


@end
