//
//  EPPhoneGetCodeVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPhoneGetCodeVC.h"
#import "HeaderFile.h"
@interface EPPhoneGetCodeVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property(nonatomic,strong)EPLoginViewController * login;
@property(nonatomic,strong)UILabel * lb;

@end

@implementation EPPhoneGetCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"更改手机号"];
    self.tfNewPhone.delegate=self;
    self.tfCode.delegate=self;
    self.codeBtn.layer.masksToBounds=YES;
    self.codeBtn.layer.cornerRadius=10;
    self.tfNewPhone.layer.masksToBounds=YES;
    self.tfNewPhone.layer.cornerRadius=5;
    self.tfCode.layer.masksToBounds=YES;
    self.tfCode.layer.cornerRadius=5;
    _login=[[EPLoginViewController alloc]init];
    [self tanchu];
}
- (void)tanchu{
    UILabel * favorLb=[[UILabel alloc]initWithFrame:CGRectMake((EPScreenW-120)/2, 280, 120,30)];
    favorLb.backgroundColor=[UIColor whiteColor];
    favorLb.text=@"换绑手机成功";
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
/**获取验证码*/
- (IBAction)getCodeClick:(id)sender {
    if (self.tfNewPhone.text.length==0||![EPTool validatePhone:self.tfNewPhone.text]) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号码" count:0 doWhat:nil];
    }else{
        NSString * url=[NSString  stringWithFormat:@"%@/getSmsVaildCode.json",EPUrl];
        NSDictionary * dict=@{@"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"newPhoneNo":self.tfNewPhone.text,
                              @"type":@"2"};
        //NSLog(@"dict===%@",dict);
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        [manager GET:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
           // NSLog(@"%@",responseObject);
            int returnCode=[responseObject[@"returnCode"] intValue];
            NSString * msg=responseObject[@"msg"];
            if (returnCode==0) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"成功发送验证码" count:0 doWhat:nil];
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            }else if (returnCode==1){
                 [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else if (returnCode==2){
                [EPLoginViewController publicDeleteInfo];
                EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                    [self presentViewController:vc animated:YES completion:nil];
                }];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络连接失败" count:0 doWhat:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
}
/**提交新手机号*/
- (IBAction)submitBtnClick:(id)sender {
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode==0) {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
        }else{
            if (self.tfNewPhone.text.length==0||self.tfCode.text.length==0||![EPTool validatePhone:self.tfNewPhone.text]) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请填写正确的信息" count:0 doWhat:nil];
            }else{
                NSString * url=[NSString  stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
                NSDictionary * dict=@{@"phoneNo":PHONENO,
                                      @"loginTime":LOGINTIME,
                                      @"newPhoneNo":self.tfNewPhone.text,
                                      @"password":self.pass,
                                      @"validCode":self.tfCode.text,
                                      @"type":@"1"};
                // NSLog(@"dict-----%@",dict);
                AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
                [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                    int returnCode=[responseObject[@"returnCode"] intValue];
                    NSString * msg=responseObject[@"msg"];
                    if (returnCode==0) {
                        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                        [us setValue:self.tfNewPhone.text forKey:@"phoneNo"];
                        [us synchronize];
                        [UIView animateWithDuration:.3 animations:^{
                            _lb.alpha=1.0;
                            _lb.hidden=NO;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:25 animations:^{
                                _lb.alpha=0.0;
                                _lb.hidden=YES;
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }];
                        }];
                    }else if (returnCode==1){
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                    }else if (returnCode==2){
                        [EPLoginViewController publicDeleteInfo];
                        EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                            [self presentViewController:vc animated:YES completion:nil];
                        }];
                    }else{
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络连接失败,请稍后重试" count:0 doWhat:nil];
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }
            
        }
    }];
}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.tfNewPhone)
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
    return NO;
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
