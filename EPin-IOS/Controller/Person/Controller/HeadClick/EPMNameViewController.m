//
//  EPMNameViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/3/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMNameViewController.h"
#import "HeaderFile.h"
@interface EPMNameViewController ()

@property(nonatomic,strong)EPLoginViewController * login;

@end

@implementation EPMNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNav];
    _login=[[EPLoginViewController alloc]init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.textName becomeFirstResponder];
     self.textName.text=NAME;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    self.textName.text=@"";
}
- (void)setNav{
    [self addNavigationBar:0 title:@"更改昵称"];
    [self addRightItemWithFrame:CGRectZero textOrImage:0 action:@selector(saveAction) name:@"保存"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textName resignFirstResponder];
}
//保存昵称
- (void)saveAction{
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode==0) {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
        
        }else{
            if (self.textName.text.length==0)
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"昵称不能为空" count:0 doWhat:^{
                    
                }];
            }else
            {
                if (self.returnTextBlock != nil)
                {
                    self.returnTextBlock(self.textName.text);
                }
                NSUserDefaults * us=[NSUserDefaults standardUserDefaults];
                [us setObject:self.textName.text forKey:@"name"];
                [us synchronize];
                
                [self postNameData];
            }
        }
    }];
}
- (void)postNameData{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/changePersonalInfo.json",EPUrl];
    NSDictionary * dict=@{@"type":@"1",@"phoneNo":PHONENO,@"newPhoneNo":PHONENO,@"loginTime":LOGINTIME,@"newName":self.textName.text};
    [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"修改昵称-------%@",responseObject);
        NSString * returnCode=responseObject[@"returnCode"];
        if ([returnCode integerValue]==0)
        {
            NSUserDefaults * us=[NSUserDefaults standardUserDefaults];
            [us setObject:self.textName.text forKey:@"name"];
            [us synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }if ([returnCode integerValue]==2)
        {
            NSString * msg=[responseObject objectForKey:@"msg"];
            [EPLoginViewController publicDeleteInfo];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [self presentViewController:_login animated:YES completion:nil];
            }];
        }else
        {
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的网络有点问题，请稍后重试" count:0 doWhat:^{
                
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//实现回调昵称方法
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
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
