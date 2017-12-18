//
//  EPViewInCell.h
//  EPin-IOS
//
//  Created by jeader on 2016/10/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPMainModel.h"

@interface EPViewInCell : UIView

@property (nonatomic, strong)  UIImageView * goodsImage;
@property (nonatomic, strong)  UILabel * commodityName;
@property (nonatomic, strong)  UILabel * commodityPoint;
@property (nonatomic, strong)  UIButton * coverBtn;

- (instancetype)initWithFrame:(CGRect)frame withContentModel:(EPMainModel *)model withController:(UIViewController *)viewController;

@end
