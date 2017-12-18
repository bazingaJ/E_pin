//
//  EPMNameViewController.h
//  EPin-IOS
//
//  Created by jeaderL on 16/3/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *  name);

@interface EPMNameViewController : UIViewController

//昵称输入框
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property(nonatomic,copy)NSString * nName;

//声明回调
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

//回调方法
- (void)returnText:(ReturnTextBlock)block;



@end
