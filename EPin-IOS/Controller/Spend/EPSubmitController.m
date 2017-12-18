//
//  EPSubmitController.m
//  EPin-IOS
//
//  Created by jeaderQ on 16/4/3.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSubmitController.h"
#import "HeaderFile.h"
#import "WXPayView.h"
#import "EPFaresController.h"
#import "EPSureOrderController.h"


@interface EPSubmitController ()<UITextFieldDelegate>
/**
 *  我的钱包按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *weixinClickBtn;
/**
 *  支付宝
 */
@property (weak, nonatomic) IBOutlet UIButton *myMoney;

/**
 *  微信按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *wechartBtn;


@property (weak, nonatomic) IBOutlet UIView *payBG;
/**
 *  购买数量
 */
@property (weak, nonatomic) IBOutlet UITextField *numbe;

@property (nonatomic, assign) int fen;
//原价
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameL;

@property (weak, nonatomic) IBOutlet UILabel *zheKou;

//订单
@property (nonatomic, strong) NSMutableArray *productList;

@end

@implementation EPSubmitController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fen = 1;
    self.originalPrice.text = [NSString stringWithFormat:@"￥ %@",self.price];
    
    [self addNavigationBar:2 title:@"提交订单"];
    [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(dismiss) name:@"返回"];
    self.myMoney.selected = YES;
    [_numbe setEnabled:NO];
    self.goodsNameL.text = [NSString stringWithFormat:@"消费商品：%@",self.goodsName];
    if (self.count) {
        self.numbe.text = self.count;
    }else{
        self.numbe.text = @"1";
    }

    self.zheKou.text = [NSString stringWithFormat:@"%.1f 折",self.zhekou];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"favor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"popDetail" object:nil];
