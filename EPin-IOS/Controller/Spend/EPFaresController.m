//
//  EPFaresController.m
//  EPin-IOS
//
//  Created by jeaderq on 16/6/12.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPFaresController.h"
#import "HeaderFile.h"
#import "EPLoginViewController.h"

//------支付宝------
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
//.m使用
#import "DataSigner.h"
//.mm使用
#import "RSADataSigner.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation Product

@end

@interface EPFaresController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *jifenF;
@property (weak, nonatomic) IBOutlet UITextField *priceL;
@property (weak, nonatomic) IBOutlet UILabel *diKouL;

@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weichartBtn;

@property (nonatomic, strong) NSString * signStr;
@end

@implementation EPFaresController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isScan)
    {
        [self addNavigationBar:0 title:@"车资支付"];
        
    }
    else
    {
        [self addNavigationBar:2 title:@"车资支付"];
        [self addLeftItemWithFrame:CGRectMake(10, 10, 40, 40) textOrImage:1 action:@selector(disappearView) name:@"取消"];
    }
    
    
    self.aliPayBtn.selected = YES;
    [self.jifenF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completePay) name:@"payCompleteNotice" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isScan)
    {
        NSString * orderStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"ooooorderId"];
        if (orderStr.length != 0)
        {
            self.orderId=orderStr;
        }
        if (self.orderId.length != 0 )
        {
            //先向服务器获取付款信息
            [self requestDataWithType:@"0" WithOrderId:self.orderId WithUseScore:@"" WithPayCode:@"" WtihDriverId:@"" WithWholeMoney:@"" WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                float  totleMoney = [dic[@"totalMoney"] floatValue];
                [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                    self.priceL.text=[NSString stringWithFormat:@"%.2f",totleMoney];
                    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                    [us setObject:self.priceL.text forKey:@"paySuccessMoney"];
                    [us synchronize];
                } WithReturnCodeEqualToOneBlock:nil];
            }];
        }
    }
    
}
//选择支付方式按钮
- (IBAction)chooseBtn:(UIButton *)sender
{
    self.aliPayBtn.selected = NO;
    self.weichartBtn.selected = NO;
    sender.selected = YES;
    
}
- (IBAction)Pay:(UIButton *)sender
{
    if (self.priceL.text.length==0)
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入金额" count:0 doWhat:nil];
    }
    else
    {
        [EPTool addMBProgressWithView:self.view style:0];
        if (_isScan)
        {
            [self requestDataWithType:@"4" WithOrderId:self.orderId WithUseScore:@"" WithPayCode:@"" WtihDriverId:self.driverId WithWholeMoney:self.priceL.text WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                    [self getSignAndGoAlipay];
                } WithReturnCodeEqualToOneBlock:nil];
            }];
        }
        else
        {
            //向服务器提交这次付款信息
            [self requestDataWithType:@"1" WithOrderId:self.orderId WithUseScore:@"" WithPayCode:@"" WtihDriverId:@"" WithWholeMoney:self.priceL.text WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                    [self getSignAndGoAlipay];
                } WithReturnCodeEqualToOneBlock:nil];
            }];
        }
    }
}
- (void)getSignAndGoAlipay
{
    if (self.aliPayBtn.selected)
    {
        [self requestDataWithType:@"3" WithOrderId:self.orderId WithUseScore:@"" WithPayCode:@"" WtihDriverId:@"" WithWholeMoney:self.priceL.text WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic)
         {
             [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                 NSString * signText =dic[@"sign"];
                 if (signText.length != 0)
                 {
                     self.signStr=signText;
                 }
                 //从这里去支付宝
                 [self PayTreasure];
             } WithReturnCodeEqualToOneBlock:nil];
         }];
    }
    if (self.weichartBtn.selected)
    {
        [self requestDataWithType:@"5" WithOrderId:self.orderId WithUseScore:@"" WithPayCode:@"" WtihDriverId:@"" WithWholeMoney:self.priceL.text WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic)
         {
             [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                 NSString * prepayid = dic[@"prepayid"];
                 if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]])
                 {
                     //从这里微信
                     [self jumpToBizPayWithPrepayID:prepayid];
                 }
                 else
                 {
                     [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的设备没有安装微信" count:0 doWhat:nil];
                 }
              
             } WithReturnCodeEqualToOneBlock:nil];
         }];
        
    }
    
}
- (void)requestDataWithType:(NSString *)type WithOrderId:(NSString *)order WithUseScore:(NSString *)point WithPayCode:(NSString *)code WtihDriverId:(NSString *)driver WithWholeMoney:(NSString *)money  WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))variousBlock
{
    EPData *data = [EPData new];
    [data requestSignWithType:type WithOrderId:order WithPoint:point WithPayCode:code WithWholeMoney:money WithDriverId:driver WithIPAddress:[self getIpAddresses] WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        variousBlock(returnCode,msg,dic);
    }];

}
- (void)disappearView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//注销键盘的第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
-(void)textFieldDidChange :(UITextField *)theTextField
{
    CGFloat jifen = [theTextField.text floatValue];
    self.priceL.text =[NSString stringWithFormat:@"%.2f 元",jifen/10];
}
- (void)completePay
{
    [self disappearView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissRequest" object:nil];
}
-(void)PayTreasure
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088221986373276";
    NSString *seller = @"developer@jeader.com";
       /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = self.orderId;        //订单ID（由商家自行制定）
    order.subject = @"车资支付";             //product.subject; //商品标题
    order.body = @"0";                      //product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",[self.priceL.text floatValue]];;      //商品价格
    order.notifyURL =[NSString stringWithFormat:@"%@/successAlipayPay.json",EPUrl];//回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"60m";
    order.returnURL = @"m.alipay.com";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    
    
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = self.signStr;//[signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
        {
            NSString *result =resultDic[@"resultStatus"];
            if ([result intValue]==9000)
            {
                NSLog(@"支付宝交易成功");
                [self completePay];
                
                
            }
            else if ([result intValue]==6001)
            {
                [self disappearView];
                
                [EPTool addMBProgressWithView:self.view style:1];
                [EPTool showMBWithTitle:@"支付未完成"];
                [EPTool hiddenMBWithDelayTimeInterval:1];
                NSLog(@"用户主动取消支付");
            }
            else
            {
                [EPTool addMBProgressWithView:self.view style:1];
                [EPTool showMBWithTitle:@"支付失败"];
                [EPTool hiddenMBWithDelayTimeInterval:1];
                NSLog(@"支付失败");
            }
        }];
    }
}
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    return retStr;
}


