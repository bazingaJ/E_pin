//
//  EPNowTableVC.m
//  EPin-IOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPNowTableVC.h"
#import "EPCallCarCell.h"
#import "EPAddressVC.h"
#import "EPData.h"
#import "EPTool.h"
#import "JCAlertView.h"
#import "EPFaresController.h"


@interface EPNowTableVC ()
{
    JCAlertView *_alert;

    NSInteger num;
    
    dispatch_source_t timer3;
    
    UIImageView * carMoveVi;//------>司机接单之后的动画
    
    UIImageView * mapMoveVi;//------>等待司机接单的动画
    
    UIImageView * onCarMoveVi;//---->行程中
}
@property (nonatomic, strong) NSString * statusStr;              //订单状态码
@property (nonatomic, strong) NSString * numberStr;              //订单编号

@property (nonatomic, strong) UILabel * countingLabel;
@property (nonatomic, strong) NSMutableDictionary * detailedDic;
@property (nonatomic, strong) NSDictionary * driverDic;   //查看召车司机详情的字典
@end

@implementation EPNowTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:@"sendNowMessage" object:nil];//-----改变单元格状态和信息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"callCarNotice" object:nil];//------司机现在召车接单
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeStyle) name:@"upCarNotice" object:nil];//-----司机点击乘客上车
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moneyPay) name:@"finishCallCar" object:nil];//-----司机点击现金支付
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLocation:) name:@"nowLocation" object:nil];//----系统定位之后回传的地址
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //从本地取召车详情
    NSString * filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/detail.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        self.detailedDic=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else
    {
        self.detailedDic=[NSMutableDictionary dictionary];
    }
    //从本地区司机详情
    NSString * filePa =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/driverInfo.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePa])
    {
        self.driverDic=[NSMutableDictionary dictionaryWithContentsOfFile:filePa];
    }
    else
    {
        self.driverDic=[NSMutableDictionary dictionary];
    }
    
//    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //对时间的处理
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isActive"])
    {
        NSString * beforeTimeStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"timeInterval"];
        NSString * nowTimeStr =[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
        NSInteger interval =[nowTimeStr integerValue]-[beforeTimeStr integerValue];
        NSString * before =[[NSUserDefaults standardUserDefaults]objectForKey:@"text"];
        NSRange minuteR = NSMakeRange(7, 2);
        NSRange secondR = NSMakeRange(10, 2);
        NSString * e =[before substringWithRange:minuteR];
        NSString * f =[before substringWithRange:secondR];
        NSInteger intervalBase =[e integerValue]*60+[f integerValue];
        
        num=interval+intervalBase;
        NSString * minuteStr =[NSString stringWithFormat:@"%02ld",(long)num/60];
        NSString * secondStr = [NSString stringWithFormat:@"%02ld",(long)num%60];
        self.countingLabel.text = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
        [self countingBegin];
    }
//    [self.tableView reloadData];
}
//界面将要消失的动作
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString * timeStr =[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    
    NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
    [us setObject:timeStr forKey:@"timeInterval"];
    [us setObject:self.countingLabel.text forKey:@"text"];
    [us synchronize];
    
}

#pragma mark-  GCD 计时
//让计时开始
- (void)countingBegin
{
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer3 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer3, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer3, ^{
        //在这里执行事件
        
        [self myTimerAction];
    });
    
    dispatch_resume(timer3);
    
    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    [us setBool:YES forKey:@"isActive"];
    [us synchronize];
}
- (void)myTimerAction
{
    num ++;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * minute =[NSString stringWithFormat:@"%02ld",(long)num/60];
        NSString * second = [NSString stringWithFormat:@"%02ld",(long)num%60];
        self.countingLabel.text = [NSString stringWithFormat:@"等待司机接单(%@:%@)",minute,second];
    });
}
- (void)cancelTimer
{
    NSLog(@"aaa");
    dispatch_cancel(timer3);
    timer3=nil;
    num=0;
    self.countingLabel.text = @"00:00";
    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    [us setBool:NO forKey:@"isActive"];
    [us synchronize];
}


