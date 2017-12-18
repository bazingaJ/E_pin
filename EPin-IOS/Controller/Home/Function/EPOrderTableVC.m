//
//  EPOrderTableVC.m
//  EPin-IOS
//
//  Created by jeader on 16/6/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPOrderTableVC.h"
#import "EPCallCarCell.h"
#import "EPAddressVC.h"
#import "EPData.h"
#import "EPTool.h"
#import "JCAlertView.h"
#import "EPFaresController.h"

@interface EPOrderTableVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    JCAlertView *alert;
    
    int number;
    
    dispatch_source_t timerOrder;
    
    UIImageView * carMoveVi;//------>司机接单之后的动画
    
    UIImageView * mapMoveVi;//------>等待司机接单的动画
    
    UIImageView * onCarMoveVi;//---->行程中
}
@property (nonatomic, strong) NSString * statusStr;
@property (nonatomic, strong) NSString * numberStr;

@property (nonatomic, strong) UIButton * timeButton;
@property (nonatomic, strong) NSMutableDictionary * detailDic;      //可以查看召车详情的字典
@property (nonatomic, strong) NSMutableArray * nowArr;              //今天日期中的一系列日期
@property (nonatomic, strong) NSMutableArray * dayArr;              //存储日期天数的数组
@property (nonatomic, strong) NSMutableArray * OriginArr;           //获取全部的时分的数组
@property (nonatomic, strong) NSString * dayString;                 //日期天数
@property (nonatomic, strong) NSString * hourString;                //日期小时数
@property (nonatomic, strong) UIPickerView * pickerView;            //时间选择
@property (nonatomic, strong) NSString * choiceTime;                //时间选择的字符串
@property (nonatomic, strong) NSDictionary * driverInfoDictionary;  //查看召车司机详情的字典
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) UILabel * countingLabel;

@end

@implementation EPOrderTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取出现在时间的月日时分
    [self prepareForNowData];
    //获取出全部的时分
    [self prepareForOriginData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getOrderData:) name:@"sendOrderMessage" object:nil];//---改变单元格状态和信息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadOrderTable) name:@"orderCarNotice" object:nil];//------司机预约召车接单
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeOrderStyle) name:@"upCarOrderNotice" object:nil];//-----司机点击乘客上车
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moneyPayOrder) name:@"finishOrderCallCar" object:nil];//-----司机点击现金支付
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userOrderLocation:) name:@"nowLocation" object:nil];//----系统定位之后回传的地址
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //从本地取召车详情
    NSString * filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/orderDetail.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        self.detailDic=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else
    {
        self.detailDic=[NSMutableDictionary dictionary];
    }
    //从本地区司机详情
    NSString * filePa =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/driverOrder.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePa])
    {
        self.driverInfoDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filePa];
    }
    else
    {
        self.driverInfoDictionary=[NSMutableDictionary dictionary];
    }
    //对时间的处理
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isActived"])
    {
        NSString * beforeTimeStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"orderTimeInterval"];
        NSString * nowTimeStr =[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
        int interval =[nowTimeStr intValue]-[beforeTimeStr intValue];
        NSString * before =[[NSUserDefaults standardUserDefaults]objectForKey:@"orderText"];
        NSRange minuteR = NSMakeRange(7, 2);
        NSRange secondR = NSMakeRange(10, 2);
        NSString * e =[before substringWithRange:minuteR];
        NSString * f =[before substringWithRange:secondR];
        int intervalBase =[e intValue]*60+[f intValue];
        
        number=interval+intervalBase;
        NSString * minuteStr =[NSString stringWithFormat:@"%02d",number/60];
        NSString * secondStr = [NSString stringWithFormat:@"%02d",number%60];
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
    [us setObject:timeStr forKey:@"orderTimeInterval"];
    [us setObject:self.countingLabel.text forKey:@"orderText"];
    [us synchronize];
}


