//
//  EPDetailModel.h
//  EPin-IOS
//
//  Created by jeaderL on 16/4/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>
//商品model
@interface EPDetailModel : NSObject

/**商品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**商品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**商品星级*/
@property(nonatomic,copy)NSString * goodsStar;
/**商品价格*/
@property(nonatomic,copy)NSString * goodsPrice;
/**商品优惠价格*/
@property(nonatomic,copy)NSString * goodsCheapPrice;
/**商品最高可使用*/
@property(nonatomic,copy)NSString * costScore;
/**已售数量*/
@property(nonatomic,copy)NSString * soldNumber;
/**地址*/
@property(nonatomic,copy)NSString * address;
/**随时退*/
@property(nonatomic,copy)NSString *  anyTime;
/**过期退*/
@property(nonatomic,copy)NSString * overTime;
/**电话*/
@property(nonatomic,copy)NSString * phone1;
/**电话2*/
@property(nonatomic,copy)NSString * phone2;
/**人均价格*/
@property(nonatomic,copy)NSString * perAvgPrice;
/**店铺停业状态*/
@property(nonatomic,copy)NSString * shopState;
/**商家ID*/
@property(nonatomic,copy)NSString * shopId;
/**商家名称*/
@property(nonatomic,copy)NSString * shopName;
/**商品有效期*/
//@property(nonatomic,copy)NSString * goodsExpires;
/**商品位置仅供参考*/
@property(nonatomic,copy)NSString * goodsPosition;
/**商品详细图片*/
@property(nonatomic,copy)NSString * describeImg;
/**团购详情内容*/
@property(nonatomic,strong)NSArray * detailsRecord;
/**团购详情补充*/
@property(nonatomic,strong)NSArray * addRecord;
/**基本参数数组*/
@property(nonatomic,strong)NSArray * record;
/**是否被收藏*/
@property(nonatomic,copy)NSString * isCollection;
@property(nonatomic,strong)NSArray * packageArr;


@end

@interface EPShopModel : NSObject

/**商家图片*/
@property(nonatomic,copy)NSString * shopImg;
/**商家名称*/
@property(nonatomic,copy)NSString * shopName;
/**商家地址*/
@property(nonatomic,copy)NSString * shopAddress;
/**商家电话1*/
@property(nonatomic,copy)NSString * shopPhone;
/**商家电话2*/
@property(nonatomic,copy)NSString * shopPhones;
/**人均价格*/
@property(nonatomic,copy)NSString * perAvgPrice;
/**已售数量*/
@property(nonatomic,copy)NSString * soldNumber;
/**商家星级*/
@property(nonatomic,copy)NSString *  shopStar;
@property(nonatomic,strong)NSArray * discounArr;
@end
/**优惠方案数组*/
@interface EPDiscountModel : NSObject

/**优惠商品图地址*/
@property(nonatomic,copy)NSString * discountImg;
/**优惠方案名称*/
@property(nonatomic,copy)NSString * discountName;
/**优惠方案原价*/
@property(nonatomic,copy)NSString * discountPrice;
/**优惠后价格*/
@property(nonatomic,copy)NSString * discountSubPrice;
/**是否热门*/
@property(nonatomic,copy)NSString * isHot;
/**商品ID*/
@property(nonatomic,copy)NSString * goodsId;
@end
@interface EPPackageModel : NSObject

/**套餐名称*/
@property(nonatomic,copy)NSString * packageName;
/**套餐价格*/
@property(nonatomic,copy)NSString * packageCheapPrice;
/**套餐id*/
@property(nonatomic,copy)NSString * packageId;
@end

@interface EPGoodsFavorModel : NSObject

/**商品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**商品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**已售数量*/
@property(nonatomic,copy)NSString * soldNumber;
/**商品ID*/
@property(nonatomic,strong)NSString * goodsId;
@property(nonatomic,strong)NSString * goodsCheapPrice;

@end

@interface EPGetCommentModel : NSObject

@property(nonatomic,copy)NSString * headImgAddress;
@property(nonatomic,copy)NSString * passengerName;
@property(nonatomic,copy)NSString *  commentStar;
/**时间*/
@property(nonatomic,copy)NSString * commentTime;
@property(nonatomic,copy)NSString * commentContent;
@property(nonatomic,copy)NSString * goodsName;
@property(nonatomic,copy)NSString * goodsImg;
//评价图片数组
@property(nonatomic,strong)NSArray *  commentImgArr;

@end
/**订单详情model*/
@interface EPOrderDetailModel : NSObject

/**商品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**商品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**商家名称*/
@property(nonatomic,copy)NSString * shopName;
/**商品价格*/
@property(nonatomic,copy)NSString * goodsPrice;
/**下单时间*/
@property(nonatomic,copy)NSString * orderTime;
/**兑换码*/
@property(nonatomic,copy)NSString * exchangeCode;
/**商家地址*/
@property(nonatomic,copy)NSString * shopAddress;
/**商家电话*/
@property(nonatomic,copy)NSString * shopPhone;

@end

