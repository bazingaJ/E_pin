//
//  JDGoodsTools.m
//  eTaxi-iOS
//
//  Created by jeader on 16/4/27.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDGoodsTools.h"

#import "JDTopLayerWindow.h"

#import "UMSocial.h"

//分享的标题
#define ShareTitle @"易品"
//分享的文字
#define ShareContent @"大量优惠，各种免费商品，尽在“易品！"
//分享的图片
#define ShareImage [UIImage imageNamed:@"LOGO"]
//分享的url地址
#define ShareURL @"http://itunes.apple.com/cn/app/id1109292972?mt=8"
//短信分享的内容
#define Share   [NSString stringWithFormat:@"好玩、好吃、好喝全都在这里，新鲜、猎奇、最in统统拿下。点击%@即刻，下载易品APP和新生活say hi吧!",ShareURL]

@implementation JDGoodsTools

+(void)shareUMInVc:(UIViewController *)VC
{
    [[JDTopLayerWindow sharedInstance] show];
    
    [[JDTopLayerWindow sharedInstance]shareDuanxin:^{
        
        [[JDTopLayerWindow sharedInstance] hidden];
        
        if( [MFMessageComposeViewController canSendText] ){
            
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
            
            controller.recipients = [NSArray arrayWithObject:@" "];
            controller.body = Share;
            controller.messageComposeDelegate = VC;
            
            [VC presentViewController:controller animated:YES completion:nil];

            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
        }else{
            
            [EPTool addAlertViewInView:VC title:@"温馨提示" message:@"设备没有短信功能" count:0 doWhat:nil];
        }
        
    } Wechat:^{
        
        [[JDTopLayerWindow sharedInstance] hidden];
        
        [UMSocialData defaultData].extConfig.title = ShareTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = ShareURL;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:ShareContent image:ShareImage location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //            NSLog(@"分享成功！");
            }
        }];
        
     } QQ:^{
        
        [[JDTopLayerWindow sharedInstance] hidden];
        
        [UMSocialData defaultData].extConfig.title = ShareTitle;
        [UMSocialData defaultData].extConfig.qqData.url = ShareURL;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:ShareContent image:ShareImage location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //            NSLog(@"分享成功！");
            }
        }];
        
        
    }];
}

@end
