//
//  AppDelegate.m
//  EPin-IOS
//
//  Created by jeader on 16/3/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "AppDelegate.h"
#import "EPTabbarViewController.h"
#import "EPTabBar.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "EPLoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "HeaderFile.h"
#import "JCAlertView.h"
#import "EPCallCarVC.h"
#import "EPFaresController.h"
#import "JDPushData.h"
#import "JDPushDataTool.h"
#import "EPFaresController.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
#import "HeaderFile.h"
//腾讯
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
#import "PlayerView.h"
//微信SDK头文件
#import "WXApi.h"
#import "EPGuideViewController.h"
//银联支付
#import "UPPaymentControl.h"
//注册APNs服务器的时候需要的参数
NSString *const NotificationCategoryIdent = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"FIRST_ACTIOIN";
NSString *const NotificationActionTwoIdent = @"SECOND_ACTION";

@interface AppDelegate ()<WXApiDelegate>
{
    PlayerView * avView;
    JCAlertView *_alert;
    NSDictionary * selfDic;
}

@property (nonatomic, strong)EPTabbarViewController * jtabbar;
@property (nonatomic, strong)EPTabBar * tab;
@property (nonatomic, strong)NSMutableArray *pushArr;
@property(nonatomic,strong)NSMutableArray * carArr;

@end

@implementation AppDelegate

//懒加载
-(NSMutableArray *)pushArr
{
    if (!_pushArr) {
        _pushArr = [NSMutableArray array];
    }
    return _pushArr;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goMain) name:@"goMain" object:nil];
        [self autoGoLogin];
        [self getData];
        [self getVIPInfo];
    //设置分享appkey
    [UMSocialData setAppKey:@"57304cac67e58e334800271f"];
    [UMSocialWechatHandler setWXAppId:@"wx9ead5d0591d84b3a" appSecret:@"5084a39b0dfe842d9ff9660e8e4bb47f" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1105268993" appKey:@"UJt3iIXPVhGBwmTY" url:@"http://www.umeng.com/social"];
    //启动SDK
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //注册微信支付
    [WXApi registerApp:@"wx9ead5d0591d84b3a" withDescription:@"demo 2.0"];

    // 注册APNS
    [self registerUserNotification];
    
    //处理远程通知启动APP
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    /**
     *  开机动画
     */
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
//    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:&setCateGoryErr];
//    [[AVAudioSession sharedInstance]setActive:YES error:&activetionErr];
   
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [AMapServices sharedServices].apiKey=@"b51b5fd9d036937e81228191ae70f91c";//d1c3e442d5bf9e9905fcd5002edaf827  b51b5fd9d036937e81228191ae70f91c
    NSString * path =[[NSBundle mainBundle]pathForResource:@"yipin" ofType:@"mp4"];
    avView =[[PlayerView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, EPScreenH) url:path];
    [self.window addSubview:avView];
    [avView play];
    [self performSelector:@selector(delayChange) withObject:nil afterDelay:0];//时间为0时不显示开机动画
    return YES;
}
- (void)getData{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getPersonalInfo.json",EPUrl];
    NSDictionary * inDict=[[NSDictionary alloc]initWithObjectsAndKeys:PHONENO,@"phoneNo",LOGINTIME,@"loginTime", nil];
    [manager GET:url parameters:inDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode=[responseObject[@"returnCode"] stringValue];
        if ([returnCode isEqualToString:@"0"]) {
            FileHander *hander = [FileHander shardFileHand];
            NSString *sss=@"ss";
            [hander saveFile:responseObject withForName:@"myData" withError:&sss];
            }
        }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",error);
         }];
}
- (void)autoGoLogin{
    NSString * str =[NSString stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"type",PHONENO,@"phoneNo",@"1",@"app",@"0",@"manual",CLIENTID,@"clientId",LOGINTIME,@"loginTime", nil];
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager GET:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger  returnCode=[responseObject[@"returnCode"] integerValue];
        if (returnCode==0)
        {
            NSString * totol=[responseObject[@"remainIntegral"] stringValue];
            NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
            [userDef setValue:totol forKey:@"totalScore"];
            [userDef synchronize];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)getVIPInfo{
    //获取会员信息
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getVipInfo.json",EPUrl];
    NSDictionary * inDict=[[NSDictionary alloc]initWithObjectsAndKeys:PHONENO,@"phoneNo",LOGINTIME,@"loginTime", nil];
    [manager GET:url parameters:inDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode=[responseObject[@"returnCode"] stringValue];
        if ([returnCode intValue]==0) {
            FileHander *hander = [FileHander shardFileHand];
            NSString *sss=@"ss";
            [hander saveFile:responseObject withForName:@"vipData" withError:&sss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        BOOL wxResult=[WXApi handleOpenURL:url delegate:self];
        if (wxResult == YES) {
            return wxResult;
        }else {
            [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
                if ([code isEqualToString:@"success"]) {
                    NSLog(@"银联支付成功");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"uppaySuccess" object:nil];
                }else if ([code isEqualToString:@"fail"]){
                    NSLog(@"银联支付失败");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"uppayFail" object:nil];
                }else if ([code isEqualToString:@"cancel"]){
                    NSLog(@"银联支付取消");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"uppayCancle" object:nil];
                }
            }];
            return YES;
        }
    }
    return result;
}

