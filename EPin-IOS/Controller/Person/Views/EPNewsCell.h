//
//  EPNewsCell.h
//  EPin-IOS
//
//  Created by jeaderL on 16/6/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titile;

@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIImageView *newsImg;

@property (weak, nonatomic) IBOutlet UIView *redView;

@end
