//
//  EPScanResultVC.h
//  EPin-IOS
//
//  Created by jeader on 16/4/8.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPScanResultVC : UIViewController

@property (nonatomic, weak) IBOutlet UILabel * resultLab;
@property (nonatomic, weak) IBOutlet UIWebView * webView;

- (instancetype)initWithResultStr:(NSString *)string;	
@end
