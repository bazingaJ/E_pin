//
//  EPGoods.h
//  EPin-IOS
//
//  Created by jeaderQ on 16/4/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPGoods : NSObject
/**
 *  商品
 */
@property (nonatomic, strong) NSString *goodsImg;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, strong) NSString *goodsCounts;
@property (nonatomic, strong) NSString *goodsStar;
@property (nonatomic, strong) NSString *goodsSaleImg;
@property (nonatomic, strong) NSString *goodsPosition;
@property (nonatomic, strong) NSString *goodsCheapPrice;
@end
