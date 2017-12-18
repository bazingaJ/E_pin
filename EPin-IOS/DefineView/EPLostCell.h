//
//  LostCell.h
//  EPin-IOS
//
//  Created by jeader on 16/4/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPLostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView * lostThing;
@property (nonatomic, weak) IBOutlet UILabel * someThing;
@property (weak, nonatomic) IBOutlet UILabel *lostTime;
@property (nonatomic, weak) IBOutlet UIButton * takeBtn;
@property (nonatomic, weak) IBOutlet UILabel * describeLab;
/**
 *  cell3
 */
@property (nonatomic, weak) IBOutlet UIButton * imgBtn;

/**
 cell 4
 */
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;


@end
