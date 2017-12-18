//
//  PeccancyDetailViewC.m
//  E+TAXI
//
//  Created by jeader on 15/12/29.
//  Copyright © 2015年 jeader. All rights reserved.
//

#import "PeccancyDetailViewC.h"
#import "PeccCell.h"
#import "EPData.h"
#import "HeaderFile.h"
#import "PeccancyDealViewC.h"
#import "EPTool.h"
#import "EPData.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JDPeccancyData.h"

#pragma mark- 自定义一个大头针
@interface JDPoint : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t;

@end

@implementation JDPoint

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t
{
    self = [super init];
    if (self)
    {
        _coordinate = c;
        _title = t;
    }
    return self;
}

@end

#pragma mark- 地理编码
@interface PeccancyDetailViewC ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) CLLocationManager *locationmanager;
@property (nonatomic, strong) CLGeocoder * gercoder;
//@property (nonatomic, strong) NSMutableDictionary * infoDic;
@property (nonatomic, strong) NSString * myAddress;
@property (nonatomic, strong) NSMutableArray * endArr;
@property (nonatomic, assign) CLLocationCoordinate2D locc;

@property (nonatomic, weak) JDPoint * point;

@end

@implementation PeccancyDetailViewC

- (instancetype)initWithArr:(NSMutableArray *)arr WithCode:(NSInteger)code withAddress:(NSString *)address
{
    if (self=[super init])
    {
        self.array=[NSMutableArray arrayWithCapacity:0];
        self.array=arr;
        self.codeStr=[NSString stringWithFormat:@"%ld",(long)code];
        self.myAddress=address;
    }
    return self;
}
- (CLGeocoder *)geocoder
{
    if (!_gercoder)
    {
        _gercoder=[[CLGeocoder alloc] init];
    }
    return _gercoder;
}
- (void)viewWillAppear:(BOOL)animated
{
    NSString * address =[NSString stringWithFormat:@"江苏南京%@",self.myAddress];
    if (address.length==0) return;
    
//    [self.gercoder geocodeAddressDictionary:<#(nonnull NSDictionary *)#> completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        
//    }];
    
    
    //2.开始地理编码
    //说明：调用下面的方法开始编码，不管编码是成功还是失败都会调用block中的方法
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
         if (error || placemarks.count==0)
         {
             NSLog(@"你输入的地址没找到，可能在月球上");
         }
         else
         {
             /*
              name:名称
              locality:城市
              country:国家
              postalCode:邮政编码
              */
             
             //取出获取的地理信息数组中的第一个显示在界面上
             CLPlacemark *firstPlacemark=[placemarks firstObject];
             //详细地址名称
             self.locc=firstPlacemark.location.coordinate;

         }
     }];
    
    [self.detailTable reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * vi =[[UIView alloc] init];
    vi.backgroundColor=[UIColor clearColor];
    self.detailTable.tableFooterView=vi;
    
    // 添加大头针
    JDPoint * point =[[JDPoint alloc] init];
    _point = point;
    [self.mapView addAnnotation:point];
    
    [self mapAndTabelView];
}
//添加地图和tableView
-(void)mapAndTabelView
{
    //定位
    [self setUpLocation];
    //设置地图的代理
    _mapView.delegate = self;
    //设置可以显示用户当前位置
    [_mapView setShowsUserLocation:YES];
    
}
//定位
-(void)setUpLocation
{
    self.locationmanager = [[CLLocationManager alloc] init];

    self.locationmanager.delegate = self;
}
//请求权限
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if([self.locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationmanager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"请在设置-隐私-定位服务中开启定位功能！");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"定位服务无法使用！");
        default:
            break;
    }
}

//MapView委托方法，当定位自身时调用-----定位
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //放大地图到自身的经纬度位置。值越大 显示的范围越大
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locc, 700, 700);
    [self.mapView setRegion:region animated:NO];
    
    
    _point.coordinate = self.locc;
    _point.title = self.myAddress;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array =[NSArray arrayWithObjects:@"违章内容",@"违章时间",@"罚款金额",@"扣分情况",@"违章地点",@"当前状态",@"", nil];
    JDPeccancyData * p =[self.array objectAtIndex:[self.codeStr integerValue]];
