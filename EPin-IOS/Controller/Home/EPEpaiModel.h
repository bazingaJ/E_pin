//
//  EPEpaiModel.h
//  EPin-IOS
//
//  Created by jeaderL on 16/7/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPEpaiModel : NSObject

/**拍卖品Id*/
@property(nonatomic,copy)NSString * goodsId;
/**拍卖品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**原价*/
@property(nonatomic,copy)NSString * goodsPrice;
/**半价*/
@property(nonatomic,copy)NSString * goodsClapPrice;
/**剩余时间*/
@property(nonatomic,copy)NSString * lostTime;
/**拍卖品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**认购人数*/
@property(nonatomic,copy)NSString * onlookers;
/**认购状态*/
@property(nonatomic,copy)NSString * subscribe;
@end

//得主风采
@interface EPWinnerModel : NSObject

/**拍卖品Id*/
@property(nonatomic,copy)NSString * goodsId;
/**拍卖品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**原价*/
@property(nonatomic,copy)NSString * goodsPrice;
/**半价*/
@property(nonatomic,copy)NSString * goodsClapPrice;
/**拍卖品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**获奖图片*/
@property(nonatomic,copy)NSString * winingImg;
/**获奖人手机号*/
@property(nonatomic,copy)NSString * phoneNo;
/**商品活动区间*/
@property(nonatomic,copy)NSString * time;

@end

@interface EPMyEpaiModel : NSObject

/**拍卖品Id*/
@property(nonatomic,copy)NSString * goodsId;
/**拍卖品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**原价*/
@property(nonatomic,copy)NSString * goodsPrice;
/**半价*/
@property(nonatomic,copy)NSString * goodsClapPrice;
/**拍卖品图片*/
@property(nonatomic,copy)NSString * goodsImg;
/**剩余时间*/
@property(nonatomic,copy)NSString * lostTime;
/**参与竞拍时间*/
@property(nonatomic,copy)NSString * joinTime;
/**认购状态*/
@property(nonatomic,copy)NSString * subscribe;
/**订单号*/
@property(nonatomic,copy)NSString * orderId;

@end
