//
//  EPOrderTableVC.h
//  EPin-IOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPOrderTableVC : UITableViewController

@property (nonatomic, strong) NSDictionary * fileDic;

@property (nonatomic, strong) UIButton * nowLocationBtn;
@property (nonatomic, strong) UIButton * destinationBtn;
- (void)seeDriver;
@end
