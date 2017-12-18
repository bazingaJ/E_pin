//
//  EPPassViewController.h
//  EPin-IOS
//
//  Created by jeaderL on 16/3/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPPassViewController : UIViewController

//旧密码
@property (weak, nonatomic) IBOutlet UITextField *textPass;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *textInput;
//再次输入
@property (weak, nonatomic) IBOutlet UITextField *oldPass;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn1;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn2;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn3;


@end
