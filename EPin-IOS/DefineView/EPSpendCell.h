//
//  EPSpendCell.h
//  EPin-IOS
//
//  Created by jeader on 16/4/3.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSpendCell : UITableViewCell

/**
 *  cell3
 */
@property (nonatomic, weak) IBOutlet UIImageView * leadingImg;
@property (nonatomic, weak) IBOutlet UILabel * goodsName;
@property (nonatomic, weak) IBOutlet UILabel * goodsPrice;
@property (nonatomic, weak) IBOutlet UILabel * discountsPrice;
@property (nonatomic, weak) IBOutlet UILabel * sellCounts;
@property  NSInteger  myID;

/**
 *  cell4
 */
//@property (nonatomic, weak) IBOutlet UILabel * sectionTitle;
@property (nonatomic, weak) IBOutlet UIImageView * imgs1;
@property (nonatomic, weak) IBOutlet UILabel * goodsLabel;
@property (nonatomic, weak) IBOutlet UILabel * detailLabel;
@property (nonatomic, weak) IBOutlet UILabel * prices1;
@property (nonatomic, weak) IBOutlet UILabel * mouthSalesLabel;
@property (nonatomic, weak) IBOutlet UIImageView * heart1;
@property (nonatomic, weak) IBOutlet UIButton * btns1;

@property (nonatomic, weak) IBOutlet UIImageView * imgs2;
@property (nonatomic, weak) IBOutlet UILabel * goodsLabel2;
@property (nonatomic, weak) IBOutlet UILabel * detailLabel2;
@property (nonatomic, weak) IBOutlet UILabel * prices2;
@property (nonatomic, weak) IBOutlet UILabel * mouthSalesLabel2;
@property (nonatomic, weak) IBOutlet UIImageView * heart2;
@property (nonatomic, weak) IBOutlet UIButton * btns2;

/**
 *  cell5
 */
@property (nonatomic, weak) IBOutlet UIImageView * commodityImg;
@property (nonatomic, weak) IBOutlet UILabel * commodityName;
@property (nonatomic, weak) IBOutlet UILabel * commodityPrice;
@property (nonatomic, weak) IBOutlet UILabel * commodityDetailInfo;
@property (nonatomic, weak) IBOutlet UILabel * commoditySales;


@end
