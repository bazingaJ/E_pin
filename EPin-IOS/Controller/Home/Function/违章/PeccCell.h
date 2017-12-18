//
//  PeccCell.h
//  eTaxi-iOS
//
//  Created by jeader on 16/1/2.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeccCell : UITableViewCell
//违章详情 一区
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *whoLab;
//违章查询
@property (weak, nonatomic) IBOutlet UILabel *roadLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealStatus;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fineLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statuImage;


//使用记录
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsTime;
@property (weak, nonatomic) IBOutlet UILabel *goodsPoint;

//我的积分 cell1
@property (weak, nonatomic) IBOutlet UILabel * myPoint;
@property (weak, nonatomic) IBOutlet UIButton * marketBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

//收入明细
@property (weak, nonatomic) IBOutlet UILabel * itemLabel;
@property (weak, nonatomic) IBOutlet UILabel * contentLabel;

//处理界面
@property (weak, nonatomic) IBOutlet UILabel * pointLab;
@end
