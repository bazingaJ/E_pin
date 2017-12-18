//
//  EPFaresController.h
//  EPin-IOS
//
//  Created by jeaderq on 16/6/12.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end
@interface EPFaresController : UIViewController

@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * driverId;
@property BOOL isScan;

- (void)disappearView;

@end
