//
//  EPSearchCell.h
//  EPin-IOS
//
//  Created by jeader on 16/3/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPGoodsFavorModel;
@interface EPSearchCell : UITableViewCell
/**
 *  cell1
 */
@property (nonatomic, weak) IBOutlet UILabel * historyLab;

/**
 *  cell3
 */
@property (nonatomic, weak) IBOutlet UIImageView * img;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbSold;

@property(nonatomic,strong)EPGoodsFavorModel * model;

@end
