//
//  EPTabBar.m
//  EPin-IOS
//
//  Created by jeaderQ on 16/3/31.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPTabBar.h"
#import "HeaderFile.h"
@implementation EPTabBar
-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1、设置tabBar的背景 (tabBar的高度49)
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.width, self.height)];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];

        UIImage *image = [UIImage imageNamed:@"tabbarbg"];
        bgView.image = image;
        CGFloat barItemW = EPScreenW/4;
        NSArray * tabBarText = @[@"首页",@"找积分",@"花积分",@"我的"];
        //计算两个相邻的barItem之间的间距
        for (int i = 0; i < 4; i++) {
            //计算每一个barItem的位置
            CGFloat barItemX = i* barItemW;
            CGFloat barItemY = 0;
            
            self.barItem = [UIButton buttonWithType:UIButtonTypeCustom];
            [bgView addSubview:self.barItem];
            
            self.barItem.frame = CGRectMake(barItemX, barItemY, barItemW, bgView.height);
            NSString *imageName = [NSString stringWithFormat:@"%d",i];
            [self.barItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            NSString *selectedImageName = [NSString stringWithFormat:@"%@",tabBarText[i]];
            [self.barItem setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
            self.barItem.tag = i +100;
            [self.barItem setExclusiveTouch:YES];
            [self.btnArr addObject:self.barItem];
            if (self.barItem.tag == 100)
            {
                self.barItem.selected = YES;
            }
        }
 
    }
    return self;
}

@end