//微信支付结果处理
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp*response=(PayResp*)resp;
        NSLog(@"errCode==%d",response.errCode);
        switch (response.errCode)
        {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"微信支付成功");
               // [[NSNotificationCenter defaultCenter]postNotificationName:@"payCompleteNotice" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatFinishPay" object:nil];
            }
                break;
                
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if (resp.errCode==-1) {
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatFailPay" object:nil];
                }if (resp.errCode==-2) {
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatCanclePay" object:nil];
                }
                break;
        }
    }
}
- (void)delayChange
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //根据版本号来区分是否要显示引导图
    BOOL show = [ud boolForKey:[NSString stringWithFormat:@"Guide_%@", version]];
    if (show) {
    self.jtabbar= [[EPTabbarViewController alloc]init];
    UINavigationController * tabbarNav =[[UINavigationController alloc] initWithRootViewController:self.jtabbar];
    tabbarNav.navigationBarHidden = YES;
    
    tabbarNav.navigationBar.barTintColor=[UIColor colorWithRed:29/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
    self.window.rootViewController=tabbarNav;
    [ud setBool:YES forKey:[NSString stringWithFormat:@"Guide_%@", version]];
    [ud synchronize];
    }else{
        EPGuideViewController *guide = [[EPGuideViewController alloc]init];
        self.window.rootViewController=guide;
    }

}

