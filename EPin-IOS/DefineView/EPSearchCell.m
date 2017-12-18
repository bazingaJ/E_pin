//
//  EPSearchCell.m
//  EPin-IOS
//
//  Created by jeader on 16/3/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSearchCell.h"
#import "EPDetailModel.h"
#import "UIImageView+WebCache.h"
@implementation EPSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(EPGoodsFavorModel *)model{
    _model=model;
    self.lbName.text=model.goodsName;
    self.lbSold.text=[NSString stringWithFormat:@"月售%@份",model.soldNumber];
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
