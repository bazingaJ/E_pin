//
//  EPPaiCell.m
//  EPin-IOS
//
//  Created by jeaderL on 16/7/15.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPaiCell.h"
#import "EPEpaiModel.h"
#import "HeaderFile.h"
@implementation EPPaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.carImg.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.carImg.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.carImg.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.blackView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    
    maskLayer2.frame = self.blackView.bounds;
    
    maskLayer2.path = maskPath2.CGPath;
    
    self.blackView.layer.mask = maskLayer2;
    
}
- (void)setModel:(EPMyEpaiModel *)model{
    _model=model;
    self.startTime.text=[NSString stringWithFormat:@"参与时间: %@",model.joinTime];
    self.name.text=model.goodsName;
    [self.carImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];

        if ([model.lostTime isEqualToString:@"0日0时0分"]) {
            //写结束
            self.endTime.text=@"活动已结束";
            self.state.text=@"已结束";
        }else{
            NSArray * hours = [model.lostTime componentsSeparatedByString:@"时"];
            NSString *tm  = [hours[1] substringToIndex:1];
            if ([tm isEqualToString:@"-"]) {
                
                //写结束
                self.endTime.text=@"活动已结束";
                self.state.text=@"已结束";
                
            }else{
            self.endTime.text=[NSString stringWithFormat:@"还有%@结束",model.lostTime];
            self.endTime.adjustsFontSizeToFitWidth=YES;
            self.priceLb.text=model.goodsClapPrice;
            self.orgPrice.text=[NSString stringWithFormat:@"原价:%@",model.goodsPrice];
            
            if ([model.subscribe intValue]==0) {
                self.state.text=@"去付款";
            }else if([model.subscribe intValue]==1){
                self.state.text=@"认购中";
            }
            }
        }
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
