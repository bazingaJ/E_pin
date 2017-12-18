//
//  EPPeccCell.h
//  EPin-IOS
//
//  Created by jeader on 16/4/5.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPPeccCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton * statesBtn;
@property (nonatomic, weak) IBOutlet UILabel * stateLab;
@property (nonatomic, weak) IBOutlet UILabel * infoLab;
@property (nonatomic, weak) IBOutlet UILabel * roadLab;
@property (nonatomic, weak) IBOutlet UILabel * timeLab;
@property (nonatomic, weak) IBOutlet UILabel * pointLab;
@property (nonatomic, weak) IBOutlet UILabel * fineLab;

/**
 *  cell2
 */
@property (nonatomic, weak) IBOutlet UIImageView * typeImg;
/**
 *  cell4
 */
@property (nonatomic, weak) IBOutlet UIButton * btn1;
@property (nonatomic, weak) IBOutlet UIButton * btn2;
@property (nonatomic, weak) IBOutlet UIButton * btn3;
@end
