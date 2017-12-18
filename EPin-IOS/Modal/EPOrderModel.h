//
//  EPOrderModel.h
//  EPin-IOS
//
//  Created by jeaderL on 16/4/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPOrderModel : NSObject

/**商家名称*/
@property(nonatomic,copy)NSString * shopName;
/**商品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**商品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**下单日期*/
@property(nonatomic,copy)NSString * orderTime;
/**商品单价*/
@property(nonatomic,copy)NSString * goodsPrice;
/* 原价*/
@property (nonatomic,copy) NSString * goodsCheapPrice;
/**积分折扣*/
@property(nonatomic,copy)NSString * useScore;
/**订单状态*/
@property(nonatomic,copy)NSString * orderStatus;
/**订单号*/
@property(nonatomic,copy)NSString * orderNo;
/**商品ID*/
@property(nonatomic,copy)NSString * goodsId;
/**商品数量*/
@property(nonatomic,copy)NSString * goodsCount;
/**商家电话*/
@property(nonatomic,copy)NSString * shopPhone;
/**兑换码*/
@property(nonatomic,copy)NSString * exchangeCode;
/**商家地址*/
@property(nonatomic,copy)NSString * shopAddress;
/**待支付价格*/
@property(nonatomic,copy)NSString * payPrice;
/**订单状态名称*/
@property(nonatomic,copy)NSString * orderStatusName;
/**截止日*/
@property(nonatomic,copy)NSString * lastDate;
/**兑换码数组*/
@property(nonatomic,strong)NSArray * useCodeList;
/**是否评论*/
@property(nonatomic,copy)NSString * isEvaluate;
@end
