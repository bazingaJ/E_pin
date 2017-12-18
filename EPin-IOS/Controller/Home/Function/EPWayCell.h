//
//  EPWayCell.h
//  EPin-IOS
//
//  Created by jeader on 16/5/3.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPWayCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * payTime;
@property (nonatomic, weak) IBOutlet UILabel * plateNo;
@property (nonatomic, weak) IBOutlet UILabel * moneyLab;
@property (nonatomic, weak) IBOutlet UILabel * pointLab;
@property (nonatomic, weak) IBOutlet UIButton * choiceBtn;

@end
