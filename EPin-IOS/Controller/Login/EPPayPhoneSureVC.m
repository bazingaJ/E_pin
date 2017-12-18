//
//  EPPayPhoneSureVC.m
//  EPMerchant-iOS
//
//  Created by jeaderL on 16/6/30.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "EPPayPhoneSureVC.h"
#import "EPSetPass2ViewController.h"
#import "HeaderFile.h"
#import "JKCountDownButton.h"
@interface EPPayPhoneSureVC ()<UITextFieldDelegate>


@end

@implementation EPPayPhoneSureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:2 title:@"重置密码"];
    [self addLeftItemWithFrame:CGRectMake(20,0,44,44) textOrImage:1 action:@selector(backAction) name:@"取消"];
    self.btnCode.layer.masksToBounds=YES;
    self.btnCode.layer.cornerRadius=5;
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=5;
    self.tfPhone.delegate=self;
    self.tfCode.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backAction) name:@"pass" object:nil];
}
- (void)backAction{ 
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getCodeClick:(JKCountDownButton *)sender {
    if (self.tfPhone.text.length==0||![EPTool validatePhone:self.tfPhone.text]) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
    }else{
        NSString * url=[NSString  stringWithFormat:@"%@/getSmsVaildCode.json",EPUrl];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.tfPhone.text forKey:@"phoneNo"];
        [dict setObject:@"0" forKey:@"type"];
        AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            int  returnCode=[[responseObject objectForKey:@"returnCode"] intValue];
            if (returnCode==0){
                NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                [us setValue:self.tfPhone.text forKey:@"phonePass"];
                [us synchronize];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"成功发送验证码" count:0 doWhat:nil];
                [sender startWithTime:59 title:@"重新获取" countDownTitle:@"秒后重试" mainColor:[UIColor whiteColor]  countColor:RGBColor(32, 118, 229)];
              }else if (returnCode==1){
                NSString * msg=[responseObject objectForKey:@"msg"];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else if (returnCode==2){
                NSString * msg=[responseObject objectForKey:@"msg"];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"数据获取失败，请稍后重试" count:0 doWhat:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
     }
}

- (IBAction)nextBtnClick:(id)sender {
    //下一步
    if (self.tfPhone.text.length==0||self.tfCode.text.length==0) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入完整的信息" count:0 doWhat:nil];
    }else if([EPTool validatePhone:self.tfPhone.text]){
        EPSetPass2ViewController* vc=[[EPSetPass2ViewController alloc]init];
        vc.validCode=self.tfCode.text;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
    }
}
#pragma mark----UItextField的delegate-----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==self.tfPhone)
    {
        NSInteger loc =range.location;
        if (loc < 11)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    if (textField==self.tfCode)
    {
        NSInteger loc =range.location;
        if (loc < 6)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
