//
//  EPOrderDVC.h
//  EPin-IOS
//
//  Created by jeaderL on 2016/12/2.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPOrderDVC : UIViewController

@property(nonatomic,copy)NSString * goodsImg;
@property(nonatomic,copy)NSString * goodsName;
@property(nonatomic,copy)NSString * commitTime;
@property(nonatomic,copy)NSString * shopName;
@property(nonatomic,copy)NSString * exchangeCode;
@property(nonatomic,copy)NSString * shopPhone;
@property(nonatomic,copy)NSString * shopAddress;
@property(nonatomic,copy)NSString * useScore;
@property(nonatomic,copy)NSString * goodsCount;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,strong)NSArray *  useCodeList;
@property(nonatomic,copy)NSString * statusName;

@end
