//
//  SettingViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/4/2.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSettingViewController.h"
#import "HeaderFile.h"
#import "EPLoginViewController.h"
#import "SDImageCache.h"
#import "EPTool.h"
#import "EPAboutUsViewController.h"
#import "JDPushDataTool.h"
@interface EPSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * titles;

@end

@implementation EPSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"设 置"];
    [self prepareForView];
    [self prepareForData];
    
    //退出登录按钮
    [self.exitBtn addTarget:self action:@selector(exitClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popView) name:@"popView" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LOGINTIME==nil) {
        self.exitBtn.hidden=YES;
        self.exitBtn.alpha=0;
    }else{
        self.exitBtn.hidden=NO;
    }
}
//登录
- (void)exitClickBtn{
    UIAlertController * alertControl=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
            if (statusCode == 0)
            {
                //当前网络不可用
                [EPLoginViewController publicDeleteInfo];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"exit" object:nil];
            }
            else
            {
                AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
                manager.responseSerializer=[AFJSONResponseSerializer serializer];
                NSString * str =[NSString stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
                NSDictionary * inDic=@{@"phoneNo":PHONENO,@"type":@"5",@"loginTime":LOGINTIME,@"app":@"1"};
                [manager POST:str parameters:inDic success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString * returnCode=[responseObject[@"returnCode"] stringValue];
                    NSString * msg=responseObject[@"msg"];
                    if ([returnCode intValue]==0) {
                        [EPLoginViewController publicDeleteInfo];
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"exit" object:nil];
                        
                    }else if ([returnCode intValue]==1){
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                    }else if ([returnCode intValue]==2){
                         [EPLoginViewController publicDeleteInfo];
                         [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                         EPLoginViewController * VC=[[EPLoginViewController alloc]init];
                         [self presentViewController:VC animated:YES completion:nil];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@",error);
                }];
                
 
            }
        }];
    }];
    
    [alertControl addAction:cancel];
    [alertControl addAction:actionOK];
    [self presentViewController:alertControl animated:YES completion:nil];
}
- (void)popView
{
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)prepareForView
{
    self.tableVi.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    self.exitBtn.layer.masksToBounds=YES;
    self.exitBtn.layer.cornerRadius=5;
}
- (void)prepareForData
{
    self.titles=[[NSMutableArray alloc]initWithObjects:@"消息推送",@"清除缓存", nil];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier =@"identifier";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"清除缓存";
     }else{
        cell.textLabel.text=@"关于我们";
     }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"你确定要清理缓存" count:1 doWhat:^{
                [[SDImageCache sharedImageCache] clearDisk];
                
                [[SDImageCache sharedImageCache] clearMemory];//可有可无
                
                NSLog(@"clear disk");
                
                float tmpSize = [[SDImageCache sharedImageCache]getSize];
                NSLog(@"getsize %f",tmpSize);
                //            NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
                if (tmpSize==0.0f)
                {
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"清理完成!" count:0 doWhat:nil];
                }
            }];
            
        }
            break;
        case 1:{
            //关于我们
            EPAboutUsViewController * vc=[[EPAboutUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
