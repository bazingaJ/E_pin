//
//  EPViewInCell.m
//  EPin-IOS
//
//  Created by jeader on 2016/10/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPViewInCell.h"
#import "HeaderFile.h"

@implementation EPViewInCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}
*/


#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame withContentModel:(EPMainModel *)model withController:(UIViewController *)viewController
{
    if (self=[super initWithFrame:frame])
    {
        //往View上面添加UIImageView控件
        [self defineImageViewWithFrame:frame withContentModel:model];
        //往View上面添加商品名称UILabel控件
        [self defineNameLabWithFrame:frame WithContentModel:model];
        //往View上面添加商品积分价格UILabel控件
        [self definePointLabWithFrame:frame WithContentModel:model];
        //创建一个按钮用于view用户交互
        [self defineButtonWithFrame:frame withController:viewController];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        self.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled=YES;
    }
    return self;
}

#pragma mark - 创建一个View上的图片
- (void)defineImageViewWithFrame:(CGRect)frame withContentModel:(EPMainModel *)model
{
    CGFloat superViewWidth = frame.size.width;
    UIImageView * goodsImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, superViewWidth, 118)];
    [goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"spend"]];
    _goodsImage = goodsImage;
    [self addSubview:_goodsImage];
    
}

#pragma mark - 创建一个商品名称的Label
- (void)defineNameLabWithFrame:(CGRect)frame WithContentModel:(EPMainModel *)model
{
    UILabel * commodityName = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_goodsImage.frame)+10, 126, 14)];
    commodityName.text=model.goodsName;
    commodityName.font=[UIFont systemFontOfSize:14];
    commodityName.textColor=[UIColor blackColor];
    _commodityName = commodityName;
    [self addSubview:_commodityName];
}

#pragma mark - 创建一个商品积分价格的Label
- (void)definePointLabWithFrame:(CGRect)frame WithContentModel:(EPMainModel *)model
{
    UILabel * commodityPoint = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(frame)-105, CGRectGetMaxY(_commodityName.frame)+20, 90, 14)];
    commodityPoint.text=[NSString stringWithFormat:@"%@ 积分",model.goodsPrice];
    commodityPoint.font=[UIFont systemFontOfSize:15];
    commodityPoint.textColor=RGBColor(225, 115, 0);
    commodityPoint.textAlignment=NSTextAlignmentRight;
    _commodityPoint = commodityPoint;
    [self addSubview:_commodityPoint];
    
}

#pragma mark - 创建一个按钮用于view用户交互
- (void)defineButtonWithFrame:(CGRect)frame withController:(UIViewController *)viewController
{
    UIButton * coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    [coverBtn setTitle:@"" forState:UIControlStateNormal];
    coverBtn.backgroundColor=[UIColor clearColor];
    _coverBtn = coverBtn;
    [self addSubview:_coverBtn];
    
}

@end
