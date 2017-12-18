//
//  EPMyOrderVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/12/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMyOrderVC.h"
#import "HeaderFile.h"
#import "EPOrderModel.h"
#import "EPCommentVC.h"
#import "EPGoodsDetailVC.h"
#import "EPSubmitController.h"
#import "EPOrderDVC.h"
//---微信支付----
#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonDigest.h>
//------支付宝------
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
//银联支付
#import "UPPaymentControl.h"
//.m使用
#import "DataSigner.h"
//.mm使用
#import "RSADataSigner.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
@interface EPMyOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;
/**数据数组*/
@property(nonatomic,strong)NSMutableArray * dataSource;
/**提示*/
@property(nonatomic,strong)UILabel * lb;

@end

@implementation EPMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:@"我的订单"];
    [self tb];
    [self tanchuView];
}
- (void)tanchuView{
    UILabel * favorLb=[[UILabel alloc]initWithFrame:CGRectMake((EPScreenW-150)/2, EPScreenH/2,150,30)];
    favorLb.backgroundColor=[UIColor whiteColor];
    favorLb.text=@"取消订单成功";
    favorLb.font=[UIFont systemFontOfSize:14];
    favorLb.textAlignment=NSTextAlignmentCenter;
    favorLb.alpha=0.0;
    favorLb.hidden=YES;
    favorLb.layer.borderColor=[[UIColor grayColor] CGColor];
    favorLb.layer.borderWidth=1;
    favorLb.layer.cornerRadius=5;
    _lb=favorLb;
    [self.view addSubview:favorLb];
}
- (void)wuOrderView{
    self.tb.hidden=YES;
    self.view.backgroundColor=RGBColor(234, 234, 234);
    UIImageView * img=[[UIImageView alloc]init];
    img.width=120;
    img.height=120;
    img.y=180;
    img.centerX=self.view.centerX;
    img.image=[UIImage imageNamed:@"订单"];
    img.layer.masksToBounds=YES;
    img.layer.cornerRadius=60;
    [self.view addSubview:img];
    UILabel * lb=[[UILabel alloc]init];
    lb.x=0;
    lb.y=CGRectGetMaxY(img.frame)+15;
    lb.width=EPScreenW;
    lb.height=21;
    lb.font=[UIFont systemFontOfSize:16];
    lb.text=@"您还没有下过订单";
    lb.textColor=RGBColor(153, 153, 153);
    lb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lb];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=RGBColor(0, 126, 241);
    btn.width=182;
    btn.height=46;
    btn.centerX=self.view.centerX;
    btn.y=CGRectGetMaxY(lb.frame)+15;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5.0;
    [btn setTitle:@"现在下一份" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clickBtn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goMain" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickBtnSubmitOrder:(UIButton *)btn{
    int dex=(int)(btn.tag-700);
    EPOrderModel * model=[self.dataSource objectAtIndex:dex];
    EPGoodsDetailVC * vc=[[EPGoodsDetailVC alloc]init];
    vc.goodsId=model.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LOGINTIME==nil) {
        [self wuOrderView];
    }else{
        [self getOrderData];
    }
}
- (void)getOrderData{
    [self.dataSource removeAllObjects];
    EPData * data=[EPData new];
    [data getMyOrderInfoWithType:@"1" withGoodsId:nil withCount:nil withOrderId:nil withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:nil  withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0) {
            NSArray * arr=dic[@"orderArr"];
            if (arr.count==0)
            {
                [self wuOrderView];
            }else{
                for (NSDictionary * dict in arr) {
                    EPOrderModel * model=[EPOrderModel mj_objectWithKeyValues:dict];
                    [self.dataSource addObject:model];
                }
            }
             [self.tb reloadData];
        }else if([returnCode intValue]==2){
            NSString * msg=[dic objectForKey:@"msg"];
            [EPLoginViewController publicDeleteInfo];
            EPLoginViewController * vc=[[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [self presentViewController:vc animated:YES completion:nil];
            }];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据请求失败，请稍后重试" count:0 doWhat:nil];
        }
    }];
}
- (void)clickPayMoney:(UIButton *)btn{
    int dex=(int)(btn.tag-700);
    EPOrderModel * model=[self.dataSource objectAtIndex:dex];
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:@"请选择支付方式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aipay =[UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        [self payAipayWith:model.orderNo withDex:dex];
    }];
    [alert addAction:aipay];
    UIAlertAction * wechat =[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信支付");
        if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            [self jumpToBizPay:model.goodsId withOrderNo:model.orderNo];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的设备未安装微信" count:0 doWhat:nil];
        }
        
    }];
    [alert addAction:wechat];
    UIAlertAction * ChinaPay =[UIAlertAction actionWithTitle:@"银联支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"银联支付");
        [self clickChinaPay:model.orderNo];
    }];
    [alert addAction:ChinaPay];
    
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
//银联支付
- (void)clickChinaPay:(NSString *)orderNo{
    EPData * data=[EPData new];
    [data getMyOrderInfoWithType:@"8" withGoodsId:nil withCount:nil withOrderId:nil withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:orderNo password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        // NSLog(@"银联支付交易流水号---->%@",dic);
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
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败，请稍后重试" count:0 doWhat:nil];
        }
    }];
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
-(void)jumpToBizPay:(NSString *)goodsId withOrderNo:(NSString *)orderNo{
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
            [data getMyOrderInfoWithType:@"7" withGoodsId:goodsId withCount:nil withOrderId:nil withIp:ip withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:orderNo password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                if ([returnCode intValue]==0) {
                    NSString * prepayId=dic[@"prepayid"];
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
                    PayReq* req = [[PayReq alloc] init];
                    req.partnerId=partnerId;
                    req.prepayId=prepayId;
                    req.nonceStr = nonceStr;
                    req.timeStamp = [timeStamp intValue];
                    req.package = package;
                    req.sign = sign;
                    // NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",APPID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
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
//支付宝支付
- (void)payAipayWith:(NSString *)orderNumber withDex:(int)dex{
    EPData * data=[EPData new];
    [data getMyOrderInfoWithType:@"6" withGoodsId:nil withCount:nil withOrderId:orderNumber withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:nil withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        //NSLog(@"获取签名:---%@",dic);
        if ([returnCode intValue]==0) {
            NSString * sign=dic[@"sign"];
            [self PayTreasure:dex withSign:sign];
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
-(void)PayTreasure:(int)dex withSign:(NSString *)sign{
    EPOrderModel * model=[self.dataSource objectAtIndex:dex];
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
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = model.orderNo; //订单ID（由商家自行制定）
    order.subject = model.goodsName;//product.subject; //商品标题
    order.body = model.goodsCount;//product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",[model.payPrice floatValue]]; //商品价格
    order.notifyURL =[NSString stringWithFormat:@"%@/successAlipayPay.json",EPUrl]; //回调URL
    
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
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else if ([result intValue]==6001){
                //用户取消
                NSLog(@"用户主动取消支付");
            }else{
                NSLog(@"支付失败");
            }
        }];
    }else{
        NSLog(@"钱包支付");
    }
    
}
- (NSString *)getUniqueStrByUUID {
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
    NSString *string = [self getUniqueStrByUUID];
    return string;
}
- (void)clickComment:(UIButton *)btn{
    //去评价
    int dex=(int)(btn.tag-800);
    EPOrderModel * model=[self.dataSource objectAtIndex:dex];
        EPCommentVC * vc=[[EPCommentVC alloc]init];
        vc.navTitle=model.shopName;
        vc.goodName=model.goodsName;
        vc.goodsId=model.goodsId;
        vc.orderId=model.orderNo;
        [self.navigationController pushViewController:vc animated:YES];
}
- (void)clickCancleOrder:(UIButton *)btn{
    int dex=(int)(btn.tag-800);
    EPOrderModel * model=[self.dataSource objectAtIndex:dex];
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"该订单取消后无法恢复，您确定?" count:1 doWhat:^{
        //确定取消订单 根据订单号
         [EPTool addMBProgressWithView:self.view style:0];
         [EPTool showMBWithTitle:@""];
         EPData * data=[EPData new];
         [data getMyOrderInfoWithType:@"3" withGoodsId:nil withCount:nil withOrderId:model.orderNo withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:nil  withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
             [EPTool hiddenMBWithDelayTimeInterval:0];
            if ([returnCode intValue]==0) {
                [UIView animateWithDuration:1 animations:^{
                    _lb.alpha=1.0;
                    _lb.hidden=NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:20 animations:^{
                        _lb.hidden=YES;
                        _lb.alpha=0;
                        [self getOrderData];
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }else if ([returnCode integerValue]==2){
                [EPLoginViewController publicDeleteInfo];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                    EPLoginViewController * login=[[EPLoginViewController alloc]init];
                    [self presentViewController:login animated:YES completion:nil];
                }];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，取消订单失败，请稍后重试" count:0 doWhat:nil];
            }
        }];
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataSource.count>0) {
        CGFloat leftX=15;
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.backgroundColor=[UIColor whiteColor];
        vc.frame=CGRectMake(0, 0,EPScreenW , 175);
        EPOrderModel * model=[self.dataSource objectAtIndex:indexPath.section];
        UIView * line1=[[UIView alloc]init];
        [vc addSubview:line1];
        line1.backgroundColor=RGBColor(238, 238, 238);
        line1.frame=CGRectMake(leftX, 37, EPScreenW-2*leftX, 1);
        
        UIView * line2=[[UIView alloc]init];
        [vc addSubview:line2];
        line2.backgroundColor=RGBColor(238, 238, 238);
        line2.frame=CGRectMake(leftX, 175-47, EPScreenW-2*leftX, 1);
        
        UILabel * shopNameLb=[[UILabel alloc]init];
        [vc addSubview:shopNameLb];
        shopNameLb.frame=CGRectMake(leftX, 0, EPScreenW-2*leftX, 38);
        shopNameLb.font=[UIFont boldSystemFontOfSize:16];
        shopNameLb.textColor=RGBColor(51, 51, 51);
        shopNameLb.text=model.shopName;
        
        UIImageView * goodImg=[[UIImageView alloc]init];
        [vc addSubview:goodImg];
        goodImg.frame=CGRectMake(leftX, CGRectGetMaxY(line1.frame)+7, 75, 75);
        [goodImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];
        
        CGFloat imgleftX=CGRectGetMaxX(goodImg.frame)+7;
        UILabel * goodNameLb=[[UILabel alloc]init];
        [vc addSubview:goodNameLb];
        goodNameLb.frame=CGRectMake(imgleftX, goodImg.y, EPScreenW-imgleftX-leftX, 14);
        goodNameLb.textColor=RGBColor(51, 51, 51);
        goodNameLb.font=[UIFont systemFontOfSize:14];
        goodNameLb.text=[NSString stringWithFormat:@"%@x%@",model.goodsName,model.goodsCount];
    
        UILabel * timeLb=[[UILabel alloc]init];
        [vc addSubview:timeLb];
        timeLb.frame=CGRectMake(imgleftX, CGRectGetMaxY(goodNameLb.frame)+5, goodNameLb.width, 10);
        timeLb.textColor=RGBColor(149, 149, 149);
        timeLb.font=[UIFont systemFontOfSize:10];
        NSString * time=[model.orderTime substringToIndex:16];
        timeLb.text=[NSString stringWithFormat:@"下单时间: %@",time];
        
        UILabel * priceLb=[[UILabel alloc]init];
        [vc addSubview:priceLb];
        priceLb.frame=CGRectMake(imgleftX, CGRectGetMaxY(timeLb.frame)+13, goodNameLb.width, 14);
        priceLb.font=[UIFont boldSystemFontOfSize:14];
        priceLb.textColor=RGBColor(255, 0, 0);
        float price=[model.goodsPrice floatValue]*[model.goodsCount floatValue];
        priceLb.text=[NSString stringWithFormat:@"¥ %.2f",price];
        
        UILabel * stateLb=[[UILabel alloc]init];
        [vc addSubview:stateLb];
        stateLb.frame=CGRectMake(imgleftX, CGRectGetMinY(line2.frame)-7-12, goodNameLb.width, 12);
        stateLb.font=[UIFont systemFontOfSize:12];
        stateLb.textColor=RGBColor(51, 51, 51);
        stateLb.text=[NSString stringWithFormat:@"订单状态: %@",model.orderStatusName];
        
        CGSize ss=CGSizeMake(65, 28);
        UIButton * btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.size=ss;
        btn1.y=CGRectGetMaxY(line2.frame)+9;
        btn1.x=EPScreenW-leftX-ss.width;
        btn1.layer.masksToBounds=YES;
        btn1.layer.cornerRadius=5;
        btn1.titleLabel.font=[UIFont systemFontOfSize:14];
        btn1.tag=700+indexPath.section;
        
        UIButton * btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        btn2.size=ss;
        btn2.y=CGRectGetMaxY(line2.frame)+9;
        btn2.x=EPScreenW-30-ss.width*2;
        btn2.layer.masksToBounds=YES;
        btn2.layer.cornerRadius=5;
        btn2.titleLabel.font=[UIFont systemFontOfSize:14];
        btn2.tag=800+indexPath.section;
        //待付款
        if ([model.orderStatus intValue]==0) {
            [vc addSubview:btn1];
            btn1.backgroundColor=RGBColor(225, 18, 23);
            [btn1 setTitle:@"去付款" forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(clickPayMoney:) forControlEvents:UIControlEventTouchUpInside];
            [vc addSubview:btn2];
            btn2.backgroundColor=RGBColor(238, 238, 238);
            [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
            [btn2 setTitleColor:RGBColor(102, 102, 102) forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(clickCancleOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if ([model.isEvaluate intValue]==0) {
                //未评论
                //是否还有已使用字符串
                if ([model.orderStatusName rangeOfString:@"已使用"].location !=NSNotFound)
                {
                    [vc addSubview:btn1];
                    btn1.backgroundColor=RGBColor(225, 18, 23);
                    [btn1 setTitle:@"再来一单" forState:UIControlStateNormal];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 addTarget:self action:@selector(clickBtnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
                    [vc addSubview:btn2];
                    btn2.backgroundColor=RGBColor(238, 238, 238);
                    [btn2 setTitle:@"去评价" forState:UIControlStateNormal];
                    [btn2 setTitleColor:RGBColor(102, 102, 102) forState:UIControlStateNormal];
                    [btn2 addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [vc addSubview:btn1];
                    btn1.backgroundColor=RGBColor(225, 18, 23);
                    [btn1 setTitle:@"再来一单" forState:UIControlStateNormal];
                    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn1 addTarget:self action:@selector(clickBtnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }else{
                [vc addSubview:btn1];
                btn1.backgroundColor=RGBColor(225, 18, 23);
                [btn1 setTitle:@"再来一单" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(clickBtnSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转到订单详情
    EPOrderModel * model=[self.dataSource objectAtIndex:indexPath.section];
    if ([model.orderStatusName isEqualToString:@"待付款"]){
        //待付款订单
//        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"该订单是未付款状态,不能查看订单详情" count:0 doWhat:nil];
        EPGoodsDetailVC * vc=[[EPGoodsDetailVC alloc]init];
        vc.goodsId=model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
       // EPOrderDetailVC * vc=[[EPOrderDetailVC alloc]init];
        EPOrderDVC *vc=[[EPOrderDVC alloc]init];
        vc.goodsImg=model.goodsImg;
        vc.goodsName=model.goodsName;
        vc.commitTime=model.orderTime;
        vc.shopName=model.shopName;
        vc.shopPhone=model.shopPhone;
        vc.shopAddress=model.shopAddress;
        vc.useScore=model.useScore;
        vc.exchangeCode=model.exchangeCode;
        vc.goodsCount=model.goodsCount;
        vc.price=model.goodsPrice;
        vc.useCodeList=model.useCodeList;
        vc.statusName=model.orderStatusName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.tb]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tb setEditing:editing animated:animated];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        EPOrderModel * model=[self.dataSource objectAtIndex:indexPath.section];
        if ([model.orderStatusName isEqualToString:@"待付款"]) {
            //取消订单接口
            EPData * data=[EPData new];
            [data getMyOrderInfoWithType:@"3" withGoodsId:nil withCount:nil withOrderId:model.orderNo withIp:nil  withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:nil  withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                NSString * msgStr=dic[@"msg"];
                if ([returnCode intValue]==0) {
                    if (self.dataSource.count==0) {
                        [self wuOrderView];
                    }else{
                        [self getOrderData];
                    }
                }else if ([returnCode intValue]==1){
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msgStr count:0 doWhat:nil];
                }else if ([returnCode intValue]==2){
                    [EPLoginViewController publicDeleteInfo];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                        EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                        [self presentViewController:vc animated:YES completion:nil];
                    }];
                }else{
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络连接中断，请重新删除" count:1 doWhat:^{
                        
                    }];
                }
                
            }];
        }else{
            EPData * data=[EPData new];
            [data getMyOrderInfoWithType:@"4" withGoodsId:nil withCount:nil withOrderId:model.orderNo withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:nil  withRefundReson:nil WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                //NSString * msgStr=dic[@"msg"];
                if ([returnCode intValue]==0) {
                    if (self.dataSource.count==0) {
                        [self wuOrderView];
                    }else{
                        [self getOrderData];
                    }
                }else if ([returnCode intValue]==1){
                    NSString * msg=[NSString stringWithFormat:@"该订单处于%@状态,不可删除",model.orderStatusName];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                }else if ([returnCode intValue]==2){
                    [EPLoginViewController publicDeleteInfo];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                        EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                        [self presentViewController:vc animated:YES completion:nil];
                    }];
                }else{
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络连接中断，请重新删除" count:1 doWhat:^{
                        
                    }];
                }
                
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 8;
    }
}
-(UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, EPScreenW, EPScreenH-64) style:UITableViewStylePlain];
        _tb.backgroundColor=RGBColor(238, 238, 238);
        _tb.dataSource=self;
        _tb.delegate=self;
        _tb.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_tb];
    }
    return _tb;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
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
