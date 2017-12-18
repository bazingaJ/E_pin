//
//  EPPhoneGetCodeVC.h
//  EPin-IOS
//
//  Created by jeaderL on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPPhoneGetCodeVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfNewPhone;

@property (weak, nonatomic) IBOutlet UITextField *tfCode;

@property(nonatomic,copy)NSString * pass;

@end
