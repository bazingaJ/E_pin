//
//  EPAddressVC.h
//  EPin-IOS
//
//  Created by jeader on 16/6/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPNowTableVC;
@class EPOrderTableVC;

@interface EPAddressVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableVi;
@property (nonatomic, strong) EPNowTableVC * nowViewCon;
@property (nonatomic, strong) EPOrderTableVC * orderViewCon;
@property (nonatomic,assign) BOOL isUp;
@property (nonatomic,assign) BOOL isOrder;
@end
