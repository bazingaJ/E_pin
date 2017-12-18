//
//  HeaderFile.h
//  E-Pin
//
//  Created by jeader on 16/3/21.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#ifndef HeaderFile_h
#define HeaderFile_h
#define EPScreenH [UIScreen mainScreen].bounds.size.height
#define EPScreenW [UIScreen mainScreen].bounds.size.width
#define EPScreenSize [UIScreen mainScreen].bounds.size
#import <UIKit/UIKit.h>
#import "UIView+EPFrame.h"
#import "EPTabbarViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "EPTool.h"
#import "EPData.h"
#import "AFNetworking.h"
#import "EPLoginViewController.h"
#import "EPPerModel.h"
#import "JDTopLayerWindow.h"
#import "EPRSA.h"
#import "MJExtension.h"
#import "JDGoodsTools.h"
#import <MessageUI/MessageUI.h>
#import "MJRefresh.h"
#define WIDTH(a,b) (a/b*[UIScreen mainScreen].bounds.size.width)
#define HEIGHT(a,b) ((a/b)*[UIScreen mainScreen].bounds.size.height)
#define randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define RGBColor(a,b,c)  [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define RGBAColor(a,b,c,d)  [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define CLIENTID [[NSUserDefaults standardUserDefaults]objectForKey:@"clientID"]
#define PHONENO [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNo"]
#define USERID [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
#define LOGINTIME [[NSUserDefaults standardUserDefaults]objectForKey:@"loginTime"]
#define INVITECODE [[NSUserDefaults standardUserDefaults]objectForKey:@"inviteCode"]
#define TOTALSCORE [[NSUserDefaults standardUserDefaults]objectForKey:@"totalScore"]
#define PHONEPASS [[NSUserDefaults standardUserDefaults]objectForKey:@"phonePass"]
#define isUse [[NSUserDefaults standardUserDefaults]objectForKey:@"isUse"]
#define isShopRest [[NSUserDefaults standardUserDefaults]objectForKey:@"isshopRest"]
#define isGetOn [[NSUserDefaults standardUserDefaults]objectForKey:@"isgetOn"]
#define NAME [[NSUserDefaults standardUserDefaults]objectForKey:@"name"]
#define publicKeyRSA [[NSUserDefaults standardUserDefaults]objectForKey:@"publicKey"]

#define EPUrl @"http://114.55.57.237/tad/client"
//#define EPUrl @"http://192.168.1.155:8080/tad/client"
#define APPID  @"wx9ead5d0591d84b3a"

#define randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define IS_iOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0f
#import "UIButton+CountDown.h"
#import "HeaderFile.h"
#import "EPScanVC.h"
#import "EPSearchVC.h"
#import "EPMainTableViewCell.h"
#import "SDCycleScrollView.h"
#import "EPMenuController.h"
#import "QuadCurveMenu.h"
#import "EPLostVC.h"
#import "EPShopingController.h"
#import "EPSubmitController.h"
#import "EPLeisureController.h"
#import "EPFinancialController.h"
#import "EPPeccCell.h"
#import "AFNetworking.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD.h"
#import "EPCallCarVC.h"
#import "JDPeccancyViewController.h"
#import "EPLoginViewController.h"
#import "EPMainCellView.h"
#import "SYQrCodeScanne.h"
#import "EPFaresController.h"
#import "EPEPaiViewController.h"
#import "FileHander.h"
#endif /* HeaderFile_h */