-(void)goMain{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.jtabbar= [[EPTabbarViewController alloc]init];
    UINavigationController * tabbarNav =[[UINavigationController alloc] initWithRootViewController:self.jtabbar];
    tabbarNav.navigationBarHidden = YES;
    
    tabbarNav.navigationBar.barTintColor=[UIColor colorWithRed:29/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
    self.window.rootViewController=tabbarNav;
    [ud setBool:YES forKey:[NSString stringWithFormat:@"Guide_%@", version]];
    [ud synchronize];

}

//3D Touch 处理的动作
//- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
//{
//    if ([shortcutItem.localizedTitle isEqualToString:@"找积分"])
//    {
//        self.tab.barItem.tag=101;
//        self.jtabbar.selectedIndex=1;
//    }
//    else if ([shortcutItem.localizedTitle isEqualToString:@"花积分"])
//    {
//        self.tab.barItem.tag=102;
//        self.jtabbar.selectedIndex=2;
//    }
//}

- (void)registerUserNotification
{
    //如果是ios8.0 and later
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 8.0)
    {
        //IOS8 新的通知机制category注册
        //执行的动作一
        UIMutableUserNotificationAction *action1 ;
        action1 =[[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeForeground];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setTitle:@"取消"];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        //执行的动作二
        UIMutableUserNotificationAction * action2 ;
        action2 =[[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setTitle:@"接收"];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        //设置categorys
        UIMutableUserNotificationCategory * actionCategorys =[[UIMutableUserNotificationCategory alloc] init];
        [actionCategorys setIdentifier:NotificationCategoryIdent];
        [actionCategorys setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
        //将类型 装在集合里面
        NSSet * categories =[NSSet setWithObject:actionCategorys];
        UIUserNotificationType types =(UIUserNotificationTypeAlert |
                                       UIUserNotificationTypeSound |
                                       UIUserNotificationTypeBadge);
        //设置 set属性
        UIUserNotificationSettings * settings =[UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType apn_type =(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:apn_type];
    }
    
}

//如果APNs注册成功了就会返回一个 ============>>DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSString * myToken =[[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken =[myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@" the token is %@",myToken);
    [GeTuiSdk registerDeviceToken:myToken]; //向个推服务器注册deviceToken
}

//如果APNS 注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [GeTuiSdk registerDeviceToken:@""];
}

//个推启动成功返回clientID
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    if (clientId.length>0)
    {
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setValue:clientId forKey:@"clientID"];
        [us synchronize];
    }
    else
    {
        NSLog(@"没有获取到clientID");
    }
    
}
//个推遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
        NSLog(@"个推遇到错误 :%@",[error localizedDescription]);
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId
{
    
    NSData * payload =[GeTuiSdk retrivePayloadById:payloadId];
    NSString * payloadMsg =nil;
    if (payload)
    {
        payloadMsg=[[NSString alloc]initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    //data类型转为JSON数据
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:payload options:0 error:nil];
    NSDictionary *dict = (NSDictionary *)json;
    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *pushDict = [NSMutableDictionary dictionary];
    pushDict[@"title"] = dict[@"title"];
    pushDict[@"content"] = dict[@"content"];
    pushDict[@"currentTime"] = currentTime;
    pushDict[@"flag"] = @"0";
    pushDict[@"methodName"] = dict[@"methodName"];
    NSString *methodName = [NSString stringWithFormat:@"%@",dict[@"methodName"]];
    JDPushDataTool *tool = [[JDPushDataTool alloc] init];
    [tool createTable];
    //积分
    if ([methodName isEqualToString:@"use_yipin"])
    {
        [tool insertValuesForKeysWithDictionary:pushDict];
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:@"1" forKey:@"isUse"];
        [us synchronize];
    }
    //订单
    if ([methodName isEqualToString:@"use_order"])
    {
        [tool insertValuesForKeysWithDictionary:pushDict];
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:@"1" forKey:@"isshopRest"];
        [us synchronize];
    }
    //招车 相关推送
    if ([methodName isEqualToString:@"use_callCar"])
    {
        [tool insertValuesForKeysWithDictionary:pushDict];
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:@"1" forKey:@"isCar"];
        [us synchronize];
        
        NSString * noticeStr =dict[@"content"];
        if ([noticeStr isEqualToString:@"您的现在召车已被接单!"])//---------------------现在召车接单
        {
            NSDictionary * userInfo =[NSDictionary dictionaryWithObjectsAndKeys:noticeStr,@"content", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"callCarNotice" object:nil userInfo:userInfo];
            [self requestDriverInfoWithType:0];
        }
        else if ([noticeStr isEqualToString:@"您的预约用车已被接单!"])//----------------预约用车接单
        {
            NSDictionary * userInfo =[NSDictionary dictionaryWithObjectsAndKeys:noticeStr,@"content", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderCarNotice" object:nil userInfo:userInfo];
            [self requestDriverInfoWithType:1];
        }
        else if ([noticeStr isEqualToString:@"您的现在召车已上车!"])//------------------现在召车上车
        {
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setObject:@"1" forKey:@"isgetOn"];
            [us synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"upCarNotice" object:nil userInfo:nil];
        }
        else if ([noticeStr isEqualToString:@"您的预约用车已上车!"])//------------------预约用车上车
        {
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setObject:@"1" forKey:@"isgetOn"];
            [us synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"upCarOrderNotice" object:nil userInfo:nil];
        }
        else if ([noticeStr isEqualToString:@"您的现在召车已完成!"])//------------------现在召车---现金
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"finishCallCar" object:nil userInfo:nil];
        }
        else if ([noticeStr isEqualToString:@"您的预约用车已完成!"])//------------------预约用车---现金
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"finishOrderCallCar" object:nil userInfo:nil];
        }
        else if ([noticeStr isEqualToString:@"您有一条订单已支付完成!"])//---------------现金支付完成
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"upCarNotice" object:nil userInfo:nil];
        }
        else if ([noticeStr isEqualToString:@"您有一条预约订单无人应答!"])//-------------无人应答
        {
            UIViewController *rootVc=[UIApplication sharedApplication].keyWindow.rootViewController;
            [EPTool addAlertViewInView:rootVc title:@"温馨提示" message:@"很抱歉,您的预约召车暂无人接单,请尝试现在召车或其他他召车方式" count:0 doWhat:nil];
        }
        else
        {
            NSLog(@"什么东西也没有");
        }
    }
    
    if ([methodName isEqualToString:@"requestPay"])//------->在线支付推送
    {
        UIViewController *rootVc=   [UIApplication sharedApplication].keyWindow.rootViewController;
        EPFaresController * vc =[[EPFaresController alloc] init];
        vc.orderId=dict[@"imgSrc"];
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:vc.orderId forKey:@"ooooorderId"];
        [us synchronize];
        [rootVc presentViewController:vc animated:YES completion:nil];
    }
    
    if ([[NSString stringWithFormat:@"%@",dict[@"content"]] isEqualToString:@"已在别处登录，请注意是否为本人登录！"])
    {
        [EPLoginViewController publicDeleteInfo];
        UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
        
            EPLoginViewController *loginVc = [[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:rootVc title:@"温馨提示" message:@"已在别处登录，请注意是否为本人登录！" count:0 doWhat:^{
                [rootVc presentViewController:loginVc animated:YES completion:^{
                }];
            }];
       
    }
    
    NSString * msg =[NSString stringWithFormat:@"payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@",payloadId,taskId,aMsgId,payloadMsg,offLine ? @"<离线消息>":@""];
    NSLog(@"个推收到的payload是%@",msg);
    
}
- (void)requestDriverInfoWithType:(NSInteger)type
{
    EPData * data=[EPData new];
    UIViewController *rootVc=[UIApplication sharedApplication].keyWindow.rootViewController;
    [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"" WhatToDo:@"0" withOrderNumber:@"" withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0)
        {
            NSArray * arr =dic[@"getCallCarArr"];
            for (NSDictionary * smallDic in arr)
            {
                NSString * orderType =smallDic[@"useType"];
                if ([orderType intValue]==type)
                {
                    selfDic=smallDic;
                    [self seeDriverInfo];
                }
            }
        }
        else if ([returnCode intValue]==1)
        {
            [EPTool addAlertViewInView:rootVc title:@"提示" message:msg count:0 doWhat:nil];
        }
        else if ([returnCode intValue]==2)
        {
            EPLoginViewController *loginVc = [[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:rootVc title:@"温馨提示" message:@"已在别处登录，请注意是否为本人登录！" count:0 doWhat:^{
                [rootVc presentViewController:loginVc animated:YES completion:^{
                }];
            }];
        }
        else
        {
            [EPTool addAlertViewInView:rootVc title:@"提示" message:@"网络链接似乎有点问题" count:0 doWhat:nil];
        }
        
    }];
}
//跳出查看司机详情的弹窗
- (void)seeDriverInfo
{
    //设置一个弹窗的自定义view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 225)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.masksToBounds=YES;
    customView.layer.cornerRadius=5;
    //设置标题
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    titleLab.backgroundColor=RGBColor(29, 32, 40);
    titleLab.text=@"司机详情";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=RGBColor(218, 187, 132);
    [customView addSubview:titleLab];
    
    UILabel * upTime =[[UILabel alloc] initWithFrame:CGRectMake(10, 55, 270, 25)];
    upTime.text=[NSString stringWithFormat:@"车牌号码:   %@",selfDic[@"licenseNo"]];
    upTime.font=[UIFont systemFontOfSize:16];
    upTime.textColor=[UIColor blackColor];
    [customView addSubview:upTime];
    
    UILabel * local =[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 270, 25)];
    local.text=[NSString stringWithFormat:@"联系方式:   %@",selfDic[@"driverPhoneNo"]];
    local.font=[UIFont systemFontOfSize:16];
    local.numberOfLines=0;
    local.textColor=[UIColor blackColor];
    [customView addSubview:local];
    
    UILabel * destination =[[UILabel alloc] initWithFrame:CGRectMake(10, 135, 270, 25)];
    destination.text=[NSString stringWithFormat:@"所属公司:   %@",selfDic[@"companyName"]];
    destination.font=[UIFont systemFontOfSize:16];
    destination.numberOfLines=0;
    destination.textColor=[UIColor blackColor];
    [customView addSubview:destination];
    //设置按钮上边的分割线
    UIView * lineView2 =[[UIView alloc]initWithFrame:CGRectMake(0, 174, 300, 1)];
    lineView2.backgroundColor=RGBColor(217, 217, 217);
    [customView addSubview:lineView2];
    //设置最下边的按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 175, 300, 50)];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn setTitleColor:RGBColor(234, 0, 0) forState:UIControlStateNormal];
    [customView addSubview:btn];
    [btn addTarget:self action:@selector(knownIts) forControlEvents:UIControlEventTouchUpInside];
    
    _alert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [_alert show];
}
//点击知道了按钮消失弹窗
- (void)knownIts
{
    [_alert dismissWithCompletion:nil];
}
/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions
{
    if (!launchOptions)
    {
        return;
    }
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        NSLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
    }
}

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"输出输出cccccc");
    NSString *record = [NSString stringWithFormat:@"字典模式ssssss[APN]%@, %@", [NSDate date], userInfo];
    NSLog(@"字典模式模式模式%@",record);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"%@...%@....",userInfo[@"aps"][@"alert"],userInfo);
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //background fetch 恢复SDK运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

