//
//  EPNowOrderCell.h
//  EPin-IOS
//
//  Created by jeader on 16/4/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPNowOrderCell : UITableViewCell

/**
 *  cell4
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLocation;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UIButton * star1;
@property (nonatomic, weak) IBOutlet UIButton * star2;
@property (nonatomic, weak) IBOutlet UIButton * star3;
@property (nonatomic, weak) IBOutlet UIButton * judgeBtn;
@property (nonatomic, strong) NSString * cellOrderId;
@end
