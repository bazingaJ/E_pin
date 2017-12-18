//
//  EPMyEpaiViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/7/14.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMyEpaiViewController.h"
#import "HeaderFile.h"
#import "EPPaiCell.h"
#import "EPEpaiModel.h"
#import "EPDynamic.h"
//------支付宝------
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
@interface EPMyEpaiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tb;

@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation EPMyEpaiViewController
{
    NSString *orderId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"我的半价"];
    self.tb.hidden=YES;
    self.tb.delegate=self;
    self.tb.dataSource=self;
    self.tb.backgroundColor=RGBColor(233, 233, 233);
    [self.tb registerNib:[UINib nibWithNibName:@"EPPaiCell" bundle:nil] forCellReuseIdentifier:@"EPPaiCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LOGINTIME==nil) {
        [self noPaiView];
    }else{
        [self getMyEpaiData];
    }
}
- (void)noPaiView{
    self.view.backgroundColor=RGBColor(234, 234, 234);
    UILabel * lb=[[UILabel alloc]init];
    [self.view addSubview:lb];
    lb.frame=CGRectMake(0, EPScreenH/2-8, EPScreenW, 16);
    lb.text=@"您尚未参与过竞拍";
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:14];
}
- (void)getMyEpaiData{
    [self.dataArr removeAllObjects];
    EPData * data=[EPData new];
    [data getAuctionDataWithType:@"3" withGoodsId:nil withOrderId:nil Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        // NSLog(@"%@",dic);
        if ([returnCode intValue]==0) {
            NSArray * myAucition=dic[@"myAucition"];
            if (myAucition.count==0) {
                [self noPaiView];
            }else{
                self.tb.hidden=NO;
                for (NSDictionary * dict in myAucition) {
                    EPMyEpaiModel * model=[EPMyEpaiModel mj_objectWithKeyValues:dict];
                    [self.dataArr addObject:model];
                }
            }
            [self.tb reloadData];
        }else if ([returnCode integerValue]==2){
            [EPLoginViewController publicDeleteInfo];
             EPLoginViewController * vc=[[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [self presentViewController:vc animated:YES completion:nil];
            }];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，获取数据失败，请稍后重试" count:0 doWhat:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}
- (void)toClickAipay:(UITapGestureRecognizer *)tap{
    NSInteger index=tap.view.tag-900;
    EPMyEpaiModel * model=[self.dataArr objectAtIndex:index];
    //跳支付宝
    EPData * data=[EPData new];
    [data getAuctionDataWithType:@"4" withGoodsId:nil withOrderId:model.orderId Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0) {
            NSString *sign = dic[@"sign"];
            [self PayTreasure:sign orderNo:model.orderId body:@"0" Price:model.goodsClapPrice];
        }
    }];

}
#pragma mark------UITableViewDataSource----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EPMyEpaiModel * model=[self.dataArr objectAtIndex:indexPath.section];
    EPPaiCell * cell=[tableView dequeueReusableCellWithIdentifier:@"EPPaiCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model=model;
    if ([cell.state.text isEqualToString:@"去付款"]) {
         cell.state.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toClickAipay:)];
        cell.state.tag=900+indexPath.section;
        [cell.state addGestureRecognizer:tap];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }else{
        return 10;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EPMyEpaiModel * model=[self.dataArr objectAtIndex:indexPath.section];
    EPDynamic * vc=[[EPDynamic alloc]init];
    vc.goodsId=model.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
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
-(void)PayTreasure:(NSString *)sign orderNo:(NSString *)orderNo body:(NSString *)body Price:(NSString *)payPrice {
    
    
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
    order.outTradeNO = orderNo; //订单ID（由商家自行制定）
    order.subject = @"半价购支付";//product.subject; //商品标题
    order.body = body;//product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",[payPrice floatValue]]; //商品价格
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
               }else if ([result intValue]==6001){
                //用户取消
                NSLog(@"用户主动取消支付");
            }else{
                NSLog(@"支付失败");
            }
        }];
    }
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
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
