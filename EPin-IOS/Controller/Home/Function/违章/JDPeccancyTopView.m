//
//  JDPeccancyTopView.m
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDPeccancyTopView.h"

#import "HeaderFile.h"


@interface JDPeccancyTopView ()

@property (nonatomic, weak) UIView *line;

@end

@implementation JDPeccancyTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpChildViews];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setUpChildViews
{
    // line
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    _line = line;
    line.backgroundColor = RGBColor(35, 38, 47);
}


#pragma mark - property
-(void)setNameArr:(NSArray *)nameArr
{
    _nameArr = nameArr;
    NSInteger count = nameArr.count;
    
    _line.frame = CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width/count, 2);
    
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.tag = i;
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(178, 178, 178) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        CGFloat w = self.bounds.size.width/count, h = 60, x = i*w, y = 0;
        [btn setFrame:CGRectMake(x, y, w, h)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

-(void)selectBtnIndex:(NSInteger)index
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)view;
            if (btn.tag == index) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:RGBColor(178, 178, 178) forState:UIControlStateNormal];
            }
            
        }
    }
    
    _line.x = index*self.bounds.size.width/_nameArr.count;
}

-(void)clickBtn:(UIButton *)sender
{
    
    [self selectBtnIndex:sender.tag];
    
    if (_btnClick) {
        _btnClick(sender.tag);
    }
}

-(void)peccancyBtnClick:(JDPeccancyBtnClick)btnClick
{
    _btnClick = btnClick;
}

@end
