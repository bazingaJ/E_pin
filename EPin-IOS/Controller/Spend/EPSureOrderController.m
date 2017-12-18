//
//  EPSureOrderController.m
//  EPin-IOS
//
//  Created by jeaderq on 16/6/16.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSureOrderController.h"
#import "EPGoodsDetailVC.h"
#import "HeaderFile.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "WXPayView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>
//------支付宝------
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
//.m使用
#import "DataSigner.h"
//.mm使用
#import "RSADataSigner.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
//银联支付
#import "UPPaymentControl.h"
@interface EPSureOrderController ()
@property(nonatomic,strong)NSMutableArray * productList;
@property (nonatomic, strong) NSMutableArray *priceArr;
@property (nonatomic, strong) NSString *orderNo;
@end

@implementation EPSureOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"确认订单"];
    EPData *data = [EPData new];
    self.priceArr = [NSMutableArray array];
    self.orderNo =[self generateTradeNO];
    NSLog(@"orderNo ====%@",self.orderNo);//CE1099CB-3CFC-483E-ABB9-4F6B90B9FFBA     0AEBFFF9-0F48-4D73-A72B-763DFB1AB5C4
    [data getMyOrderInfoWithType:@"0" withGoodsId:self.goodsId withCount:self.numbe withOrderId:nil withIp:nil withPayStyle:@"0" withCardId:nil withUseScore:self.useJF withOrderNo:_orderNo password:nil withCodes:nil  withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0) {
            EPMainModel *mode = [EPMainModel mj_objectWithKeyValues:dic];
            NSLog(@"%f,%@",mode.payPrice,mode.price);
            [self.priceArr addObject:mode];
            [self setData];
        }
        else
        {
        [self.navigationController popViewControllerAnimated:YES];
        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
            
        }];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"weChatFinishPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popFailView) name:@"weChatFailPay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCancleView) name:@"weChatCanclePay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popview) name:@"uppaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popFailView) name:@"uppayFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCancleView) name:@"uppayCancle" object:nil];
}
- (void)popview{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popDetail" object:nil];
}
- (void)popFailView{
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"该订单交易失败，请重新下单" count:0 doWhat:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)popCancleView{
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您已取消该订单,如需购买请重新下单" count:0 doWhat:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)setData{
    if (self.priceArr.count>0) {
        EPMainModel *mode = self.priceArr[0];
        
        self.payPriceL.text = self.goodsName;
        self.payPriceNL.text =[NSString stringWithFormat:@"￥ %.2f",mode.payPrice];
        self.shopNameL.text = self.goodsName;
        self.numberL.text = [NSString stringWithFormat:@"数量  x %@",self.numbe];
        self.unitPriceL.text =[NSString stringWithFormat:@"单价 ￥%@",mode.price];
        self.payPriceNL2.text =[NSString stringWithFormat:@"合计 ￥%.2f",mode.payPrice];
        [self.payBtn setTitle:[NSString stringWithFormat:@"确认支付 ￥%.2f",mode.payPrice] forState:UIControlStateNormal];
        if (self.isAliPay == YES) {
            self.payType.text = @"支付宝";
        }else if (self.isMyMoney==YES){
            self.payType.text = @"我的钱包";
        }else if (self.isWechart==YES){
            self.payType.text = @"微信";
        }
    }
}
- (IBAction)Pay:(UIButton *)sender {
    if ([self.payType.text isEqualToString:@"支付宝"]) {
        [self ClickAliPay];
    }else if ([self.payType.text isEqualToString:@"微信"]){
        [self weChatPay];
    }else if([self.payType.text isEqualToString:@"我的钱包"]){
        [self ClickMyMoney];
    }
    
}
//银联支付
- (void)ClickMyMoney{
    NSLog(@"银联支付");
    //开始支付
//    [[UPPaymentControl defaultControl] startPay:@"201611041429085412498" fromScheme:@"EPin-IOS" mode:@"01" viewController:self];
    EPData * data=[EPData new];
    [data getMyOrderInfoWithType:@"8" withGoodsId:nil withCount:nil withOrderId:nil withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:self.orderNo password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        NSLog(@"银联支付交易流水号---->%@",dic);
        //获取tn
        if ([returnCode intValue]==0) {
            NSString * tn=dic[@"tn"];
            if (tn!=nil&&tn.length>0) {
                //开始支付
                [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"EPin-IOS" mode:@"00" viewController:self];
            }
        }else if ([returnCode intValue]==1){
             [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
        }else if ([returnCode intValue]==2){
            [EPLoginViewController publicDeleteInfo];
            EPLoginViewController * vc=[[EPLoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败" count:0 doWhat:nil];
        }
    }];
}
//支付宝支付
- (void)ClickAliPay{
    EPData * data=[EPData new];
    [data getMyOrderInfoWithType:@"6" withGoodsId:nil withCount:nil withOrderId:self.orderNo withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0) {
            NSString * sign=dic[@"sign"];
            [self PayTreasure:sign];
        }else if ([returnCode intValue]==1){
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
        }else if ([returnCode intValue]==2){
            [EPLoginViewController publicDeleteInfo];
            EPLoginViewController * vc=[[EPLoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败" count:0 doWhat:nil];
        }
    }];
}
//微信支付
- (void)weChatPay{
     if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]){
         [self jumpToBizPay];
     }else{
         [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的设备未安装微信" count:0 doWhat:nil];
     }
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
//微信支付
-(void)jumpToBizPay {
    [EPTool addMBProgressWithView:self.view style:0];
    //获取ip
    NSString * ip=[EPTool getIpAddresses];
    NSString * str =[NSString stringWithFormat:@"%@/getMD5Key.json",EPUrl];
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int returnCode=[responseObject[@"returnCode"] intValue];
        if (returnCode==0) {
            //1.获取秘钥
            NSString * key=responseObject[@"key"];
            //2.获取会话ID
            EPData * data=[EPData new];
            [data getMyOrderInfoWithType:@"7" withGoodsId:self.goodsId withCount:nil withOrderId:nil withIp:ip withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:self.orderNo password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                if ([returnCode intValue]==0) {
                    NSString * prepayId=dic[@"prepayid"];
                    //NSString * prepayId=@"wx20160807161925176cb986d70217972177";
                    NSString * partnerId=@"1339221201";
                    NSString * package=@"Sign=WXPay";
                    //当前时间
                    NSString * timeStamp=[EPTool getDate];
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
                    
                }else{
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                }
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)PayTreasure:(NSString *)sign
{
    
    
    
        EPMainModel *mode = self.priceArr[0];
   
    /*
     *点击获取prodcut实例并初始化订单信息
     */
//    Product *product = [self.productList objectAtIndex:1];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088221986373276";
    NSString *seller = @"developer@jeader.com";
//    NSString *privateKey = @"MIICXAIBAAKBgQDEv6raWtBnu2D/gT0rVUJbSuYsmwszIHMv83hw9lvczZ7j1WM+VEIqzkRHw1gx0/cUTt9PbWR9c83gKNV08OnVsfj/9Ze/wt7HyMAWIpJ+wl3bcyxpHWn4o8DEoV0Mype3otWqzatHadFKUcMCD7NE6lAguh9QE4HRJAPSZ8L6VQIDAQABAoGAbdjNHShC3weA+mY/rqflam8A37qYoCzn4se+YONLGpY6td13kV8dqiSLfr2Tyg4cDtySVRgwWNKFCTgDJU00X72hRDStodAzFvy0nq+pwkYxBcTLG+MZls7piv/J1ByF2sFTr8cu5xrtcTEL4BdQxSGyazjavVWSTC69F0M5xsECQQDy20izsvzCSvgfyWTMovppmRbBEr5EkSBPJPxWnmujFdgeZrsuA0pFlJWuWzKCV13rJqFLEOMV+9z9xJ2/oLBZAkEAz2WSDPk+b0v9yDLTDnwaoXsKQXOJ+e4PFMjTfa/eIgW4Hnpf3lqFq+FjHL6SnmkJ3R7bVIpC9Bg5IIr6Kgz6XQJBALo0afzmSqiKJM7ycqf4ejnHGEw3G82k3HnyaMvdMbhcglVk/TWdbjAFafLCl+qaJDetadQNgaAUee/U9gK8qRkCQGIJDi/JxaSQlEcFF1U6ftAkPCXSOr+Es2ZMxAQelO8aKv1lNVoDCjrEULhusRnmZv46Ls1YieueY6qpZzVnaxUCQH0VgjF6XJb7NubctgR6AIPckj7XHIIBpnJW+znbdr8ftc9k7BEWPXidEEH2n081ZezS5XCtSt0vpGf70+rp+pU=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = self.orderNo; //订单ID（由商家自行制定）
    order.subject = self.goodsName;//product.subject; //商品标题
    order.body = self.numbe;//product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",mode.payPrice]; //商品价格
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
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode


//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = sign;//[signer signString:orderSpec];
    NSLog(@"signedString===%@",signedString);
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"orderString===%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *result =resultDic[@"resultStatus"];
            if ([result intValue]==9000) {
                NSLog(@"支付宝交易成功");
//                EPGoodsDetailVC *myOrder = [[EPGoodsDetailVC alloc]init];
                [self.navigationController popViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"popDetail" object:nil];

            }else if ([result intValue]==6001){
                //用户取消
                NSLog(@"用户主动取消支付");
            }else{
                NSLog(@"支付失败");
            }
        }];
    }else{
        WXPayView *view = [[WXPayView alloc] initWithMoney:mode.payPrice cardMessage:nil completion:^(NSString *password) {
            NSLog(@"输入的密码是%@",password); // 密码输入完成回调
            // doSomething....
            [view hidden];
            
            EPData *data = [EPData new];
            [data getMyOrderInfoWithType:@"2" withGoodsId:@"" withCount:@"" withOrderId:@"" withIp:nil withPayStyle:@"" withCardId:@"" withUseScore:@"" withOrderNo:self.orderNo password:password withCodes:nil  withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                if ([returnCode intValue]==0) {
                    //输入支付密码
                    
                }else if ([returnCode intValue]==1){
                    //支付密码不正确
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
                        //重置支付密码
//                        EPResetPasswordController * vc=[[EPResetPasswordController alloc]init];
//                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    
                }else if ([returnCode intValue]==2){
                    [EPLoginViewController publicDeleteInfo];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
                        EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                        [self presentViewController:vc animated:YES completion:nil];
                    }];
                }
                if ([returnCode intValue]==3) {
                    //未设置支付密码
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
//                        EPPayPasswordViewController * vc=[[EPPayPasswordViewController alloc]init];
//                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    
                }
            }];

        }];
        __weak WXPayView *weakView = view;
        view.exitBtnClicked = ^{ // 点击了退出按钮
            NSLog(@"点击了退出按钮");
            [weakView hidden];
        };
        [view show];
    }
}
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    NSString *string = [retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];

    return string;
}

#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    //    static int kNumber = 16;
    //    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //    NSMutableString *resultStr = [[NSMutableString alloc] init];
    //    srand((unsigned)time(0));
    //    for (int i = 0; i < kNumber; i++)
    //    {
    //        unsigned index = rand() % [sourceStr length];
    //        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
    //        [resultStr appendString:oneStr];
    //    }
    //    return resultStr;
    NSString *string = [self getUniqueStrByUUID];
    return string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
