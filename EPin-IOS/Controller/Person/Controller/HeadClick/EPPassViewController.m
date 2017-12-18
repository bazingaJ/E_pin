//
//  EPPassViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/3/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPassViewController.h"
#import "HeaderFile.h"

@interface EPPassViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)EPLoginViewController * login;
@property(nonatomic,strong)UILabel * lb;


@end

@implementation EPPassViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"修改密码"];
    _login=[[EPLoginViewController alloc]init];
    //设置代理
    self.textPass.delegate=self;
    self.textInput.delegate=self;
    self.oldPass.delegate=self;
    [self.textPass addTarget:self action:@selector(changePass:) forControlEvents:UIControlEventEditingChanged];
    [self.textInput addTarget:self action:@selector(changePassAgain:) forControlEvents:UIControlEventEditingChanged];
    [self.oldPass addTarget:self action:@selector(changePassOld:) forControlEvents:UIControlEventEditingChanged];
    self.clearBtn1.hidden=YES;
    [self.clearBtn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn2.hidden=YES;
    [self.clearBtn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn3.hidden=YES;
    [self.clearBtn3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    [self tanchu];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [EPTool getPublicKey];
}
- (void)tanchu{
    UILabel * favorLb=[[UILabel alloc]initWithFrame:CGRectMake((EPScreenW-120)/2, 280, 120,30)];
    favorLb.backgroundColor=[UIColor whiteColor];
    favorLb.text=@"修改密码成功";
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
- (void)changePass:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn1.hidden=NO;
        self.clearBtn1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        self.clearBtn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    }

}
- (void)changePassAgain:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn2.hidden=NO;
        self.clearBtn2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        self.clearBtn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
- (void)changePassOld:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        
        self.clearBtn3.hidden=NO;
        self.clearBtn3.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        self.clearBtn3.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
- (void)clickBtn1:(UIButton *)btn{
       self.textPass.text=@"";
}
- (void)clickBtn2:(UIButton *)btn{
      self.textInput.text=@"";
}
- (void)clickBtn3:(UIButton *)btn{
      self.oldPass.text=@"";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//点击确认按钮
- (IBAction)isSure:(id)sender {
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode==0) {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
        }else{
            if (self.textPass.text.length==0||self.textInput.text.length==0||self.oldPass.text.length==0) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您输入的密码有空" count:0 doWhat:nil];
            }else{
                if ([self.textInput.text isEqualToString:self.oldPass.text]) {
                    if (self.textPass.text.length<6||self.oldPass.text.length<6) {
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您输入的密码长度不够" count:0 doWhat:nil];
                    }else
                    {
                        NSString * url=[NSString  stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
                        NSString *pass1=[EPRSA encryptString:self.textPass.text publicKey:publicKeyRSA];
                        NSString *pass2=[EPRSA encryptString:self.textInput.text publicKey:publicKeyRSA];
                        NSDictionary * inDic =@{@"phoneNo":PHONENO,@"password":pass1,@"newPassword":pass2,@"type":@"2",@"loginTime":LOGINTIME};
                        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
                        [manager POST:url parameters:inDic success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSString * returnCode=responseObject[@"returnCode"];
                            NSString * msg=[responseObject objectForKey:@"msg"];
                            if ([returnCode integerValue]==0)
                            {
                                [UIView animateWithDuration:.3 animations:^{
                                    _lb.alpha=1.0;
                                    _lb.hidden=NO;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:25 animations:^{
                                        _lb.alpha=0.0;
                                        _lb.hidden=YES;
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }];
                                }];
                            }else if([returnCode integerValue]==1)
                            {
                                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                                    
                                }];
                            }else  if ([returnCode integerValue]==2)
                            {
                                [EPLoginViewController publicDeleteInfo];
                                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                                    [self presentViewController:_login animated:YES completion:nil];
                                }];
                                
                            }else
                            {
                                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题,请重试" count:0 doWhat:^{
                                    
                                }];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            NSLog(@"%@",error);
                        }];
                    }
                    
                }else{
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您两次输入的密码不一致,请重新输入" count:0 doWhat:nil];
                }
                
            }
            
        }
    }];
}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
    
    return YES;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==self.textPass)
    {
        
        if (self.textPass.text.length>=1)
        {
            self.clearBtn1.hidden=NO;
            self.clearBtn1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            self.clearBtn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        }
    }
    
    if (textField==self.textInput) {
        if (self.textInput.text.length>=1)
        {
            self.clearBtn2.hidden=NO;
            self.clearBtn2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            self.clearBtn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        }
    }
    if (textField==self.oldPass)
    {
        
        if (self.textPass.text.length>=1)
        {
            self.clearBtn3.hidden=NO;
            self.clearBtn3.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            self.clearBtn3.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField==self.textPass)
    {
        self.clearBtn1.hidden=YES;
        
    }
    if (textField==self.textInput)
    {
        self.clearBtn2.hidden=YES;
        
    }
    if (textField==self.oldPass)
    {
        self.clearBtn3.hidden=YES;
        
    }
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