#pragma mark -
#pragma mark - GCD 计时器
//让计时开始
- (void)countingBegin
{
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timerOrder = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timerOrder, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timerOrder, ^{ //在这里执行事件
        
        [self myTimerAction];
    });
    
    dispatch_resume(timerOrder);
    
    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    [us setBool:YES forKey:@"isActived"];
    [us synchronize];
}
- (void)myTimerAction
{
    number ++;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * minute =[NSString stringWithFormat:@"%02d",number/60];
        NSString * second = [NSString stringWithFormat:@"%02d",number%60];
        self.countingLabel.text = [NSString stringWithFormat:@"等待司机接单(%@:%@)",minute,second];
    });
}
- (void)cancelTimer
{
    dispatch_cancel(timerOrder);
    timerOrder=nil;
    number=0;
    self.countingLabel.text = @"00:00";
    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    [us setBool:NO forKey:@"isActived"];
    [us synchronize];
}




#pragma mark -
#pragma mark - 接收通知 处理状态
//通知传值过来
- (void)getOrderData:(NSNotification *)noti
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
- (void)reloadOrderTable
{
    self.statusStr=@"2";
    [self requestDataDriverInfo];
    [self.tableView reloadData];
}
- (void)changeOrderStyle
{
    self.statusStr=@"6";
    [self.tableView reloadData];
}
//司机点击现金支付
- (void)moneyPayOrder
{
    self.statusStr=@"0";
    [self.tableView reloadData];
}

- (void)userOrderLocation:(NSNotification *)noti
{
    NSString * location=noti.userInfo[@"nowLocation"];
    [self.nowLocationBtn setTitle:location forState:UIControlStateNormal];
}


