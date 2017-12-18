//
//  EPLostViewController.h
//  EPin-IOS
//
//  Created by jeader on 16/3/31.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPLostVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView * tableVi;
/**
 *  自定义view上的控件
 */
@property (nonatomic, weak) IBOutlet UIView * headView;
@property (nonatomic, weak) IBOutlet UIButton * walletBtn;
@property (nonatomic, weak) IBOutlet UIButton * bagBtn;
@property (nonatomic, weak) IBOutlet UIButton * fileBtn;
@property (nonatomic, weak) IBOutlet UIButton * keyBtn;
@property (nonatomic, weak) IBOutlet UIButton * clothesBtn;
@property (nonatomic, weak) IBOutlet UIButton * technologyBtn;
@property (nonatomic, weak) IBOutlet UIButton * teleBtn;
@property (nonatomic, weak) IBOutlet UIButton * earPhoneBtn;
@property (nonatomic, weak) IBOutlet UIButton * notYetBtn;


/**
 *  collecitoinCell
 */
@property (nonatomic, weak) IBOutlet UIImageView * img;
@property (nonatomic, weak) IBOutlet UILabel * titleLab;
@end
