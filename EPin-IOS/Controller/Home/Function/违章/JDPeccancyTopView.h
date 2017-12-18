//
//  JDPeccancyTopView.h
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JDPeccancyBtnClick)(NSInteger index);

@interface JDPeccancyTopView : UIView

@property (nonatomic, copy) NSArray *nameArr;

@property (nonatomic, strong) JDPeccancyBtnClick btnClick;

// 选中哪一个按钮
-(void)selectBtnIndex:(NSInteger)index;

-(void)peccancyBtnClick:(JDPeccancyBtnClick)btnClick;

@end
