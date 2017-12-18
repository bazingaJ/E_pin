//
//  EPCarModel.h
//  EPin-IOS
//
//  Created by jeaderL on 16/6/12.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPCarModel : NSObject

/**车牌号*/
@property(nonatomic,copy)NSString * plateNo;
/**发动机缸号*/
@property(nonatomic,copy)NSString * engineNo;
/**车牌编号*/
@property(nonatomic,copy)NSString * carNo;

@end
