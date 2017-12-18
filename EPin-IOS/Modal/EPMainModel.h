//
//  EPMainModel.h
//  EPin-IOS
//
//  Created by jeaderQ on 16/4/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EPMainModel : NSObject

/**
 *  首页
 */
@property (nonatomic, strong) NSArray *bannerArr;
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, strong) NSArray *shopsArr;
@property (nonatomic, strong) NSString *goodsSaleImg;
/**
 * 购物
 */
@property (nonatomic, strong) NSArray *shoppingActivity1Arr;
@property (nonatomic, strong) NSArray *shoppingActivity2Arr;

/**
 *  商家 以及商品 
 */
@property (nonatomic, strong) NSString *goodsImg;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, strong) NSString *shopsName;
@property (nonatomic, strong) NSString *goodsCounts;
@property (nonatomic, strong) NSString *shopsImg;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopsId;
@property (nonatomic, strong) NSString *goodsStar;
@property (nonatomic, strong) NSString *goodsPosition;
/**
 *  失物招领
 */
@property (nonatomic, strong) NSString *lostId;
@property (nonatomic, strong) NSString *lostImage;
@property (nonatomic, strong) NSString *lostTime;
@property (nonatomic, strong) NSString *lostType;
@property (nonatomic, strong) NSString *lostDesc;
//错误信息
@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSString * secondImg;
@property (nonatomic, strong) NSString * secondName;
@property (nonatomic, strong) NSString * secondPrice;
@property (nonatomic, strong) NSString * secondGoodsId;
@property (nonatomic, strong) NSString * thirdImg;
@property (nonatomic, strong) NSString * thirdName;
@property (nonatomic, strong) NSString * thirdPrice;

@property (nonatomic, strong) NSString * discountPrice;
@property (nonatomic, strong) NSString * sellCounts;

@property (nonatomic, assign) double payPrice;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *sign;

//我的积分
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *costName;
@property (nonatomic, strong) NSString *updateDate;

@end

@interface EPEPaiDetailModel : NSObject

/**认购须知*/
@property(nonatomic,copy)NSString * SubscriptionImg;
/**认购价格*/
@property(nonatomic,copy)NSString * currentPrice;
/**拍爱品详情图片*/
@property(nonatomic,copy)NSString * describeImg;
/**拍卖品价格*/
@property(nonatomic,copy)NSString * goodsClapPrice;
/**拍品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**拍卖品价格原价*/
@property(nonatomic,copy)NSString * goodsPrice;
/**拍卖品图片banner用*/
@property(nonatomic,strong)NSArray * imgArray;
/**剩余时间*/
@property(nonatomic,copy)NSString * lostTime;
/**认购人数*/
@property(nonatomic,copy)NSString * onlookers;
/**基本参数数组*/
@property(nonatomic,strong)NSArray * record;
/**状态*/
@property(nonatomic,copy)NSString * status;
//认购状态
@property (nonatomic, strong) NSString *subscribe;
@property (nonatomic, strong) NSString *orderId;
@end