- (void)requestDataDriverInfo
{
    EPData * data=[EPData new];
    NSString * uuidStr =[data getUniqueStrByUUID];
    [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"1" WhatToDo:@"0" withOrderNumber:uuidStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
            NSArray * arr =dic[@"getCallCarArr"];
            for (NSDictionary * smallDic in arr)
            {
                NSString * orderType =smallDic[@"useType"];
                if ([orderType intValue]==1)
                {
                    [self cancelTimer];
                    self.driverInfoDictionary=smallDic;
                    NSString * filePa =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/driverOrder.plist"];
                    [self.driverInfoDictionary writeToFile:filePa atomically:YES];
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
            cell1=[[[NSBundle mainBundle]loadNibNamed:@"EPCallCarCell" owner:nil options:nil]objectAtIndex:3];
            
        }
        self.timeButton=cell1.upCarTimeBtn;
        self.nowLocationBtn=cell1.upCarBtn1;
        self.destinationBtn=cell1.destinetionBtn1;
        
        NSString * choiceTime =[[NSUserDefaults standardUserDefaults]objectForKey:@"goTime"];
        if (choiceTime.length != 0)
        {
            [self.timeButton setTitle:choiceTime forState:UIControlStateNormal];
        }
        NSString * upCar  =[[NSUserDefaults standardUserDefaults]objectForKey:@"nowLocation"];
        if (upCar.length != 0)
        {
            [self.nowLocationBtn setTitle:upCar forState:UIControlStateNormal];
            
        }
        NSString * upCarStr  =[[NSUserDefaults standardUserDefaults]objectForKey:@"orderLocation"];
        if (upCarStr.length != 0)
        {
            [self.nowLocationBtn setTitle:upCarStr forState:UIControlStateNormal];
        }
        NSString * destinationStr =[[NSUserDefaults standardUserDefaults]objectForKey:@"orderDestination"];
        if (destinationStr.length != 0)
        {
            [self.destinationBtn setTitle:destinationStr forState:UIControlStateNormal];
        }
        [self.timeButton addTarget:self action:@selector(choiceTime:) forControlEvents:UIControlEventTouchUpInside];
        [self.nowLocationBtn addTarget:self action:@selector(searchLoca:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.destinationBtn addTarget:self action:@selector(searchLoca:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.containBtn1 addTarget:self action:@selector(orderContainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        [cell2.cancelBtn addTarget:self action:@selector(orderContainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.detailBtn addTarget:self action:@selector(viewDetail) forControlEvents:UIControlEventTouchUpInside];
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
        [cell3.cancelButton addTarget:self action:@selector(orderContainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.driverDetail addTarget:self action:@selector(seeDriver) forControlEvents:UIControlEventTouchUpInside];
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
- (void)searchLoca:(UIButton *)btn
{
    EPAddressVC * vc =[[EPAddressVC alloc] init];
    if (btn.tag==202)
    {
        vc.isUp=YES;
        vc.isOrder=YES;
        vc.orderViewCon=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag==203)
    {
        vc.isUp=NO;
        vc.isOrder=YES;
        vc.orderViewCon=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//查看召车详情
- (void)viewDetail
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
    upTime.text=[NSString stringWithFormat:@"上车时间: %@",self.detailDic[@"upTime"]];
    upTime.font=[UIFont systemFontOfSize:16];
    upTime.textColor=[UIColor blackColor];
    [customView addSubview:upTime];
    
    UILabel * local =[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 270, 25)];
    local.text=[NSString stringWithFormat:@"起点: %@",self.detailDic[@"local"]];
    local.font=[UIFont systemFontOfSize:16];
    local.numberOfLines=0;
    local.textColor=[UIColor blackColor];
    [customView addSubview:local];
    
    UILabel * destination =[[UILabel alloc] initWithFrame:CGRectMake(10, 135, 270, 25)];
    destination.text=[NSString stringWithFormat:@"终点: %@",self.detailDic[@"destination"]];
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
    [btn addTarget:self action:@selector(knownIt) forControlEvents:UIControlEventTouchUpInside];
    
    alert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [alert show];
}
//我知道了按钮点击事件
- (void)knownIt
{
    [alert dismissWithCompletion:nil];
}
//弹出司机详情
- (void)seeDriver
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
    upTime.text=[NSString stringWithFormat:@"车牌号码:   %@",self.driverInfoDictionary[@"licenseNo"]];
    upTime.font=[UIFont systemFontOfSize:16];
    upTime.textColor=[UIColor blackColor];
    [customView addSubview:upTime];
    
    UILabel * local =[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 70, 25)];
    local.text=@"联系方式:";
    local.font=[UIFont systemFontOfSize:16];
    local.numberOfLines=0;
    local.textColor=[UIColor blackColor];
    [customView addSubview:local];
    
    UIButton * contact =[UIButton buttonWithType:UIButtonTypeCustom];
    contact.frame=CGRectMake(CGRectGetMaxX(local.frame), 95, 120, 25);
    NSString * text =[NSString stringWithFormat:@"%@",self.driverInfoDictionary[@"driverPhoneNo"]];
    [contact setTitle:text forState:UIControlStateNormal];
    contact.titleLabel.font=[UIFont systemFontOfSize:16];
    contact.titleLabel.numberOfLines=0;
    [contact addTarget:self action:@selector(callOrderDriver:) forControlEvents:UIControlEventTouchUpInside];
    [contact setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [customView addSubview:contact];
    
    
    UILabel * destination =[[UILabel alloc] initWithFrame:CGRectMake(10, 135, 270, 25)];
    destination.text=[NSString stringWithFormat:@"所属公司:   %@",self.driverInfoDictionary[@"companyName"]];
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
    [btn addTarget:self action:@selector(knownIt) forControlEvents:UIControlEventTouchUpInside];
    
    alert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [alert show];
}
//调拨打电话功能
- (void)callOrderDriver:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",btn.currentTitle];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}
//确定叫车按钮点击事件
- (void)orderContainBtnClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 204:
        {
            [self containCallCarButton];
        }
            break;
        case 222:
        {
            [self cancelCallCarBtnClickWithCancelStyle:0];
        }
            break;
        case 333:
        {
            [self cancelCallCarBtnClickWithCancelStyle:1];
        }
            break;
            
        default:
            break;
    }
}
//确认叫车按钮的点击事件绑定
- (void)containCallCarButton
{
    if ([self.timeButton.currentTitle isEqualToString:@"选择上车时间"])
    {
        [EPTool addAlertViewInView:self title:@"提示" message:@"请选择上车时间!" count:0 doWhat:nil];
        return;
    }
    if (![self.nowLocationBtn.currentTitle isEqualToString:@"选择起点"] && ![self.destinationBtn.currentTitle isEqualToString:@"选择终点"])
    {
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@"正在提交"];
        EPData * data =[EPData new];
        NSString * uudiStr = [data getUniqueStrByUUID];
        NSString * year =[self getYearWithType:1 WithWholeData:self.timeButton.currentTitle];
        [data getCallCarDataWithGetCarTime:year WithGetCarAddress:self.nowLocationBtn.currentTitle WtihDestination:self.destinationBtn.currentTitle WithContect:@"" WithUserType:@"1" WhatToDo:@"1" withOrderNumber:uudiStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                [self countingBegin];
                self.detailDic[@"upTime"]=self.timeButton.currentTitle;
                self.detailDic[@"local"]=self.nowLocationBtn.currentTitle;
                self.detailDic[@"destination"]=self.destinationBtn.currentTitle;
                NSString * filePath =[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/orderDetail.plist"];
                [self.detailDic writeToFile:filePath atomically:YES];
                
                [self.timeButton setTitle:@"" forState:UIControlStateNormal];
                [self.nowLocationBtn setTitle:@"" forState:UIControlStateNormal];
                [self.destinationBtn setTitle:@"" forState:UIControlStateNormal];
                NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
                [us setObject:@"" forKey:@"goTime"];
                [us setObject:@"" forKey:@"orderLocation"];
                [us setObject:@"" forKey:@"orderDestination"];
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
 取消按钮点击事件

 @param index 司机未接单取消：0  司机已经接单取消：1
 */
- (void)cancelCallCarBtnClickWithCancelStyle:(NSInteger)index
{
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您确定取消吗?" count:1 doWhat:^{
        EPData * data =[EPData new];
        [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"" WhatToDo:@"2" withOrderNumber:self.numberStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            [EPTool handleWithDataReturnedByTheServerInViewController:self WithInReturnCode:[returnCode integerValue] WithErrorMessage:msg WithReturnCodeEqualToZeroBlock:^{
                if (index == 0)
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
//发送给服务器处理好的数据
- (NSString *)getYearWithType:(NSInteger)type WithWholeData:(NSString *)data
{
    NSDate * date =[NSDate date];
    NSString * str =[EPOrderTableVC GetTomorrowDay:date withType:1];
    NSRange mouthRange = NSMakeRange(0, 2);
    NSRange dayRange = NSMakeRange(3, 2);
    NSRange hourRange = NSMakeRange(8, 2);
    NSRange minuteRange = NSMakeRange(11, 2);
    NSString * a =[data substringWithRange:mouthRange];
    NSString * b =[data substringWithRange:dayRange];
    NSString * c =[data substringWithRange:hourRange];
    NSString * d =[data substringWithRange:minuteRange];
    NSString * wholeStr =[NSString stringWithFormat:@"%@%@%@%@%@00",str,a,b,c,d];
    return wholeStr;
}
//获取不同类型明日的日期
+(NSString *)GetTomorrowDay:(NSDate *)aDate withType:(NSInteger)type
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    if (type==0)
    {
        [dateday setDateFormat:@"MM月dd日"];
        NSString * tomorrowString = [dateday stringFromDate:beginningOfWeek];
        return tomorrowString;
    }
    else
    {
        [dateday setDateFormat:@"yyyy"];
        NSString * tomorrowString = [dateday stringFromDate:beginningOfWeek];
        return tomorrowString;
    }
}
#pragma mark- 时间选择和pickerView
- (void)choiceTime:(UIButton *)btn
{
    [self showAlertWithCustomView];
}
//弹出时间选择界面
- (void)showAlertWithCustomView
{
    //设置一个弹窗的自定义view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 225)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.masksToBounds=YES;
    customView.layer.cornerRadius=5;
    //设置标题
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    titleLab.backgroundColor=RGBColor(29, 32, 40);
    titleLab.text=@"选择时间";
    titleLab.font=[UIFont systemFontOfSize:19];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=RGBColor(218, 187, 132);
    [customView addSubview:titleLab];
    //设置中间的时间选择器
    [self DefinePickerViewWithSuperView:customView];
    //设置按钮上边的分割线
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 174, 300, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    [customView addSubview:lineView];
    //设置最下边的按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 175, 300, 50)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:19];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [customView addSubview:btn];
    [btn addTarget:self action:@selector(containTime) forControlEvents:UIControlEventTouchUpInside];
    
    alert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [alert show];
}
//定义一个pickerView出来
- (void)DefinePickerViewWithSuperView:(UIView *)superView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 300, 135)];
    _pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [superView addSubview:pickerView];
    
    //选中当前日期
    [pickerView selectRow:0 inComponent:0 animated:YES];
    [pickerView selectRow:0 inComponent:1 animated:YES];
}
//弹窗中确定按钮点击之后
- (void)containTime
{
    [alert dismissWithCompletion:nil];
    NSString * choiceTime =[[NSUserDefaults standardUserDefaults]objectForKey:@"goTime"];
    if (choiceTime.length != 0)
    {
        [self.timeButton setTitle:choiceTime forState:UIControlStateNormal];
        [_nowArr removeAllObjects];
        [self prepareForNowData];
    }
}
//获取出现在时间的月日时分
- (void)prepareForNowData
{
    _dayArr =[NSMutableArray array];
    //获取当天的日期
    NSDate * nowDate =[NSDate date];
    NSDateFormatter * format =[[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM月dd日"];
    NSString * nowTime =[format stringFromDate:nowDate];
    [_dayArr addObject:nowTime];
    //获取明天的日期
    NSString * tomorrowString = [EPOrderTableVC GetTomorrowDay:nowDate withType:0];
    [_dayArr addObject:tomorrowString];
    
    
    _nowArr =[NSMutableArray array];
    int myHour =[self GetTodayHour]*2;
    for (int i= myHour; i<48; i++)
    {
        if (i%2==0)
        {
            if (i<46)
            {
                NSString * str1 =[NSString stringWithFormat:@"%02d:00",i/2+1];
                [_nowArr addObject:str1];
            }
            
        }
        else
        {
            if (i<46)
            {
                NSString * str1 =[NSString stringWithFormat:@"%02d:30",i/2+1];
                [_nowArr addObject:str1];
            }
        }
    }
}
//获取当前日期的当前时间
-(int)GetTodayHour
{
    NSDate * date = [NSDate date];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"HH"];
    NSString * str =[dateday stringFromDate:date];
    return [str intValue];
}
//获取出全部的时分
- (void)prepareForOriginData
{
    _OriginArr =[NSMutableArray array];
    for (int i= 0; i<48; i++)
    {
        if (i%2==0)
        {
            NSString * str1 =[NSString stringWithFormat:@"%02d:00",i/2];
            [_OriginArr addObject:str1];
        }
        else
        {
            NSString * str1 =[NSString stringWithFormat:@"%02d:30",i/2];
            [_OriginArr addObject:str1];
        }
    }
}
#pragma mark- UIPicker View DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return 2;
    }
    else
    {
        return _nowArr.count;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0) return 125;
    if (component==1) return 100;
    return 0;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        if (row==0)
        {
            NSString * nowString =_dayArr[row];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nowString];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, nowString.length)];
            return attrString;
        }
        else
        {
            NSString * myDateString = _dayArr[row];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:myDateString];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, myDateString.length)];
            return attrString;
        }
    }
    else
    {
        NSString *strDateWeek =_nowArr[row];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strDateWeek];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, strDateWeek.length)];
        return attrString;
    }
}
#pragma mark- UIPicker View Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        if (row==0)
        {
            //刷新第二列的表格
            [_nowArr removeAllObjects];
            [self prepareForNowData];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            //存数当前列的信息
            self.dayString =_dayArr[row];
            NSInteger row1=[pickerView selectedRowInComponent:1];
            NSString *hourStr=_nowArr[row1];
            _choiceTime=[NSString stringWithFormat:@"%@  %@",self.dayString,hourStr];
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setObject:_choiceTime forKey:@"goTime"];
            [us synchronize];
        }
        else
        {
            //刷新表格
            [_nowArr removeAllObjects];
            [self prepareForOriginData];
            _nowArr=_OriginArr;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            //获取明天日期信息
            self.dayString = _dayArr[row];
            
            NSInteger row1=[pickerView selectedRowInComponent:1];
            NSString *hourStr=_nowArr[row1];
            
            _choiceTime=[NSString stringWithFormat:@"%@  %@",self.dayString,hourStr];
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setObject:_choiceTime forKey:@"goTime"];
            [us synchronize];
        }
    }
    else
    {
        self.hourString =_nowArr[row];
        NSInteger row1=[pickerView selectedRowInComponent:0];
        NSString *dayStr=_dayArr[row1];
        _choiceTime=[NSString stringWithFormat:@"%@  %@",dayStr,self.hourString];
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:_choiceTime forKey:@"goTime"];
        [us synchronize];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
