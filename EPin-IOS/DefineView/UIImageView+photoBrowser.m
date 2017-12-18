//
//  UIImageView+photoBrowser.m
//  eTaxi-iOS
//
//  Created by jeader on 16/3/9.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "UIImageView+photoBrowser.h"
#import "HeaderFile.h"

static UIView *_view;
static UIView *_backView;
static UIImageView *_imageView;
static CGRect _rect;

@implementation UIImageView (photoBrowser)

/**
 *  显示大图片
 */
-(void)showBiggerPhotoInview:(UIView *)view
{
    
    _view = view;
    
    self.userInteractionEnabled = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:self.bounds];
    [btn addTarget:self action:@selector(clickImageV) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

-(void)clickImageV
{
    
    [_view endEditing:YES];
    
    UIView *backView = [[UIView alloc] initWithFrame:_view.bounds];
    _backView = backView;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    [_view addSubview:backView];
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    UIWindow *keywindow = (UIWindow *)windows[0];
    
    NSLog(@"%@----%p",keywindow,keywindow);
    
    //将图片的坐标转换成window上的坐标
    CGRect rect = [self convertRect:self.bounds toView:keywindow];
    _rect = rect;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:rect];
    _imageView = imageV;
    imageV.image = self.image;
    
    [backView addSubview:imageV];
    
    CGFloat imageW = EPScreenW;
    CGFloat imageH = imageW+20;
    
//    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:0 animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];

    [UIView animateWithDuration:0.3 animations:^{
        imageV.x = 0;
        imageV.y = (EPScreenH-imageH)/2;
        imageV.width = imageW;
        imageV.height = imageH;
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:backView.bounds];
    [backView addSubview:btn];
    [btn addTarget:self action:@selector(clickView) forControlEvents:UIControlEventTouchUpInside];

}

-(void)clickView
{
    
//    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:0 animations:^{
//        _imageView.frame = _rect;
//    } completion:^(BOOL finished) {
//        [_backView removeFromSuperview];
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame = _rect;
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
    
}

@end
