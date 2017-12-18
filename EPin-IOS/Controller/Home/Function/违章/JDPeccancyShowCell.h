//
//  JDPeccancyShowCell.h
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPeccancyShowCell : UITableViewCell

/**
 *  违章项目
 */
@property (weak, nonatomic) IBOutlet UILabel *peccName;
/**
 *  违章罚款数
 */
@property (weak, nonatomic) IBOutlet UILabel *peccMoney;
/**
 *  违章扣分
 */
@property (weak, nonatomic) IBOutlet UILabel *peccScore;
/**
 *  违章时间
 */
@property (weak, nonatomic) IBOutlet UILabel *peccTime;
/**
 *  违章的处理状态
 */
@property (weak, nonatomic) IBOutlet UIButton *peccStatus;
/**
 *  选择的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *peccImage;


@end
