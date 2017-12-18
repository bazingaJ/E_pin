//
//  EPMapViewController.h
//  EPin-IOS
//
//  Created by jeaderL on 16/9/9.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>
//#import <MAMapKit/MAMapKit.h>
@interface EPMapViewController : UIViewController
{
    //声明地图变量
    MKMapView * _mapView;
    AMapSearchAPI *_search;
    
}

@property(nonatomic,copy)NSString * shopName;
@property(nonatomic,copy)NSString * address;


@end
