//
//  EPCallCarVC.m
//  EPin-IOS
//
//  Created by jeader on 16/6/17.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCallCarVC.h"
#import "EPCallCarCell.h"
#import "EPCallInfoVC.h"
#import "HeaderFile.h"
#import "EPAddressVC.h"
#import "JCAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "EPLoginViewController.h"
#import "EPData.h"
#import "EPNowTableVC.h"
#import "EPOrderTableVC.h"
#import "EPCallCompleteVC.h"

@interface EPCallCarVC ()<UIScrollViewDelegate,CLLocationManagerDelegate>
{
    CLGeocoder *_geocoder;
    
    EPNowTableVC * nowTable;//------>现在召车子控制器
    
    EPOrderTableVC* tableV;//------->预约用车子控制器
}
@property (nonatomic, strong) UIButton *underBtn;          //switch地下的按钮
@property (nonatomic, strong) UILabel *titleLab;           //switch顶部的标签

@property (nonatomic, strong) CLLocationManager *locationManager;//定义Manager

//@property (nonatomic, strong) NSDictionary * nowCallDic;        //获取[现在]召车数据
//@property (nonatomic, strong) NSDictionary * orderCallDic;      //获取[预约]召车数据
@property (nonatomic, strong) UIScrollView * scr;               //现在和预约区别的ScrollView

@end

@implementation EPCallCarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建导航条
    [self prepareForNavigationView];
    //创建滚动视图--接单状态的改变
    [self prepareForScrollView];
    //初始化定位
    [self initLocation];
    
//    [self prepareForOrderData];
    [self prepareForChildController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchStyle:) name:@"callCarNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchStyle:) name:@"orderCarNotice" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completePayAction) name:@"dismissRequest" object:nil];
}
- (void)switchStyle:(NSNotification *)noti
{
    NSString * notice =noti.userInfo[@"content"];
    if ([notice isEqualToString:@"您的现在召车已被接单!"])
    {
        if (self.nowCarBtn.selected == YES)
        {
            
        }
        else
        {
            [self lineViewChangeLocationWithLeftDirection:YES];
        }
    }
    else
    {
        if (self.orderCarBtn.selected == YES)
        {
            
        }
        else
        {
            [self lineViewChangeLocationWithLeftDirection:NO];
        }
    }
}

- (void)completePayAction
{ 
    [self prepareForOrderData];
    EPCallCompleteVC * vc =[[EPCallCompleteVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)prepareForNavigationView
{
    [self addNavigationBar:0 title:@"召  车"];
    [self addRightItemWithFrame:CGRectMake(0, 0, 15, 18) textOrImage:0 action:@selector(goInfo) name:@"call_history"];
    self.nowCarBtn.selected = YES;
}
- (void)prepareForScrollView
{
    self.scr =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 135, EPScreenW, EPScreenH-160)];
    self.scr.contentSize =CGSizeMake(EPScreenW *2, 0);
    self.scr.backgroundColor=[UIColor whiteColor];
    self.scr.pagingEnabled=YES;
    self.scr.scrollEnabled=NO;
    self.scr.delegate=self;
    self.scr.showsHorizontalScrollIndicator=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.scr];
}
//添加两个子视图控制器
- (void)prepareForChildController
{
    nowTable =[[EPNowTableVC alloc] init];
    nowTable.view.frame=CGRectMake(0, 0, EPScreenW, _scr.frame.size.height);
    [_scr addSubview:nowTable.view];
    [self addChildViewController:nowTable];
    
    tableV =[[EPOrderTableVC alloc]init];
    tableV.view.frame=CGRectMake(EPScreenW, 0, EPScreenW, _scr.frame.size.height);
    [_scr addSubview:tableV.view];
    [self addChildViewController:tableV];
}
- (void)prepareForOrderData
{
    EPData * data=[EPData new];
    [EPTool addMBProgressWithView:self.view style:0];
    [EPTool showMBWithTitle:@"正在获取数据..."];
    
    NSString * uuidStr =[data getUniqueStrByUUID];
    
    [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"" WhatToDo:@"0" withOrderNumber:uuidStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0)
        {
            NSArray * arr =dic[@"getCallCarArr"];
            for (NSDictionary * smallDic in arr)
            {
                NSString * orderType =smallDic[@"useType"];
                if ([orderType intValue]==1)   //-------预约
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendOrderMessage" object:nil userInfo:smallDic];
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                }
                else                           //---------现在
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendNowMessage" object:nil userInfo:smallDic];
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                }
            }
            
        }
        else if ([returnCode intValue]==1)
        {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"sendOrderMessage" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"sendNowMessage" object:nil userInfo:nil];
        }
        else if ([returnCode intValue]==2)
        {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [EPTool addAlertViewInView:self title:@"" message:msg count:0 doWhat:^{
                [self.navigationController popViewControllerAnimated:YES];
                [EPLoginViewController publicDeleteInfo];
            }];
        }
        else
        {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [EPTool addAlertViewInView:self title:@"提示" message:@"网络链接似乎有点问题" count:0 doWhat:nil];
        }
 
    }];
}
//初始化定位
- (void)initLocation
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled])
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"定位功能可能未打开，请到‘设置-隐私-定位服务’中打开！" count:0 doWhat:^{
//            [EPTool addMBProgressWithView:self.view style:1];
//            [EPTool showMBWithTitle:@"定位服务当前可能尚未打开，请设置打开！"];
//            [EPTool hiddenMBWithDelayTimeInterval:1];
            return;
        }];
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}
// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code]==kCLErrorDenied)
    {
        [EPTool addMBProgressWithView:self.view style:1];
        [EPTool showMBWithTitle:@"没有授权"];
        [EPTool hiddenMBWithDelayTimeInterval:1];
    }
//    else if ([error code]==kCLErrorLocationUnknown)
//    {
//        [EPTool addMBProgressWithView:self.view style:1];
//        [EPTool showMBWithTitle:@"无法获得定位信息"];
//        [EPTool hiddenMBWithDelayTimeInterval:1];
//    }
}
//定位实时更新的代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLLocation *newLocation =[locations lastObject];
    
    //------------------位置反编码---5.0之后使用-----------------//
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *place in placemarks)
         {
             NSString * str =[NSString stringWithFormat:@"%@",place.name];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"nowLocation" object:nil userInfo:@{@"nowLocation": str}];
             [EPTool hiddenMBWithDelayTimeInterval:0];
//             NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
//             [us setObject:str forKey:@"nowLocation"];
//             [us synchronize];
         }
     }];
    
}
- (IBAction)nowCarBtn:(UIButton *)sender
{
    if (sender.selected == NO)
    {
        self.orderCarBtn.selected = NO;
        self.nowCarBtn.selected = YES;
        [self lineViewChangeLocationWithLeftDirection:YES];
        
    }
    
}

- (IBAction)orderCarBtn:(UIButton *)sender
{
    if (sender.selected == NO)
    {
        self.nowCarBtn.selected = NO;
        self.orderCarBtn.selected = YES;
        [self lineViewChangeLocationWithLeftDirection:NO];
        
    }
}

- (void)lineViewChangeLocationWithLeftDirection:(BOOL)left
{
    if (left == YES)
    {
        [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.lineView.transform = CGAffineTransformIdentity;
            [_scr setContentOffset:CGPointMake(0, 0) animated:YES];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.lineView.transform=CGAffineTransformMakeTranslation(EPScreenW / 2, 0);
            [_scr setContentOffset:CGPointMake(EPScreenW, 0) animated:YES];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma -mark 点击事件
//查看历史界面
- (void)goInfo
{
    EPCallInfoVC * vc =[[EPCallInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