-(void)jumpToBizPayWithPrepayID:(NSString *)pre
{
//    self.orderNo =[self generateTradeNO];
    //获取ip
//    NSString * ip=[self getIpAddresses];
    NSString * str =[NSString stringWithFormat:@"%@/getMD5Key.json",EPUrl];
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int returnCode=[responseObject[@"returnCode"] intValue];
        if (returnCode==0) {
            //1.获取密钥
            NSString * key=responseObject[@"key"];
            //2.获取会话ID
//            EPData * data=[EPData new];
//            [data getMyOrderInfoWithType:@"7" withGoodsId:@"" withCount:nil withOrderId:nil withIp:ip withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:self.orderId password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
//                if ([returnCode intValue]==0) {
                    NSString * prepayId=pre;
                    NSString * partnerId=@"1339221201";
                    NSString * package=@"Sign=WXPay";
                    //当前时间
                    NSString * timeStamp=[self getDate];
                    //3.随机字符串
                    NSString * nonceStr=[self genNonceStr];
                    //4.获取签名
                    NSString * stringA=[NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%@",APPID,nonceStr,package,partnerId,prepayId,timeStamp];
                    NSString * nonceStrs=[NSString stringWithFormat:@"%@&key=%@",stringA,key];
                    NSString * sign=[self md5:nonceStrs].uppercaseString;
                    NSLog(@"拼接key字符串====%@",nonceStrs);
                    PayReq* req = [[PayReq alloc] init];
                    req.partnerId=partnerId;
                    req.prepayId=prepayId;
                    req.nonceStr = nonceStr;
                    req.timeStamp = [timeStamp intValue];
                    req.package = package;
                    req.sign = sign;
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",APPID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
                    //调起支付
                    [WXApi sendReq:req];
                    
//                }else{
//                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
//                }
//            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
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
//获取IP地址
- (NSString  *)getIpAddresses
{
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
//获取当前时间
- (NSString *)getDate{
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return date2;
}
//MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (NSString *)genNonceStr
{
    return [self md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}


@end
