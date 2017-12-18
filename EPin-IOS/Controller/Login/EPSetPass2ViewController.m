//
//  EPSetPass2ViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/4/18.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSetPass2ViewController.h"
#import "HeaderFile.h"
@interface EPSetPass2ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *againPass;

@property (weak, nonatomic) IBOutlet UIButton *setBtn;


@end

@implementation EPSetPass2ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=RGBColor(234, 234, 234);
    [self addNavigationBar:2 title:@"重置密码"];
    [self addLeftItemWithFrame:CGRectMake(20,0,44,44) textOrImage:1 action:@selector(backAction) name:@"取消"];
    self.password.delegate=self;
    self.againPass.delegate=self;
    
    self.password.secureTextEntry=YES;
    self.againPass.secureTextEntry=YES;
    self.setBtn.layer.masksToBounds=YES;
    self.setBtn.layer.cornerRadius=5;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [EPTool getPublicKey];
}
- (IBAction)submitBtnClick:(id)sender {
    //1.先判断密码输入
    if (self.password.text.length==0||self.againPass.text.length==0)
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您输入的密码有空" count:0 doWhat:nil];
    }else  if(self.password.text.length<6)
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您输入的密码长度不够" count:0 doWhat:nil];
    }else if ([self.password.text isEqualToString:self.againPass.text])
    {
        NSString * url=[NSString  stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
        NSString *pass=[EPRSA encryptString:self.password.text publicKey:publicKeyRSA];
        NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:PHONEPASS,@"phoneNo",pass,@"newPassword",self.validCode,@"validCode",@"3",@"type",nil];
        //NSLog(@"dict=====%@",dict);
        AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // NSLog(@"找回密码======%@",responseObject);
            int  returnCode=[[responseObject objectForKey:@"returnCode"] intValue];
            if (returnCode==0)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pass" object:nil];
                }];
            }else if (returnCode==1)
            {
                NSString * msg=[responseObject objectForKey:@"msg"];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else if (returnCode==2)
            {
                NSString * msg=[responseObject objectForKey:@"msg"];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题,请重试" count:0 doWhat:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您两次输入的密码不一致" count:0 doWhat:nil];
    }
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--------textField的协议方法----------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.password){
        NSInteger loc =range.location;
        if (loc < 6)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else{
        if (textField == self.againPass){
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
    }
    return NO;
    
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
