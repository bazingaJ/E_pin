//
//  EPSpendView.m
//  EPin-IOS
//
//  Created by jeader on 2016/11/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSpendView.h"
#import "HeaderFile.h"
#import "NSString+PlaceholderString.h"
#define KSTATIONHEADERTEXTCOLOR RGBColor(51, 51, 51)
#define KPRICETEXTCOLOR RGBColor(225, 8, 8)

static NSString * const kStationHeaderTitle = @"200积分专区";
static CGFloat const kStationHeaderFont = 15;
static CGFloat const kGoodsNameFont = 14;
static CGFloat const kRightWordFont = 11;

@interface EPSpendView ()

@property (nonatomic, strong)  UILabel * stationHeaderTitle;

@end

@implementation EPSpendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame withContentModel:(EPMainModel *)model withController:(UIViewController *)viewController
{
    if (self=[super initWithFrame:frame])
    {
        //添加表头标题
        [self defineStationHeaderTitleWithModel:model];
        //添加有段更多按钮
        [self defineMoreButton];
        //添加商品图片
        [self defineGoodsPhotosWithMainModel:model];
        //添加商品名称
        [self defineGoodsNameWithMainModel:model];
        //添加商品描述
        [self defineRightLabelWithMainModel:model];
        //添加商品价格
        [self defineGoodsPriceWithMainModel:model];
        
        
        
        self.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled=YES;
    }
    return self;
}

#pragma mark - 创建区头标题
- (void)defineStationHeaderTitleWithModel:(EPMainModel *)model
{
    UILabel * stationHeaderTitle = [[UILabel alloc] init];
    stationHeaderTitle.frame = CGRectMake(15, 15, 160, 22);
    stationHeaderTitle.text = kStationHeaderTitle;
    stationHeaderTitle.font = [UIFont systemFontOfSize:kStationHeaderFont];
    stationHeaderTitle.textColor = KSTATIONHEADERTEXTCOLOR;
    _stationHeaderTitle = stationHeaderTitle;
    [self addSubview:_stationHeaderTitle];
}

#pragma mark - 创建右端更多按钮
- (void)defineMoreButton
{
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"花积分-更多"] forState:UIControlStateNormal];
    moreBtn.frame = CGRectMake(CGRectGetMaxX(self.frame)-31, 15, 16, 16);
    [self addSubview:moreBtn];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(15, CGRectGetMaxY(_stationHeaderTitle.frame)+ 7.5, EPScreenW-30, 1);
    lineView.backgroundColor = RGBColor(153, 153, 153);
    [self addSubview:lineView];
    
}
#pragma mark - 创建两个商品图片
- (void)defineGoodsPhotosWithMainModel:(EPMainModel *)model
{
    UIImageView * imageViewL = [[UIImageView alloc] init];
    imageViewL.frame = CGRectMake(15, CGRectGetMaxY(_stationHeaderTitle.frame)+17.5, 160, 100);
    [imageViewL sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"spend"]];
    _goodsImage = imageViewL;
    [self addSubview:_goodsImage];
    
    UIImageView * imageViewR = [[UIImageView alloc] init];
    imageViewR.frame = CGRectMake(CGRectGetMaxX(imageViewL.frame)+25, imageViewL.frame.origin.y, 160, 100);
    [imageViewR sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"spend"]];
//    _goodsImage = imageViewR;
    [self addSubview:imageViewR];
}

#pragma mark - 创建商品的名称
- (void)defineGoodsNameWithMainModel:(EPMainModel *)model
{
    UILabel * goodsNameLabelL = [[UILabel alloc] init];
    goodsNameLabelL.frame = CGRectMake(15, CGRectGetMaxY(_goodsImage.frame)+10, 100, 20);
    goodsNameLabelL.font = [UIFont systemFontOfSize:kGoodsNameFont];
    goodsNameLabelL.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"林下参"];
    goodsNameLabelL.textColor = KSTATIONHEADERTEXTCOLOR;
    goodsNameLabelL.backgroundColor = [UIColor yellowColor];
    _commodityName = goodsNameLabelL;
    [self addSubview:_commodityName];
    
    UILabel * goodsNameLabelR = [[UILabel alloc] init];
    goodsNameLabelR.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+25, CGRectGetMaxY(_goodsImage.frame)+10, 100, 20);
    goodsNameLabelR.font = [UIFont systemFontOfSize:kGoodsNameFont];
    goodsNameLabelR.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"林下参"];
    goodsNameLabelR.textColor = KSTATIONHEADERTEXTCOLOR;
    [self addSubview:goodsNameLabelR];
}

#pragma mark - 创建商品名称右侧文字
- (void)defineRightLabelWithMainModel:(EPMainModel *)model
{
    UILabel * rightWordLabelL = [[UILabel alloc] init];
    rightWordLabelL.frame = CGRectMake(CGRectGetMaxX(_commodityName.frame), CGRectGetMaxY(_goodsImage.frame)+10, 60, 19);
    rightWordLabelL.font = [UIFont systemFontOfSize:kRightWordFont];
    rightWordLabelL.textAlignment = NSTextAlignmentRight;
    rightWordLabelL.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"测试数据"];
    rightWordLabelL.textColor = KSTATIONHEADERTEXTCOLOR;
    rightWordLabelL.backgroundColor = [UIColor cyanColor];
    [self addSubview:rightWordLabelL];
    
    UILabel * rightWordLabelR = [[UILabel alloc] init];
    rightWordLabelR.frame = CGRectMake(CGRectGetMaxX(_commodityName.frame)+185, CGRectGetMaxY(_goodsImage.frame)+10, 60, 19);
    rightWordLabelR.font = [UIFont systemFontOfSize:kRightWordFont];
    rightWordLabelR.textAlignment = NSTextAlignmentRight;
    rightWordLabelR.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"测试数据"];
    rightWordLabelR.textColor = KSTATIONHEADERTEXTCOLOR;
    [self addSubview:rightWordLabelR];
}

#pragma mark - 创建商品的价格
- (void)defineGoodsPriceWithMainModel:(EPMainModel *)model
{
    UILabel * priceLabelL = [[UILabel alloc] init];
    priceLabelL.frame = CGRectMake(15, CGRectGetMaxY(_commodityName.frame), 100, 17);
    priceLabelL.font = [UIFont systemFontOfSize:kGoodsNameFont];
    priceLabelL.text = [NSString stringByRealString:model.goodsPrice WithReplaceString:@"¥1.00"];
    priceLabelL.textColor = KPRICETEXTCOLOR;
    priceLabelL.backgroundColor = [UIColor magentaColor];
    [self addSubview:priceLabelL];
    
    UILabel * priceLabelR = [[UILabel alloc] init];
    priceLabelR.frame = CGRectMake(200, CGRectGetMaxY(_commodityName.frame), 100, 17);
    priceLabelR.font = [UIFont systemFontOfSize:kGoodsNameFont];
    priceLabelR.text = [NSString stringByRealString:model.goodsPrice WithReplaceString:@"¥1.00"];
    priceLabelR.textColor = KPRICETEXTCOLOR;
    [self addSubview:priceLabelR];
}

#pragma mark - 创建月售文字
- (void)defineSaleInMouthWithMainModel:(EPMainModel *)model
{
    UILabel * saleCountLabel = [[UILabel alloc] init];
    saleCountLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)-100, CGRectGetMaxY(self.frame)-15, 100, 20);
    
    
}

@end