#pragma mark-
#pragma mark 接收通知 刷新状态
//通知传值过来
- (void)getData:(NSNotification *)noti
{
    self.fileDic=noti.userInfo;
    NSString * status=self.fileDic[@"status"];
    if (!status)
    {
        self.statusStr=@"0";
    }
    else
    {
        self.statusStr=[NSString stringWithFormat:@"%d",[status intValue]+1];
    }
    self.numberStr=self.fileDic[@"orderId"];
    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    [us setObject:self.fileDic[@"orderId"] forKey:@"ooooorderId"];
    [us synchronize];
    if ([_statusStr intValue]==6)
    {
        EPFaresController * vc =[[EPFaresController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    if ([_statusStr intValue]==3)
    {
        self.statusStr=@"6";
    }
    [self.tableView reloadData];
    
}

//司机接单刷新
- (void)refreshData
{
    self.statusStr=@"2";
    [self requestWithDriverInfo];
    [self.tableView reloadData];
}
//司机点击上车
- (void)changeStyle
{
    self.statusStr=@"6";
    [self.tableView reloadData];
}
//司机点击现金支付
- (void)moneyPay
{
    self.statusStr=@"0";
    [self.tableView reloadData];
}
- (void)userLocation:(NSNotification *)noti
{
    NSString * location=noti.userInfo[@"nowLocation"];
    [self.nowLocation setTitle:location forState:UIControlStateNormal];
}
//获取信息 刷新方法
- (void)requestWithDriverInfo
{
    EPData * data=[EPData new];
    [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"0" WhatToDo:@"0" withOrderNumber:@"" withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
            NSArray * arr =dic[@"getCallCarArr"];
            for (NSDictionary * smallDic in arr)
            {
                NSString * orderType =smallDic[@"useType"];
                if ([orderType intValue]==0)
                {
                    [self cancelTimer];
                    self.driverDic=smallDic;
                    NSString * filePa =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/driverInfo.plist"];
                    [self.driverDic writeToFile:filePa atomically:YES];
                }
            }
        } WithReturnCodeEqualToOneBlock:nil];
    }];
}
#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPCallCarCell * cell1 =nil;
    EPCallCarCell * cell2 =nil;
    EPCallCarCell * cell3 =nil;
    EPCallCarCell * cell4 =nil;
    if ([self.statusStr intValue]==0)
    {
        if (!cell1)
        {
            cell1=[[[NSBundle mainBundle]loadNibNamed:@"EPCallCarCell" owner:nil options:nil]objectAtIndex:0];
            
        }
        self.nowLocation=cell1.upCarBtn;
        
        [self.nowLocation addTarget:self action:@selector(searchLo:) forControlEvents:UIControlEventTouchUpInside];
        
        self.destination = cell1.destinetionBtn;
        [self.destination addTarget:self action:@selector(searchLo:) forControlEvents:UIControlEventTouchUpInside];

        NSString * upCarStr  =[[NSUserDefaults standardUserDefaults]objectForKey:@"upCarLocation"];
        NSString * upCar  =[[NSUserDefaults standardUserDefaults]objectForKey:@"nowLocation"];
        if (upCar.length != 0)
        {
            [self.nowLocation setTitle:upCar forState:UIControlStateNormal];
            
        }
        if (upCarStr.length != 0)
        {
            [self.nowLocation setTitle:upCarStr forState:UIControlStateNormal];
        }
        NSString * destinationStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"destinationLocation"];
        if (destinationStr.length != 0)
        {
            [self.destination setTitle:destinationStr forState:UIControlStateNormal];
        }
        
        [cell1.containBtn addTarget:self action:@selector(containBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell1;
    }
    if ([self.statusStr intValue]==1)
    {
        if (!cell2)
        {
            cell2=[[[NSBundle mainBundle]loadNibNamed:@"EPCallCarCell" owner:nil options:nil]objectAtIndex:1];
        }
        self.countingLabel=cell2.countingLab;
        mapMoveVi=cell2.mapAnimationVi;
        [self animationWithView:mapMoveVi WithImageName:@"map" WithNmuber:7 WithDuration:.8];
        [cell2.detailBtn addTarget:self action:@selector(seeDetail) forControlEvents:UIControlEventTouchUpInside];
        [cell2.cancelBtn addTarget:self action:@selector(containBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell2;
    }
    if ([self.statusStr intValue]==2)
    {
        if (!cell3)
        {
            cell3=[[[NSBundle mainBundle]loadNibNamed:@"EPCallCarCell" owner:nil options:nil]objectAtIndex:2];
            
        }
        carMoveVi=cell3.carAnimationVi;
        [self animationWithView:carMoveVi WithImageName:@"car" WithNmuber:3 WithDuration:0.2];
        [cell3.driverDetail addTarget:self action:@selector(seeDriverInfo) forControlEvents:UIControlEventTouchUpInside];
        [cell3.cancelButton addTarget:self action:@selector(containBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell3;
    }
    if ([self.statusStr intValue]==6)
    {
        if (!cell4)
        {
            cell4=[[[NSBundle mainBundle]loadNibNamed:@"EPCallCarCell" owner:nil options:nil]objectAtIndex:4];
            
        }
        onCarMoveVi= cell4.onCarImageVi;
        [self animationWithView:onCarMoveVi WithImageName:@"on" WithNmuber:12 WithDuration:1];
        return cell4;
    }
    return cell1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 330;
}


//帧动画开始设置
- (void)animationWithView:(UIImageView *)view WithImageName:(NSString *)name WithNmuber:(int)quantity WithDuration:(CGFloat)duration
{
    view.animationDuration=duration;
    NSMutableArray * imageArr =[[NSMutableArray alloc] init];
    for (int i = 1; i < (quantity+1); i++)
    {
        NSString * imageName = [NSString stringWithFormat:@"%@%d.png",name,i];
        UIImage * image = [UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    view.animationImages=imageArr;
    view.animationRepeatCount=0;
    [view startAnimating];
}
//帧动画停止方法
- (void)cancelaAnimationWithImageView:(UIImageView *)imageView
{
    if (imageView.isAnimating)
    {
        [imageView stopAnimating];
    }else
    {
        [imageView startAnimating];
    }
}


//跳转搜索界面
- (void)searchLo:(UIButton *)btn
{
    EPAddressVC * vc =[[EPAddressVC alloc] init];
    if (btn.tag==101)
    {
        vc.isUp=YES;
        vc.isOrder=NO;
        vc.nowViewCon=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag==102)
    {
        vc.isUp=NO;
        vc.isOrder=NO;
        vc.nowViewCon=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//弹出查看召车详情弹窗
- (void)seeDetail
{
    //设置一个弹窗的自定义view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 225)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.masksToBounds=YES;
    customView.layer.cornerRadius=5;
    //设置标题
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    titleLab.backgroundColor=RGBColor(29, 32, 40);
    titleLab.text=@"召车详情";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=RGBColor(218, 187, 132);
    [customView addSubview:titleLab];
    
    UILabel * upTime =[[UILabel alloc] initWithFrame:CGRectMake(10, 55, 270, 25)];
    upTime.text=@"上车时间: 现在";
    upTime.font=[UIFont systemFontOfSize:16];
    upTime.textColor=[UIColor blackColor];
    [customView addSubview:upTime];
    
    UILabel * local =[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 270, 25)];
    local.text=[NSString stringWithFormat:@"起点: %@",self.detailedDic[@"local"]];
    local.font=[UIFont systemFontOfSize:16];
    local.numberOfLines=0;
    local.textColor=[UIColor blackColor];
    [customView addSubview:local];
    
    UILabel * destination =[[UILabel alloc] initWithFrame:CGRectMake(10, 135, 270, 25)];
    destination.text=[NSString stringWithFormat:@"终点: %@",self.detailedDic[@"destination"]];
    destination.font=[UIFont systemFontOfSize:16];
    destination.numberOfLines=0;
    destination.textColor=[UIColor blackColor];
    [customView addSubview:destination];
    
    //设置按钮上边的分割线
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 174, 300, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    [customView addSubview:lineView];
    //设置最下边的按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 175, 300, 50)];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:19];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [customView addSubview:btn];
    [btn addTarget:self action:@selector(knownIts) forControlEvents:UIControlEventTouchUpInside];
    
    _alert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [_alert show];
}
//点击知道了按钮消失弹窗
- (void)knownIts
{
    [_alert dismissWithCompletion:nil];
}
//跳出查看司机详情的弹窗
- (void)seeDriverInfo
{
    //设置一个弹窗的自定义view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 225)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.masksToBounds=YES;
    customView.layer.cornerRadius=5;
    //设置标题
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    titleLab.backgroundColor=RGBColor(29, 32, 40);
    titleLab.text=@"司机详情";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=RGBColor(218, 187, 132);
    [customView addSubview:titleLab];
    
    UILabel * upTime =[[UILabel alloc] initWithFrame:CGRectMake(10, 55, 270, 25)];
    upTime.text=[NSString stringWithFormat:@"车牌号码:   %@",self.driverDic[@"licenseNo"]];
    upTime.font=[UIFont systemFontOfSize:16];
    upTime.textColor=[UIColor blackColor];
    [customView addSubview:upTime];
    
    UILabel * local =[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 70, 25)];
    local.text=@"联系方式:";
    local.font=[UIFont systemFontOfSize:16];
    local.textColor=[UIColor blackColor];
    [customView addSubview:local];
    
    UIButton * contact =[UIButton buttonWithType:UIButtonTypeCustom];
    contact.frame=CGRectMake(10, 95, 270, 25);
    NSString * text =[NSString stringWithFormat:@"%@",self.driverDic[@"driverPhoneNo"]];
    [contact setTitle:text forState:UIControlStateNormal];
    contact.titleLabel.font=[UIFont systemFontOfSize:16];
    contact.titleLabel.numberOfLines=0;
    [contact addTarget:self action:@selector(callDriver:) forControlEvents:UIControlEventTouchUpInside];
    [contact setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [customView addSubview:contact];
    
    UILabel * destination =[[UILabel alloc] initWithFrame:CGRectMake(10, 135, 270, 25)];
    destination.text=[NSString stringWithFormat:@"所属公司:   %@",self.driverDic[@"companyName"]];
    destination.font=[UIFont systemFontOfSize:16];
    destination.numberOfLines=0;
    destination.textColor=[UIColor blackColor];
    [customView addSubview:destination];
    
    //设置按钮上边的分割线
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 174, 300, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    [customView addSubview:lineView];
    //设置最下边的按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 175, 300, 50)];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:19];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [customView addSubview:btn];
    [btn addTarget:self action:@selector(knownIts) forControlEvents:UIControlEventTouchUpInside];
    
    _alert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [_alert show];
}
//调拨打电话功能
- (void)callDriver:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",btn.currentTitle];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}
//确定叫车按钮点击事件
- (void)containBtnClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 103:
        {
            [self containCallCarButton];
        }
            break;
        case 222:
        {
            [self cancelCallCarBtnClickWith:0];
        }
            break;
        case 333:
        {
            [self cancelCallCarBtnClickWith:1];
        }
            break;
            
        default:
            break;
        }
}
//确认叫车按钮的点击事件绑定
- (void)containCallCarButton
{
    if (![self.nowLocation.currentTitle isEqualToString:@"选择起点"] && ![self.destination.currentTitle isEqualToString:@"选择终点"])
    {
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@"正在提交"];
        EPData * data =[EPData new];
        //OrderId 存一下
        NSString * uuidStr =[data getUniqueStrByUUID];
        NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
        [us setObject:uuidStr forKey:@"orderIDStr"];
        [us synchronize];
        
        NSString * year =[self getWholeTime];
        [data getCallCarDataWithGetCarTime:year WithGetCarAddress:self.nowLocation.currentTitle WtihDestination:self.destination.currentTitle WithContect:@"" WithUserType:@"0" WhatToDo:@"1" withOrderNumber:uuidStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic)
         {
             [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                 [self countingBegin];
                 self.detailedDic[@"local"]=self.nowLocation.currentTitle;
                 self.detailedDic[@"destination"]=self.destination.currentTitle;
                 NSString * filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/detail.plist"];
                 [self.detailedDic writeToFile:filePath atomically:YES];
                 
                 [self.nowLocation setTitle:@"" forState:UIControlStateNormal];
                 [self.destination setTitle:@"" forState:UIControlStateNormal];
                 NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                 [us setObject:@"" forKey:@"upCarLocation"];
                 [us setObject:@"" forKey:@"destinationLocation"];
                 [us synchronize];
                 self.statusStr=@"1";
                 self.numberStr=dic[@"orderId"];
                 [EPTool hiddenMBWithDelayTimeInterval:0];
                 [self.tableView reloadData];
             } WithReturnCodeEqualToOneBlock:nil];
        }];
    }
    else
    {
        [EPTool addAlertViewInView:self title:@"提示" message:@"请确认您的位置信息正确" count:0 doWhat:nil];
    }
}

/**
 取消预约按钮点击事件

 @param style 司机未接单取消：0  司机已经接单取消：1
 */
- (void)cancelCallCarBtnClickWith:(NSInteger)style
{
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您确定要取消吗" count:1 doWhat:^{
        EPData * data =[EPData new];
        [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"" WhatToDo:@"2" withOrderNumber:self.numberStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                if (style == 0)
                {
                    [self cancelTimer];
                }
                
                [self cancelaAnimationWithImageView:mapMoveVi];
                self.statusStr=@"0";
                [self.tableView reloadData];
            } WithReturnCodeEqualToOneBlock:nil];
        }];
    }];
}

//获取完全的发给服务器的时间数据
- (NSString *)getWholeTime
{
    NSDate * date =[NSDate date];
    NSDateFormatter * forM =[[NSDateFormatter alloc] init];
    [forM setDateFormat:@"YYYYMMddHHmmss"];
    NSString * str =[forM stringFromDate:date];
    return str;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
