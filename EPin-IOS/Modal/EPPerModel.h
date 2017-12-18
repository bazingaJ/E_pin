//
//  EPPerModel.h
//  EPin-IOS
//
//  Created by jeaderL on 16/4/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPPerModel : NSObject
/**姓名*/
@property(nonatomic,copy)NSString * name;
/**头像*/
@property(nonatomic,copy)NSString * icon;
/**邀请码*/
@property(nonatomic,copy)NSString * inviteCode;
/**剩余总积分*/
@property(nonatomic,copy)NSString * totolScore;
@end
/**会员信息VIP*/
@interface EPVIPModel : NSObject

/**升级需要总数*/
@property(nonatomic,copy)NSString * conditions;
/**会员等级*/
@property(nonatomic,copy)NSString * grade;
/**等级数*/
@property(nonatomic,copy)NSString * level;
/**需要人数1*/
@property(nonatomic,copy)NSString * level1Count;
/**需要人数2*/
@property(nonatomic,copy)NSString * level2Count;
/**需要人数3*/
@property(nonatomic,copy)NSString * level3Count;
/**当前等级推荐人数*/
@property(nonatomic,copy)NSString * referrals;

@end
