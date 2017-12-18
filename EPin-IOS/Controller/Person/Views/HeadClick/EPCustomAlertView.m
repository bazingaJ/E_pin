//
//  EPCustomAlertView.m
//  EPin-IOS
//
//  Created by jeaderL on 16/3/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCustomAlertView.h"
#import "HeaderFile.h"

@implementation EPCustomAlertView

/** 单例 */
+ (EPCustomAlertView *)singleClass{
    static EPCustomAlertView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EPCustomAlertView alloc] init];
    });
    return manager;
}

/** 提示view */
- (UIView *)quickAlertViewWithArray:(NSArray *)array{
    CGFloat buttonH = 51;
    CGFloat buttonW = EPScreenW-112;
    
    // 通过数组长度创建view的高
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, 0,buttonW, array.count * buttonH)];
    for (int i = 0; i < array.count;i++) {
        // 因为有一条分割线 所以最下面是一层view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i*buttonH, buttonW, buttonH)];
        view.backgroundColor = [UIColor whiteColor];
        
        // 创建button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, buttonW, buttonH);
        [button setTitle:array[i] forState:(UIControlStateNormal)];
        // 所有button都关联一个点击方法,通过按钮上的title做区分
        [button addTarget:self action:@selector(alertAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:button];
        
        // 这里可以根据传值改变状态
        if ([array[i] isEqualToString:@"更换头像"]) {
            button.tintColor = [UIColor blackColor];
            button.titleLabel.font=[UIFont systemFontOfSize:16];
            view.backgroundColor = RGBColor(211, 211, 211);
        }else{
            button.tintColor = [UIColor whiteColor];
            button.titleLabel.font=[UIFont systemFontOfSize:16];
            [button setTitleColor:RGBColor(27, 145, 255) forState:UIControlStateNormal];
            view.backgroundColor=[UIColor whiteColor];
            // 分割线
            // 如果不是最后一行
            if ([array[i] isEqualToString:@"拍照"]){
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,50, buttonW, 1)];
                lineView.backgroundColor = RGBColor(144, 145, 146);
                
                [view addSubview:lineView];
            }
            
        }
        [alert addSubview:view];
    }
    return alert;
}
/** button点击事件,通知代理执行代理方法 */
- (void)alertAction:(UIButton *)button{
    [_delegate didSelectAlertButton:button.titleLabel.text];
}


@end