//远程通知
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    NSLog(@"远程推送成功之后返回的结果有%@,,,,%@,,,,",identifier,userInfo);
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"pay"])
    {
        NSString * str=[url.query substringFromIndex:url.query.length-1];
        //微信支付 处理回调结果
        if ([str isEqualToString:@"0"])
        {
            NSLog(@"微信支付成功");
           // [[NSNotificationCenter defaultCenter]postNotificationName:@"payCompleteNotice" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatFinishPay" object:nil];
        }
        else if ([str isEqualToString:@"1"])
        {
             NSLog(@"支付失败");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatFailPay" object:nil];
        }
        else if ([str isEqualToString:@"2"])
        {
             NSLog(@"取消支付");
             [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatCanclePay" object:nil];
        }
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString * str = resultDic[@"resultStatus"];
            if ([str intValue]==9000)
            {
                NSLog(@"支付宝交易成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatFinishPay" object:nil];
            }
            else if ([str intValue]==6001)
            {
                NSLog(@"用户主动取消支付");
            }
            else
            {
                NSLog(@"支付失败");
            }
        }];
    }
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if ([code isEqualToString:@"success"]) {
            NSLog(@"银联支付成功");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uppaySuccess" object:nil];
        }else if ([code isEqualToString:@"fail"]){
            NSLog(@"银联支付失败");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uppayFail" object:nil];
        }else if ([code isEqualToString:@"cancel"]){
            NSLog(@"银联支付取消");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uppayCancle" object:nil];
        }
    }];
    return YES;
}
- (void)verify:(NSString *)sign{
     EPData * data=[EPData new];
     [data verify:sign WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
         NSLog(@"验证签名----%@",dic);
     }];
}
//让项目禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication * app =[UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask=[app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       dispatch_async(dispatch_get_main_queue(), ^{
           if (bgTask != UIBackgroundTaskInvalid)
           {
               bgTask = UIBackgroundTaskInvalid;
           }
       });
    });
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EPin_IOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EPin_IOS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
