//
//  EPTool.m
//  EPin-IOS
//
//  Created by jeader on 16/4/6.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPTool.h"
#import "MBProgressHUD.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
static MBProgressHUD *_mbV;


NSString * const kAlertTitle = @"温馨提示";
NSString * const kAlertMessage = @"您的账号在其他地方登陆,您将退出登陆";
NSString * const kNetWorkProblem = @"网络链接似乎有点问题";

@implementation EPTool

+ (void)addAlertViewInView:(UIViewController *)VC title:(NSString *)title message:(NSString *)message count:(int)index doWhat:(void (^)(void))what
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [[UIAlertAction alloc] init];
    
    UIAlertAction *action1 = [[UIAlertAction alloc] init];
    
    if(index == 0)
    {
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            if (what)
            {
                what();
            }
            
        }];
        action1 = nil;
    }
    else
    {
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            what();
        }];
        action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    }
    if (action1)
    {
        [alert addAction:action1];
    }
    [alert addAction:action];
    [VC presentViewController:alert animated:YES completion:nil];
    
}
//手机号验证合法性
+ (BOOL)validatePhone:(NSString *) textString
{
    NSString* phone=@"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phone];
    return [numberPre evaluateWithObject:textString];
}

+ (BOOL)validatePassword:(NSString *) textString
{
    NSString* password=@"^[0-9]{6}$";//^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",password];
    return [numberPre evaluateWithObject:textString];
}
//输入汉字的正则表达式
+(BOOL)validateChinese:(NSString *) textString
{
    NSString* chinese=@"^[0-9A-Za-z\u4e00-\u9fa5]+$";//^[a-zA-Z\u4e00-\u9fa5]+$     ^[\u4e00-\u9fa5]{0,}$
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chinese];
    return [numberPre evaluateWithObject:textString];
}
- (UIAlertController *)showAlertControllerWithTitle:(NSString *)title WithMessages:(NSString *)msg WithCancelTitle:(NSString *)cancelTitle
{
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    return alert;
}
/**
 *  添加MBProgress
 *
 *  @param view 添加到哪个视图上
 *  @param index MB展现的方式，0代表添加刷新视图，1代表不添加刷新只显示文字
 */
+(void)addMBProgressWithView:(UIView *)view style:(int)index
{
    _mbV = [[MBProgressHUD alloc] initWithView:view];
    
    if (index == 0) {
        
        _mbV.mode = MBProgressHUDModeIndeterminate;
        
    }else{
        
        _mbV.mode = MBProgressHUDModeCustomView;
        
    }
    /**
     *  自定义view
     */
    //    _mbV.customView
    
    _mbV.color = [UIColor blackColor];
    [view addSubview:_mbV];
    
    _mbV.activityIndicatorColor = [UIColor whiteColor];
    
}

+(void)showMBWithTitle:(NSString *)title
{
    _mbV.labelText = title;
    _mbV.labelFont = [UIFont systemFontOfSize:12];
    _mbV.labelColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [_mbV show:YES];
}

+(void)hiddenMBWithDelayTimeInterval:(int)interval
{
    [_mbV hide:YES afterDelay:interval];
}

+(void)checkNetWorkWithCompltion:(void(^)(NSInteger statusCode))block
{
    NSInteger __block code = 0;
    AFNetworkReachabilityManager * manager =[AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            code = 0;
        }
        else
        {
            code = 1;
        }
        block(code);
    }];
    
}
+ (BOOL)isLogin
{
    //判断有没有token值
    NSString * phoneNo = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    NSString * password =[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    
    if (phoneNo==nil||password==nil)
    {
        return NO;
    }
    
    return YES;
}
//获取IP地址
+ (NSString  *)getIpAddresses{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
+ (NSString *)getDate{
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return date2;
}
+ (void)getPublicKey{
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * url=[NSString  stringWithFormat:@"%@/getPublicKey.json",EPUrl];
   [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * str =[responseObject objectForKey:@"publicKey"];
        //NSLog(@"公钥==%@",str);
        NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
        [userDef setValue:str forKey:@"publicKey"];
        [userDef synchronize];
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
   }];
}

/**
 *  根据returnCode处理服务器的返回结果值
 *
 *  @param viewCon      使用方法的视图控制器
 *  @param code         returncode的返回值
 *  @param action       returncode为0时做出的事件
 *  @param errorMessage returnCode为1时做出的事件
 */
+ (void)handleWithDataReturnedByTheServerInViewController:(UIViewController *)viewCon  WithInReturnCode:(NSInteger)code WithErrorMessage:(NSString *)msg WithReturnCodeEqualToZeroBlock:(void(^)(void))action WithReturnCodeEqualToOneBlock:(void(^)(void))errorMessage
{
    [EPTool hiddenMBWithDelayTimeInterval:0];
    if (code==0)
    {
        action();
    }
    else if (code==1)
    {
        [EPTool addAlertViewInView:viewCon title:kAlertTitle message:msg count:0 doWhat:^{
            
        }];
    }
    else if (code==2)
    {
        [EPTool addAlertViewInView:viewCon title:kAlertTitle message:kAlertMessage count:0 doWhat:^{
            [EPLoginViewController publicDeleteInfo];
            EPLoginViewController * vc =[[EPLoginViewController alloc] init];
            [viewCon presentViewController:vc animated:YES completion:nil];
        }];
    }
    else
    {
        [EPTool addMBProgressWithView:viewCon.view style:1];
        [EPTool showMBWithTitle:kNetWorkProblem];
        [EPTool hiddenMBWithDelayTimeInterval:2];
    }
}






@end
