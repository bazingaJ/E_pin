//
//  EPAnalysis.h
//  EPin-IOS
//
//  Created by jeader on 16/4/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPAnalysis : NSObject

//花积分界面属性
@property (nonatomic, strong) NSString * bannerImg;
@property (nonatomic, strong) NSString * likeImg;
@property (nonatomic, strong) NSString * likeName;
@property (nonatomic, strong) NSString * likePrice;
@property (nonatomic, strong) NSString * likeGoodsId;

@property (nonatomic, strong) NSString * hotImg;
@property (nonatomic, strong) NSString * hotName;
@property (nonatomic, strong) NSString * hotPrice;
@property (nonatomic, strong) NSString * hotGoodsId;

@property (nonatomic, strong) NSString * secondImg;
@property (nonatomic, strong) NSString * secondName;
@property (nonatomic, strong) NSString * secondPrice;
@property (nonatomic, strong) NSString * secondGoodsId;
@property (nonatomic, strong) NSString * thirdImg;
@property (nonatomic, strong) NSString * thirdName;
@property (nonatomic, strong) NSString * thirdPrice;
@property (nonatomic, strong) NSString * thirdGoodsId;

@property (nonatomic, strong) NSString * discountPrice;
@property (nonatomic, strong) NSString * goodsImg;
@property (nonatomic, strong) NSString * goodsName;
@property (nonatomic, strong) NSString * goodsPrice;
@property (nonatomic, strong) NSString * sellCounts;
@property (nonatomic, strong) NSString * goodsID;



/**
 *  对花积分的返回的数据进行解析
 *
 *  @param dic 传入没有解析的字典
 *
 *  @return 返回解析好的字典
 */
- (NSMutableDictionary *)analysisWith:(NSMutableDictionary *)dic;

@end