//     [self.jifenL addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    if ([self compareTotalScore:[self.costScore floatValue]*_fen]) {
//        
//        self.jifenL.text = [NSString stringWithFormat:@"%d",[self.costScore intValue] *_fen];
//        self.preferentialL.text =[NSString stringWithFormat:@"-￥ %.2f",[self.costScore floatValue] *_fen/10];
//        self.presentPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue]*_fen - [self.costScore intValue] *_fen/10];
//    }else{
//        self.presentPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue]*_fen - [TOTALSCORE floatValue]/10];
//        self.jifenL.text = [NSString stringWithFormat:@"%@",TOTALSCORE];
//        self.preferentialL.text =[NSString stringWithFormat:@"-￥ %.2f",[TOTALSCORE floatValue] /10];
//    }
    

}
- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}
//注销键盘的第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}
-(void)textFieldDidChange :(UITextField *)tf{
    NSLog( @"text changed: %@", tf);
//    float  jifen=[self.price floatValue]*_fen;
//    float to=[self.costScore floatValue]*_fen;
//    float tfJIifen=[tf.text floatValue];
//    if (tfJIifen/10>to||tfJIifen/10==to)
//    {
//        //价格>总积分
//        if (tfJIifen>jifen*10) {
//            //输入积分大于金额
//            tf.text=[NSString stringWithFormat:@"%.0f",to];
//            self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",to/10];
//            self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-to/10];
//        }else if(tfJIifen==jifen*10){
//            //输入积分<=金额
//            
//            tf.text= [NSString stringWithFormat:@"%.0f",to];
//            self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",to/10];
//            self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-tfJIifen/10];
//        }else{
//            if ([tf.text floatValue]>to) {
//                tf.text= [NSString stringWithFormat:@"%.0f",to];
//                self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",to/10];
//                self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-to/10];
//
//            }else{
//            self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",tfJIifen/10];
//            self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-tfJIifen/10];
//            }
//        }
//        
//    }else{
//        if ([self compareTotalScore:tfJIifen]) {
//            self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",tfJIifen/10];
//            self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-tfJIifen/10];
//
//        }else{
//            self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",[TOTALSCORE floatValue]/10];
//            self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-[TOTALSCORE floatValue]/10];
//            tf.text = TOTALSCORE;
//
//        }
////        if ([self compareTotalScore:tfJIifen]) {
//        
////     5544   }
////        else{
////        //输入积分<=金额
////            self.preferentialL.text=[NSString stringWithFormat:@"- ¥ %.2f",tfJIifen/10];
////            self.presentPrice.text=[NSString stringWithFormat:@"¥ %.2f",jifen-tfJIifen/10];
////        }
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickOrders:(UIButton *)sender {
    NSLog(@"确认下单 %s",__func__);
    EPSureOrderController *EPPay = [[EPSureOrderController alloc]init];

    if (self.myMoney.selected ==YES) {

        EPPay.isMyMoney = self.myMoney.selected;
        EPPay.goodsId = self.goodsId;
        EPPay.numbe = self.numbe.text;
        EPPay.goodsName = self.goodsName;
        [self.navigationController pushViewController:EPPay animated:YES];
        
    }else if (self.weixinClickBtn.selected == YES){
        EPPay.goodsId = self.goodsId;
        EPPay.numbe = self.numbe.text;
        EPPay.goodsName = self.goodsName;
        EPPay.isAliPay = self.weixinClickBtn.selected;
        [self.navigationController pushViewController:EPPay animated:YES];

    }else if (self.wechartBtn.selected == YES){
        EPPay.goodsId = self.goodsId;
        EPPay.numbe = self.numbe.text;
        EPPay.goodsName = self.goodsName;
        EPPay.isWechart = self.wechartBtn.selected ;
        [self.navigationController pushViewController:EPPay animated:YES];
    }
   
}

- (IBAction)myMoner:(UIButton *)sender {
    self.weixinClickBtn.selected=NO;
    self.wechartBtn.selected = NO;
    self.myMoney.selected = NO;
    sender.selected = YES;
}


- (IBAction)jiaYI:(UIButton *)sender
{
    _fen++;
    if (_fen <=0) {
        _fen = 0;
    }
    self.numbe.text = [NSString stringWithFormat:@"%d",_fen];
    self.originalPrice.text = [NSString stringWithFormat:@"￥ %.2f",([self.price floatValue]*_fen)];
//    NSString *price = self.originalPrice.text;
//    NSString *jifen = self.preferentialL.text;
//    jifen = [jifen substringFromIndex:2];
//    price =  [price substringFromIndex:1];
//    NSLog(@"%@",price);
//    NSString * jiFen = [NSString stringWithFormat:@"%d",_fen];
//    self.numbe.text = jiFen;
//    self.originalPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue] * _fen];
//    
//    if ([self compareTotalScore:[self.costScore floatValue]*_fen]) {
//        
//        self.jifenL.text = [NSString stringWithFormat:@"%d",[self.costScore intValue] *_fen];
//        self.preferentialL.text =[NSString stringWithFormat:@"-￥ %.2f",[self.costScore floatValue] *_fen/10];
//        self.presentPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue]*_fen - [self.costScore intValue] *_fen/10];
//    }else{
//        self.presentPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue]*_fen - [TOTALSCORE floatValue]/10];
//        self.jifenL.text = [NSString stringWithFormat:@"%@",TOTALSCORE];
//        self.preferentialL.text =[NSString stringWithFormat:@"-￥ %.2f",[TOTALSCORE floatValue] /10];
//    }
    
}
- (IBAction)jianYi:(UIButton *)sender {
    _fen--;
    if (_fen <=0) {
        _fen = 0;
    }
    self.numbe.text = [NSString stringWithFormat:@"%d",_fen];
    self.originalPrice.text = [NSString stringWithFormat:@"￥ %.2f",([self.price floatValue]*_fen)];
//    NSString * jiFen = [NSString stringWithFormat:@"%d",_fen];
//    self.numbe.text = jiFen;
//    self.originalPrice.text =[NSString stringWithFormat:@"￥ %.2f",[self.price floatValue] * _fen];
//    
//    if ([self compareTotalScore:[self.costScore floatValue]*_fen]) {
//        self.presentPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue]*_fen - [self.costScore intValue] *_fen/10];
//
//        self.jifenL.text = [NSString stringWithFormat:@"%d",[self.costScore intValue] *_fen];
//        self.preferentialL.text =[NSString stringWithFormat:@"-￥ %.2f",[self.costScore floatValue] *_fen/10];
//    }else{
//        self.presentPrice.text = [NSString stringWithFormat:@"￥ %.2f",[self.price floatValue]*_fen - [TOTALSCORE floatValue]/10];
//        self.jifenL.text = [NSString stringWithFormat:@"%@",TOTALSCORE];
//        self.preferentialL.text =[NSString stringWithFormat:@"-￥ %.2f",[TOTALSCORE floatValue] /10];
//    }
    

}
//-(BOOL)compareTotalScore:(float)text
//{
//    float totalScore = [TOTALSCORE floatValue];
//   
//    if (totalScore>text) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
/*
#pragma mark - Navigation
 
 
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
