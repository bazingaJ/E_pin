//
//  EPPaiCell.h
//  EPin-IOS
//
//  Created by jeaderL on 16/7/15.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPMyEpaiModel;
@interface EPPaiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigImg;
@property (weak, nonatomic) IBOutlet UIImageView *carImg;
@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *orgPrice;
@property (weak, nonatomic) IBOutlet UILabel *state;

@property(nonatomic,strong)EPMyEpaiModel * model;

@end
