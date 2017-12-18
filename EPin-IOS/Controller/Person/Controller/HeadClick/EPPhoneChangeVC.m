//
//  EPPhoneChangeVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPhoneChangeVC.h"
#import "HeaderFile.h"
#import "EPPhoneGetCodeVC.h"
@interface EPPhoneChangeVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passTf;

@property (weak, nonatomic) IBOutlet UILabel *errorLb;



@end

@implementation EPPhoneChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"更改手机号"];
    self.passTf.delegate=self;
    self.passTf.layer.masksToBounds=YES;
    self.passTf.layer.cornerRadius=5;
    [self.passTf addTarget:self action:@selector(changePassLength:) forControlEvents:UIControlEventEditingChanged];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.passTf becomeFirstResponder];
    [EPTool getPublicKey];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.errorLb.text=@"";
}
- (void)changePassLength:(UITextField *)tf{
    if (tf.text.length==6) {
        NSString * url=[NSString  stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
        NSString * pass=[EPRSA encryptString:self.passTf.text publicKey:publicKeyRSA];
        NSDictionary * dict=@{@"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"password":pass,
                              @"type":@"7"};
        //NSLog(@"dict===%@",dict);
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString * returnCode=responseObject[@"returnCode"];
            NSString * msg=responseObject[@"msg"];
            if ([returnCode integerValue]==0) {
                EPPhoneGetCodeVC * vc=[[EPPhoneGetCodeVC alloc]init];
                vc.pass=pass;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([returnCode integerValue]==1){
                self.errorLb.text=@"密码错误";
            }else if ([returnCode integerValue]==2){
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
    }else{
        //继续输入
    }
    
}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==self.passTf)
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
