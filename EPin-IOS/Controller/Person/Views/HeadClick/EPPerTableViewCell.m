//
//  EPPerTableViewCell.m
//  EPin-IOS
//
//  Created by jeaderL on 16/3/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPerTableViewCell.h"
#import "HeaderFile.h"

@implementation EPPerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImg.layer.masksToBounds=YES;
    self.headImg.layer.cornerRadius=27.5;
    
    //self.headImg.frame=CGRectMake(EPScreenW-30, 10, 55, 55);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
