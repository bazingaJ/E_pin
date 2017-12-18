//
//  EPLoginViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/4/5.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPLoginViewController.h"
#import "HeaderFile.h"
#import "AppDelegate.h"
#import "EPSettingViewController.h"
#import "EPMyViewController.h"
#import "EPSubmitController.h"
#import "EPPayPhoneSureVC.h"
#import "EPRegisterVC.h"
#import "JDPushDataTool.h"
#define nameTag 800
#define passTag  801

@interface EPLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *moveImg;
/**用户名*/
@property(nonatomic,strong)UITextField * textName;
/**密码*/
@property(nonatomic,strong)UITextField * textPass;
@property(nonatomic,assign)CGFloat maxY;
@property(nonatomic,strong)UILabel * lb1;
@property(nonatomic,strong)UILabel * lb2;
/**清除按钮*/
@property(nonatomic,strong)UIButton * clearBtn1;
@property(nonatomic,strong)UIButton * clearBtn2;

@property(nonatomic,assign)BOOL isEdit;
@end

@implementation EPLoginViewController

static NSString *path=@"myData";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /**设置导航栏*/
    [self setNav];
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [EPTool getPublicKey];
}
- (void)viewDidDisappear:(BOOL)animated{
    self.textName.text=@"";
    self.textPass.text=@"";
}
- (void)setNav{
    [self addNavigationBar:2 title:@"登录"];
    [self addLeftItemWithFrame:CGRectMake(20,0,44,44) textOrImage:1 action:@selector(backAction) name:@"取消"];
    [self addRightItemWithFrame:CGRectMake(20,0,44,44) textOrImage:1 action:@selector(registAction) name:@"注册"];
}
- (void)creatUI{
    self.moveImg.userInteractionEnabled=YES;
    CGSize nameSize=[[UIImage imageNamed:@"易品"] size];
    UIImageView * nameImg=[[UIImageView alloc]initWithFrame:CGRectMake((EPScreenW-nameSize.width)/2,70,nameSize.width,nameSize.height)];
    nameImg.image=[UIImage imageNamed:@"易品"];
    [self.moveImg addSubview:nameImg];
    for (int i=0; i<2; i++) {
        CGSize phoneSize=[[UIImage imageNamed:@"mobielphone"] size];
        CGSize passSize=[[UIImage imageNamed:@"pssword"] size];
        UILabel * lbLine=[[UILabel alloc]initWithFrame:CGRectMake(68+phoneSize.width+10, CGRectGetMaxY(nameImg.frame)+70+i*50, EPScreenW-68*2-phoneSize.width-5, 1)];
        lbLine.backgroundColor=[UIColor whiteColor];
        [self.moveImg addSubview:lbLine];
        if (i==0)
        {
            UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(68, CGRectGetMaxY(lbLine.frame)-phoneSize.height-3, phoneSize.width, phoneSize.height)];
            img.image=[UIImage imageNamed:@"mobielphone"];
            [self.moveImg addSubview:img];
        }
        if (i==1)
        {
            UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(68, CGRectGetMaxY(lbLine.frame)-passSize.height-3, passSize.width,passSize.height)];
            img.image=[UIImage imageNamed:@"pssword"];
            [self.moveImg addSubview:img];
            self.maxY=CGRectGetMaxY(img.frame);
        }
        if (i==0)
        {
            self.textName=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lbLine.frame),CGRectGetMaxY(lbLine.frame)-25-5,CGRectGetWidth(lbLine.frame)-10,30)];
            self.textName.borderStyle=UITextBorderStyleNone;
            self.textName.textColor=[UIColor whiteColor];
            self.textName.font=[UIFont systemFontOfSize:14];
            self.textName.keyboardType=UIKeyboardTypeNumberPad;
            UIColor * color=RGBColor(128, 128, 128);
            self.textName.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:color}];
            self.textName.tag=nameTag;
            self.textName.delegate=self;
            self.textName.textAlignment=NSTextAlignmentCenter;
            [self.textName addTarget:self action:@selector(changePhoneLength:) forControlEvents:UIControlEventEditingChanged];
            self.clearBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
            self.clearBtn1.frame=CGRectMake(CGRectGetMaxX(lbLine.frame)+10-30,CGRectGetMaxY(lbLine.frame)-8-22, 30, 30);
            [self.clearBtn1 setImage:[UIImage imageNamed:@"取消按钮"] forState:UIControlStateNormal];
            self.clearBtn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            [self.clearBtn1 addTarget:self action:@selector(clearBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
            self.clearBtn1.hidden=YES;
            [self.moveImg addSubview:self.clearBtn1];
            [self.moveImg addSubview:self.textName];
        }
        if (i==1)
        {
            self.textPass=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(lbLine.frame),CGRectGetMaxY(lbLine.frame)-25-5,CGRectGetWidth(lbLine.frame)-10,30)];
            self.textPass.borderStyle=UITextBorderStyleNone;
            self.textPass.font=[UIFont systemFontOfSize:14];
            self.textPass.textColor=[UIColor whiteColor];
            self.textPass.delegate=self;
            self.textPass.textAlignment=NSTextAlignmentCenter;
            UIColor * color=RGBColor(128, 128, 128);
            self.textPass.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:color}];
            self.textPass.tag=passTag;
            self.textPass.secureTextEntry=YES;
            self.textPass.keyboardType=UIKeyboardTypeNumberPad;
            [self.textPass addTarget:self action:@selector(changePassLength:) forControlEvents:UIControlEventEditingChanged];
            [self.moveImg addSubview:self.textPass];
            self.clearBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
            self.clearBtn2.frame=CGRectMake(CGRectGetMaxX(lbLine.frame)+10-30,CGRectGetMaxY(lbLine.frame)-8-22, 30, 30);
            [self.clearBtn2 setImage:[UIImage imageNamed:@"取消按钮"] forState:UIControlStateNormal];
            self.clearBtn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            [self.clearBtn2 addTarget:self action:@selector(clearBtn2Click:) forControlEvents:UIControlEventTouchUpInside];
            self.clearBtn2.hidden=YES;
            [self.moveImg addSubview:self.clearBtn2];
            
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(CGRectGetMaxX(lbLine.frame)-50, CGRectGetMaxY(lbLine.frame)+10,50,30);
            [btn setTitle:@"忘记密码?" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:10];
            btn.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;
            [btn addTarget:self action:@selector(remeberPass) forControlEvents:UIControlEventTouchUpInside];
            [self.moveImg addSubview:btn];
            
        }
    }
    //登录按钮
    CGSize logSize=[[UIImage imageNamed:@"登录"] size];
    UIButton * loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake((EPScreenW-logSize.width)/2,self.maxY+50,logSize.width,logSize.height);
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=5;
    [loginBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.moveImg addSubview:loginBtn];
}
/**点击立即登录*/
- (void)loginBtnClick
{
    [self.view endEditing:YES];
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode == 0)
        {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
        }
        else
        {
            if (self.textName.text.length==0||self.textPass.text.length==0) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"输入的用户名或者密码不能为空" count:0 doWhat:nil];
            }else if (self.textName.text.length<11||![EPTool validatePhone:self.textName.text]){
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
            }else if (self.textPass.text.length<6){
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入密码的长度不小于六位" count:0 doWhat:nil];
            }else{
                [EPTool addMBProgressWithView:self.view style:0];
                [EPTool showMBWithTitle:@"正在登陆..."];
                 NSString * pass=[EPRSA encryptString:self.textPass.text publicKey:publicKeyRSA];
                EPData * data =[EPData new];
                [data goLoginWithloginWithUserName:self.textName.text WithPsw:pass withPostType:@"0" withManual:@"1" withCompletion:^(NSString *returnCode, NSString *msg) {
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                    if ([returnCode integerValue]==0) {
                        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                        [us setValue:self.textName.text forKey:@"phoneNo"];
                        [us synchronize];
                        [self getData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"favor" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushView" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"passSuccess" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneSuccess" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"payPop" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"payRg" object:nil];
                    }else if([returnCode integerValue]==1){
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                    }else{
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题,请稍后重试" count:0 doWhat:^{
                        }];
                    }
                }];
            }
        }
    }];
}
- (void)getData
{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getPersonalInfo.json",EPUrl];
    NSDictionary * inDict=[[NSDictionary alloc]initWithObjectsAndKeys:PHONENO,@"phoneNo",LOGINTIME,@"loginTime", nil];
    [manager GET:url parameters:inDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode=[responseObject[@"returnCode"] stringValue];
        if ([returnCode isEqualToString:@"0"])
        {
            [self getVIPInfo];
            FileHander *hander = [FileHander shardFileHand];
            NSString *sss=@"ss";
            [hander saveFile:responseObject withForName:@"myData" withError:&sss];
            NSString * name=responseObject[@"name"];
            NSString *icon=responseObject[@"icon"];
            NSString *inviteCode = responseObject[@"inviteCode"];
            NSString *totalScore =responseObject[@"totalScore"];
            NSString * password=responseObject[@"isSetPayPassWord"];
            NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
            [userDef setValue:inviteCode forKey:@"inviteCode"];
            [userDef setValue:totalScore forKey:@"totalScore"];
            [userDef setValue:password forKey:@"isSetPayPassword"];
            [userDef  setObject:name forKey:@"name"];
            [userDef  setObject:icon forKey:@"icon"];
            [userDef synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",error);
         }];
}
- (void)getVIPInfo{
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getVipInfo.json",EPUrl];
    NSDictionary * inDict=[[NSDictionary alloc]initWithObjectsAndKeys:PHONENO,@"phoneNo",LOGINTIME,@"loginTime", nil];
    [manager GET:url parameters:inDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode=[responseObject[@"returnCode"] stringValue];
        if ([returnCode intValue]==0) {
            FileHander *hander = [FileHander shardFileHand];
            NSString *sss=@"ss";
            [hander saveFile:responseObject withForName:@"vipData" withError:&sss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)changePhoneLength:(UITextField *)tf{
    
    if (tf.text.length>=1)
    {
        self.clearBtn1.hidden=NO;
        self.clearBtn1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        self.clearBtn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
- (void)changePassLength:(UITextField *)tf{
    if (tf.text.length>=1)
    {
        self.clearBtn2.hidden=NO;
        self.clearBtn2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        self.clearBtn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
- (void)remeberPass{
    EPPayPhoneSureVC * vc=[[EPPayPhoneSureVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)clearBtn1Click:(UIButton *)btn{
    self.textName.text=@"";
}
- (void)clearBtn2Click:(UIButton *)btn{
    self.textPass.text=@"";
}
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
+ (void)publicDeleteInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSetPayPassWord"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"inviteCode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"totalScore"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"publicKey"];
    
}
- (void)registAction{
    EPRegisterVC * vc=[[EPRegisterVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == [self.view viewWithTag:passTag])
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
    }else if (textField == [self.view viewWithTag:nameTag])
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
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.textName)
    {
        if (self.textName.text.length>=1)
        {
            self.clearBtn1.hidden=NO;
            self.clearBtn1.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            self.clearBtn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        }
    }else
        if (self.textPass.text.length>=1)
        {
            self.clearBtn2.hidden=NO;
            self.clearBtn2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            self.clearBtn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField==self.textName)
    {
        self.clearBtn1.hidden=YES;
        
    }else{
        self.clearBtn2.hidden=YES;
        
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
