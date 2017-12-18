//
//  EPNewsCell.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPNewsCell.h"

@implementation EPNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.redView.layer.masksToBounds=YES;
    self.redView.layer.cornerRadius=5;
    self.redView.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
