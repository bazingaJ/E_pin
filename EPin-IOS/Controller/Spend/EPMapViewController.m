//
//  EPMapViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/9/9.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMapViewController.h"
#import "HeaderFile.h"
@interface EPMapViewController ()<MKMapViewDelegate>

@end

@implementation EPMapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:@"地图"];
    self.view.backgroundColor=[UIColor whiteColor];
    [self showMapView];
}
//显示地图
-(void)showMapView
{
    //创建地图
    _mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0,64,EPScreenW ,EPScreenH-64)];
    _mapView.delegate=self;
    //地图定位
    _mapView.showsUserLocation=YES;
    _mapView.showsTraffic=YES;
    _mapView.userInteractionEnabled=YES;
    //_mapView.centerCoordinate
    _mapView.showsCompass=YES;
    [self.view addSubview:_mapView];
    
    
    MKLocalSearchRequest * request=[[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery=self.address;
    
}
//开始地理编码


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