//    static NSString * cellID1 =@"cell1";
    PeccCell * cell =[tableView cellForRowAtIndexPath:indexPath];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PeccCell" owner:nil options:nil]objectAtIndex:0];
        
        if (indexPath.row==6)
        {
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        }
        else
        {
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
    }
    cell.dateLab.text=array[indexPath.row];
    switch (indexPath.row)
    {
        case 0:
        {
            NSString * str =[NSString stringWithFormat:@"%@",p.info];
            
            cell.whoLab.text=str;
            cell.whoLab.textAlignment=NSTextAlignmentLeft;
            cell.whoLab.textColor=[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
        }
            break;
        case 1:
        {
            NSString * str =[NSString stringWithFormat:@"%@",p.occur_date];
            cell.whoLab.text=str;
            cell.whoLab.textColor=[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
        }
            break;
        case 2:
        {
            NSString * str =[NSString stringWithFormat:@"%@",p.money];
            cell.whoLab.text=str;
            cell.whoLab.textColor=[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
        }
            break;
        case 3:
        {
            NSString * str =[NSString stringWithFormat:@"%@",p.fen];
            cell.whoLab.text=str;
            cell.whoLab.textColor=[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
        }
            break;
        case 4:
        {
            NSString * str =[NSString stringWithFormat:@"%@",p.occur_area];
            cell.whoLab.text=str;
            cell.whoLab.textColor=[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1.0];
        }
            break;
        case 5:
        {
            
            //区分已经处理的和没有处理的
            if ([p.result isEqualToString:@"已处理"])
            {
                cell.whoLab.text=@"已处理";
                cell.whoLab.textColor=[UIColor colorWithRed:0/255.0 green:157/255.0 blue:149/255.0 alpha:1.0];
                //已经处理过的时候label扣分颜色不用变化
                NSString * pointStr =[NSString stringWithFormat:@"扣%@分",p.fen];
                cell.whoLab.text=pointStr;
                
            }
            else if ([p.result isEqualToString:@"未处理"])
            {
                cell.whoLab.text=@"未处理";
                cell.whoLab.textColor=[UIColor colorWithRed:209/255.0 green:10/255.0 blue:21/255.0 alpha:1.0];
            }
            else if ([p.result isEqualToString:@"已受理"])
            {
                cell.whoLab.text=@"已受理";
                cell.whoLab.textColor=[UIColor colorWithRed:13/255.0 green:103/255.0 blue:223/255.0 alpha:1.0];
            }
            else
            {
                cell.whoLab.text=@"处理中";
                cell.whoLab.textColor=[UIColor colorWithRed:13/255.0 green:103/255.0 blue:223/255.0 alpha:1.0];
            }
        }
            break;
            
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        JDPeccancyData * p =[self.array objectAtIndex:[self.codeStr integerValue]];
        return [self stringHeightWithString:p.info]+30;
    }
    else
    {
        return 44;
    }
}
-(void)viewDidLayoutSubviews
{
    if ([self.detailTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.detailTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.detailTable respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.detailTable setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (float)stringHeightWithString:(NSString *)itemString
{
    CGRect rect = [itemString boundingRectWithSize:CGSizeMake(190, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    float height = ceilf(rect.size.height);
    return height;
}

//用积分处理违章的按钮点击事件
- (IBAction)dealBtnClick:(id)sender
{
    JDPeccancyData * p =[self.array objectAtIndex:[self.codeStr integerValue]];
    //区分已经处理的和没有处理的
    if ([p.result isEqualToString:@"已处理"])
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"该记录已经在处理中!" count:0 doWhat:^{
            
        }];
    }
    else if ([p.result isEqualToString:@"未处理"])
    {
        if ([self.moneyStr intValue]==0)
        {
            EPTool * t =[[EPTool alloc] init];
            [self presentViewController:[t showAlertControllerWithTitle:@"温馨提示" WithMessages:@"因该记录含有扣分,所以我们无法为您处理" WithCancelTitle:@"确定"] animated:YES completion:nil];
        }
        else
        {
            PeccancyDealViewC * vc =[[PeccancyDealViewC alloc] initWithDataArr:nil withMoneyStr:self.moneyStr withCode:self.codeStr];
            vc.IDStr=p.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([p.result isEqualToString:@"已受理"])
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"该记录我们已经受理!" count:0 doWhat:^{
            
        }];
    }
    else
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"该记录已经在处理中!" count:0 doWhat:^{
            
        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




@end
