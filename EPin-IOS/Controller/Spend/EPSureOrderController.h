//
//  EPSureOrderController.h
//  EPin-IOS
//
//  Created by jeaderq on 16/6/16.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
//@interface Product : NSObject{
//@private
//    float     _price;
//    NSString *_subject;
//    NSString *_body;
//    NSString *_orderId;
//}
//
//@property (nonatomic, assign) float price;
//@property (nonatomic, copy) NSString *subject;
//@property (nonatomic, copy) NSString *body;
//@property (nonatomic, copy) NSString *orderId;
//
//@end

@interface EPSureOrderController : UIViewController
@property(nonatomic,copy)NSString * goodsId;
@property (nonatomic, strong) NSString *numbe;
@property (nonatomic, strong) NSString *useJF;
@property (nonatomic, strong) NSString *goodsName;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *payPriceL;
//名称右边的价格
@property (weak, nonatomic) IBOutlet UILabel *payPriceNL;
//明细的商品名
@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
//数量
@property (weak, nonatomic) IBOutlet UILabel *numberL;
//单价
@property (weak, nonatomic) IBOutlet UILabel *unitPriceL;
//总价
@property (weak, nonatomic) IBOutlet UILabel *payPriceNL2;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, assign) BOOL isMyMoney;
@property (nonatomic, assign) BOOL isAliPay;
@property (nonatomic, assign) BOOL isWechart;
//-(NSString *)jumpToBizPay;

@end
