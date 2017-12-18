//
//  EPRegisterVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/7/6.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPRegisterVC.h"
#import "HeaderFile.h"
@interface EPRegisterVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *textName;

@property (weak, nonatomic) IBOutlet UITextField *textSureCode;
@property (weak, nonatomic) IBOutlet UITextField *textPass;
@property (weak, nonatomic) IBOutlet UITextField *textCode;

@property (weak, nonatomic) IBOutlet UIButton *regBtn;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn1;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn2;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn3;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn4;

@end

@implementation EPRegisterVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //按钮切圆角
    self.regBtn.layer.masksToBounds=YES;
    self.regBtn.layer.cornerRadius=5.0;

    self.codeBtn.layer.masksToBounds=YES;
    self.codeBtn.layer.cornerRadius=5.0;
    [self addNavigationBar:2 title:@"注册"];
    [self addRightItemWithFrame:CGRectMake(20,0,44,44) textOrImage:1 action:@selector(loginAction) name:@"登录"];
    [self setTextPass];
    if (EPScreenW<=320) {
        //键盘弹出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //键盘隐藏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}
//键盘出现
- (void)keyBoardWillShow:(NSNotification *)no{
    for (UIView * vc in self.view.subviews) {
        
        if (vc.y==0||vc.height==44) {
            //不变
        }else{
            vc.y=vc.y-60;
        }
    }
}
//键盘隐藏
- (void)keyBoardWillHide:(NSNotification *)no{
    for (UIView * vc in self.view.subviews) {
        if (vc.y==0||vc.height==44) {
            //不变
        }else{
            vc.y=vc.y+60;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [EPTool getPublicKey];
}
//获取验证码
- (IBAction)getCodeClick:(UIButton *)sender {
    if (self.textName.text.length==0||![EPTool validatePhone:self.textName.text]||self.textName.text.length<11) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
    }else{
        NSString * url=[NSString  stringWithFormat:@"%@/getSmsVaildCode.json",EPUrl];
        NSDictionary * dict =@{@"phoneNo":self.textName.text,@"type":@"3"};
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        [manager GET:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            //NSLog(@"注册====%@",responseObject);
            NSString * returnCode=[[responseObject objectForKey:@"returnCode"] stringValue];
            if ([returnCode isEqualToString:@"0"])
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"成功发送验证码" count:0 doWhat:nil];
                [sender startWithTime:59 title:@"重新获取" countDownTitle:@"秒后重试" mainColor:nil  countColor:nil];
            }else if ([returnCode isEqualToString:@"1"])
            {
                NSString * msg=[responseObject objectForKey:@"msg"];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else if ([returnCode isEqualToString:@"2"])
            {
                NSString * msg=[responseObject objectForKey:@"msg"];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"数据获取失败，请稍后重试" count:0 doWhat:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }

}
- (IBAction)regBtnClick:(UIButton *)sender {
    /**1.判断是否输入有空*/
    if (self.textName.text.length==0||self.textPass.text.length==0||self.textSureCode.text.length==0) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"输入的内容不能为空" count:0 doWhat:nil];
    }else{
        /**2.判断是否是手机号*/
        if(![EPTool validatePhone:self.textName.text]||self.textName.text.length<11){
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
        }else {
            if(self.textPass.text.length<6){
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"密码的长度不能小于6位" count:0 doWhat:nil];
            }else{
                NSString * url=[NSString  stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
                NSString * pass=[EPRSA encryptString:self.textPass.text publicKey:publicKeyRSA];
                NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:self.textName.text,@"phoneNo",pass,@"password",self.textSureCode.text,@"validCode",self.textCode.text,@"invitationCode",@"6",@"type",nil];
                AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
                [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString * returnCode=[[responseObject objectForKey:@"returnCode"] stringValue];
                    if ([returnCode isEqualToString:@"0"])
                    {
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"注册成功" count:0 doWhat:^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }else  if ([returnCode isEqualToString:@"1"])
                    {
                        NSString * msg=[responseObject objectForKey:@"msg"];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                    }else  if ([returnCode isEqualToString:@"2"])
                    {
                        NSString * msg=[responseObject objectForKey:@"msg"];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                    }else{
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题,请重试" count:0 doWhat:nil];
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        }
    }
}
- (void)setTextPass{
    self.textPass.secureTextEntry=YES;
    self.textName.delegate=self;
    self.textSureCode.delegate=self;
    self.textCode.delegate=self;
    self.textPass.delegate=self;
    UIColor * color=RGBColor(128, 128, 128);
    self.textName.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:color}];
    self.textSureCode.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:color}];
    self.textPass.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"密  码" attributes:@{NSForegroundColorAttributeName:color}];
    self.textCode.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"邀请码" attributes:@{NSForegroundColorAttributeName:color}];
    //改变
    [self.textName addTarget:self action:@selector(changePhone:) forControlEvents:UIControlEventEditingChanged];
    [self.textSureCode addTarget:self action:@selector(changeSureCode:) forControlEvents:UIControlEventEditingChanged];
    [self.textPass addTarget:self action:@selector(changePass:) forControlEvents:UIControlEventEditingChanged];
    [self.textCode addTarget:self action:@selector(changeCode:) forControlEvents:UIControlEventEditingChanged];
    
    self.clearBtn1.hidden=YES;
    [self.clearBtn1 addTarget:self action:@selector(clickClearBtn1:) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn2.hidden=YES;
    [self.clearBtn2 addTarget:self action:@selector(clickClearBtn2:) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn3.hidden=YES;
    [self.clearBtn3 addTarget:self action:@selector(clickClearBtn3:) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn4.hidden=YES;
    [self.clearBtn4 addTarget:self action:@selector(clickClearBtn4:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)changePhone:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn1.hidden=NO;
    }
}
- (void)changeSureCode:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn2.hidden=NO;
        
    }
}
- (void)changePass:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn3.hidden=NO;
        
    }
}

- (void)changeCode:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn4.hidden=NO;
    }
}
- (void)clickClearBtn1:(UIButton *)btn{
    
    self.textName.text=@"";
}
- (void)clickClearBtn2:(UIButton *)btn{
    
    self.textSureCode.text=@"";
}
- (void)clickClearBtn3:(UIButton *)btn{
    
    self.textPass.text=@"";
}
- (void)clickClearBtn4:(UIButton *)btn{
    
    self.textCode.text=@"";
}
#pragma MARK------UITextField的协议方法------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textPass){
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
    if (textField == self.textName){
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
    if (textField == self.textSureCode){
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
    if (textField == self.textCode){
        NSInteger loc =range.location;
        if (loc < 8)
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.textName)
    {
        
        if (self.textName.text.length>=1)
        {
            self.clearBtn1.hidden=NO;
            
        }
    }
    
    if (textField==self.textSureCode) {
        if (self.textSureCode.text.length>=1)
        {
            self.clearBtn2.hidden=NO;
        }
    }
    if (textField==self.textPass) {
        if (self.textPass.text.length>=1)
        {
            self.clearBtn3.hidden=NO;
        }
    }
    if (textField==self.textCode) {
        if (self.textCode.text.length>=1)
        {
            self.clearBtn4.hidden=NO;
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField==self.textName)
    {
        self.clearBtn1.hidden=YES;
        
    }
    if (textField==self.textSureCode)
    {
        self.clearBtn2.hidden=YES;
        
    }
    if (textField==self.textPass)
    {
        self.clearBtn3.hidden=YES;
        
    }
    if (textField==self.textCode)
    {
        self.clearBtn4.hidden=YES;
        
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)loginAction{
    //跳转到登录界面
    [self dismissViewControllerAnimated:YES completion:nil];
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
