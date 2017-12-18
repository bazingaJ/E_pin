//
//  EPVIsitVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/11/18.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPVIsitVC.h"
#import "HeaderFile.h"
#import "UMSocial.h"
//分享的标题
#define ShareT @"易品"
//分享的文字
#define ShareC @"大量优惠，各种免费商品，尽在“易品”！"
//分享的图片
#define ShareI [UIImage imageNamed:@"LOGO"]
//分享的url地址
#define ShareU @"http://itunes.apple.com/cn/app/id1109292972?mt=8"
//短信分享
#import <MessageUI/MessageUI.h>
#define shareBtnTag 900

@interface EPVIsitVC ()

@property(nonatomic,strong)UIImageView * backImg;

@end

@implementation EPVIsitVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar1:0 title:@"邀请好友"];
    [self creatUI];
}
- (void)creatUI{
    UIImageView * img=[[UIImageView alloc]init];
    img.frame=CGRectMake(0,64, EPScreenW, EPScreenH-64);
    img.userInteractionEnabled=YES;
    [self.view addSubview:img];
    img.image=[UIImage imageNamed:@"背景"];
    self.backImg=img;
    //易品
    UIImageView * yipin=[[UIImageView alloc]init];
    [img addSubview:yipin];
    yipin.y=HEIGHT(70.0, 667);
    CGSize yipinSize=[UIImage imageNamed:@"易品"].size;
    yipin.size=yipinSize;
    yipin.centerX=img.centerX;
    yipin.image=[UIImage imageNamed:@"易品"];
    UIImageView * img1=[[UIImageView alloc]init];
    [img addSubview:img1];
    CGSize img1Size=[UIImage imageNamed:@"邀请好友--来赚积分"].size;
    img1.size=img1Size;
    img1.y=CGRectGetMaxY(yipin.frame)+HEIGHT(50.0, 667);
    img1.centerX=img.centerX;
    img1.image=[UIImage imageNamed:@"邀请好友--来赚积分"];
    UIImageView * img2=[[UIImageView alloc]init];
    [img addSubview:img2];
    CGSize img2Size=[UIImage imageNamed:@"全城盛宴---一起狂欢"].size;
    img2.size=img2Size;
    img2.y= CGRectGetMaxY(img1.frame)+HEIGHT(15.0, 667);
    img2.centerX=img.centerX;
    img2.image=[UIImage imageNamed:@"全城盛宴---一起狂欢"];

    
    NSArray * norImgArr=@[@"信息新",@"QQ副本",@"微信新"];
    NSArray * selectimgArr=@[@"信息副本",@"QQ新",@"微信副本"];
    CGFloat maxY=CGRectGetMaxY(img2.frame)+HEIGHT(38.0, 667);
    CGSize ss=[UIImage imageNamed:@"信息新"].size;
    CGFloat leftX=(EPScreenW-ss.width)/2;
    for (int i=0; i<3; i++) {
        UIButton * btnShare=[UIButton buttonWithType:UIButtonTypeCustom];
        btnShare.frame=CGRectMake(leftX, maxY+i*(ss.height+HEIGHT(25.0, 667)),ss.width,ss.height);
        btnShare.tag=shareBtnTag+i;
        [btnShare setImage:[UIImage imageNamed:norImgArr[i]] forState:UIControlStateNormal];
        [btnShare setImage:[UIImage imageNamed:selectimgArr[i]] forState:UIControlStateSelected];
        [btnShare addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:btnShare];
    }
    CGFloat visitmaxY=maxY+ss.height*3+HEIGHT(25.0, 667)*3;
    UIImageView * visitLb=[[UIImageView alloc]init];
    [img addSubview:visitLb];
    UIImage * visitImg=[UIImage imageNamed:@"邀请码"];
    CGSize visitSize=visitImg.size;
    visitLb.size=visitSize;
    visitLb.x=leftX;
    visitLb.y=visitmaxY+8;
    visitLb.image=visitImg;
    UIImageView * lb=[[UIImageView alloc]init];
    [img addSubview:lb];
    UIImage * lbImg=[UIImage imageNamed:@"输入框"];
    lb.size=lbImg.size;
    lb.x=CGRectGetMaxX(visitLb.frame)+5;
    lb.y=visitmaxY;
    lb.image=lbImg;
    UILabel * lbVisit=[[UILabel alloc]init];
    [lb addSubview:lbVisit];
    lbVisit.size=lb.size;
    lbVisit.x=0;
    lbVisit.y=0;
    lbVisit.text=INVITECODE;
    lbVisit.font=[UIFont systemFontOfSize:13];
    lbVisit.textColor=RGBColor(255, 255, 255);
    lbVisit.textAlignment=NSTextAlignmentCenter;
    
    UIImageView * higo=[[UIImageView alloc]init];
    [img addSubview:higo];
    UIImage * higoImg=[UIImage imageNamed:@"点击图标"];
    CGSize higoSize=higoImg.size;
    higo.size=higoSize;
    higo.centerX=img.centerX;
    higo.y=CGRectGetMaxY(lb.frame)+HEIGHT(40.0, 667);
    higo.image=higoImg;
}
- (void)clickShare:(UIButton *)btn{
   // btn.selected=YES;
    NSInteger tag=btn.tag-shareBtnTag;
    if (tag==0) {
        //短信分享
        [self showMessageView];
    }else if (tag==1){
        //qq分享
        [UMSocialData defaultData].extConfig.title =ShareT;
        [UMSocialData defaultData].extConfig.qqData.url =ShareU;
        NSString * share=[NSString stringWithFormat:@"好玩、好吃、好喝全都在这里，新鲜、猎奇、最in统统拿下。邀请码：%@。点击%@即刻，下载易品APP和新生活say hi吧!",INVITECODE,ShareU];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:share image:ShareI location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }else{
        //微信分享
        [UMSocialData defaultData].extConfig.title =ShareT;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = ShareU;
        NSString * share=[NSString stringWithFormat:@"好玩、好吃、好喝全都在这里，新鲜、猎奇、最in统统拿下。邀请码：%@。点击%@即刻，下载易品APP和新生活say hi吧!",INVITECODE,ShareU];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:share image:ShareI location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
}
- (void)showMessageView
{
    NSString * share=[NSString stringWithFormat:@"好玩、好吃、好喝全都在这里，新鲜、猎奇、最in统统拿下。邀请码：%@。点击%@即刻，下载易品APP和新生活say hi吧!",INVITECODE,ShareU];
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = [NSArray arrayWithObject:@" "];
        controller.body = share;
        controller.messageComposeDelegate = self;

        [self presentViewController:controller animated:YES completion:nil];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
    }else{
        [EPTool addAlertViewInView:self title:@"提示信息" message:@"设备没有短信功能" count:0 doWhat:nil];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            [EPTool addAlertViewInView:self title:@"提示信息" message:@"发送取消" count:0 doWhat:nil];
            break;
        case MessageComposeResultFailed:// send failed
            [EPTool addAlertViewInView:self title:@"提示信息" message:@"发送失败" count:0 doWhat:nil];
            break;
        case MessageComposeResultSent:
            [EPTool addAlertViewInView:self title:@"提示信息" message:@"发送成功" count:0 doWhat:nil];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
