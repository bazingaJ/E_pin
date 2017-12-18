//
//  EPPerViewController.h
//  EPin-IOS
//
//  Created by jeaderL on 16/3/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *  name);

@interface EPPerViewController : UIViewController
/**头像照片*/
@property(nonatomic,strong)UIImage * hImg;
@property(nonatomic,copy)NSString  * imgName;
@property(nonatomic,copy)NSString * cellName;
//声明返回昵称回调
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

//回调返回昵称方法
- (void)returnText:(ReturnTextBlock)block;



@end
