//
//  EPSubmitController.h
//  EPin-IOS
//
//  Created by jeaderQ on 16/4/3.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSubmitController : UIViewController
{
    int num;
}
@property(nonatomic,copy)NSString * goodsId;
/**价格*/
@property(nonatomic,copy)NSString * price;
/**商品名称*/
@property(nonatomic,copy)NSString * goodsName;
/**最高可抵扣积分*/
@property(nonatomic,copy)NSString * costScore;
/**数量*/
@property(nonatomic,copy)NSString * count;
/**折扣*/
@property(nonatomic,assign)float zhekou;
@end
