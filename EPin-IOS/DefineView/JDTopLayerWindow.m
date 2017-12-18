//
//  JDTopLayerWindow.m
//  eTaxi-iOS
//
//  Created by jeader on 16/2/21.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDTopLayerWindow.h"
#import "HeaderFile.h"


#define ShareVH 110

@interface JDTopLayerWindow ()

/**
 *  分享视图上面的蒙层
 */
@property (nonatomic, strong) UIView *mengc;

/**
 *  分享视图
 */
@property (nonatomic, strong) UIView *shareView;
/**
 *  短信按钮
 */
@property (nonatomic, strong) UIButton *duanxin;

/**
 *  微信按钮
 */
@property (nonatomic, strong) UIButton *weixin;

/**
 *  QQ按钮
 */
@property (nonatomic, strong) UIButton *QQ;

@end

@implementation JDTopLayerWindow

+ (JDTopLayerWindow *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
    });
    
    return sharedInstance;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        /**
         *  分享视图上方的蒙层
         */
        UIButton *mengc = [UIButton buttonWithType:UIButtonTypeCustom];
        _mengc = mengc;
        [mengc setFrame:[UIScreen mainScreen].bounds];
        [mengc setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [mengc addTarget:self action:@selector(clickMengc) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mengc];
        
        /**
         *  分享视图
         */
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, EPScreenH, EPScreenW, ShareVH)];
        shareView.backgroundColor = [UIColor whiteColor];
        _shareView = shareView;
        [mengc addSubview:shareView];
        
        /**
         *  添加三个分享按钮
         */
        UIButton *dunaxin = [self getShareImageWithIndex:0 title:@"短信" imageName:@"xinxi-0"];
        _duanxin = dunaxin;
         [dunaxin addTarget:self action:@selector(clickDuanxin) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *weixin = [self getShareImageWithIndex:1 title:@"微信好友" imageName:@"weixin-0"];
        weixin.hidden = NO;
        _weixin = weixin;
         [weixin addTarget:self action:@selector(clickWeixin) forControlEvents:UIControlEventTouchUpInside];
        /**
         *  检测手机是否安装了微信
         */
//        if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]){
//            
////            NSLog(@"安装了微信");
//            weixin.hidden = NO;
//            
//        }
        
        UIButton *QQ = [self getShareImageWithIndex:2 title:@"QQ好友" imageName:@"qq2"];
        QQ.hidden = NO;
        _QQ = QQ;
        [QQ addTarget:self action:@selector(clickQQ) forControlEvents:UIControlEventTouchUpInside];
        /**
         *  检测手机是否安装了QQ
         */
//        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
//            
////            NSLog(@"安装了QQ");
//            QQ.hidden = NO;
//            
//        }
        
        [shareView addSubview:dunaxin];
        [shareView addSubview:weixin];
        [shareView addSubview:QQ];
        }
    return self;
}
-(void)clickDuanxin
{
    if (_sms) {
        _sms();
    }
}

-(void)clickWeixin
{
    if (_wechat) {
        _wechat();
    }
}

-(void)clickQQ
{
    if (_qq) {
        _qq();
    }
}

-(void)shareDuanxin:(Sms)sms Wechat:(Wechat)wechat QQ:(QQ)qq
{
    if (sms) {
        
        _sms = sms;
    }
    if (wechat) {
        
        _wechat = wechat;
    }
    if (qq) {
        
        _qq = qq;
    }
    
}

- (UIButton *)getShareImageWithIndex:(int)index title:(NSString *)title imageName:(NSString *)image
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    [view setFrame:CGRectMake(index * EPScreenW/3, 0, EPScreenW/3, ShareVH)];
    view.backgroundColor = [UIColor whiteColor];
    
    /**
     *  添加的图片的大小
     */
    CGSize imageS = [[UIImage imageNamed:image] size];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageS.width, imageS.height)];
    imageV.userInteractionEnabled = NO;
    imageV.image = [UIImage imageNamed:image];
    imageV.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2 - 10);
    [view addSubview:imageV];
    
    /**
     *  添加图片下面的文字
     */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 5, view.bounds.size.width, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

/**
 *  点击蒙层的时候调用
 */
-(void)clickMengc
{
    [self hidden];
    
//    NSLog(@"clickMengc");
}

-(void)show
{
    [self makeKeyAndVisible];
    self.hidden = NO;
    
    [self addSubview:self.shareView];
    [UIView animateWithDuration:0.3 animations:^{
       
        self.shareView.transform = CGAffineTransformMakeTranslation(0, -ShareVH);
        
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.shareView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    [self resignKeyWindow];
    self.hidden = YES;
    
}

@end
