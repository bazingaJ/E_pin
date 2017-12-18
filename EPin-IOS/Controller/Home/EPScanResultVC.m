//
//  EPScanResultVC.m
//  EPin-IOS
//  扫码结果
//  Created by jeader on 16/4/8.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPScanResultVC.h"
#import "HeaderFile.h"

@interface EPScanResultVC ()

@property (nonatomic, strong) NSString * getStr;

@end

@implementation EPScanResultVC

- (instancetype)initWithResultStr:(NSString *)string
{
    if (self=[super init])
    {
        self.getStr=string;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"扫描结果"];
    [self prepareForData];
    [self goInWebView];
}
- (void)prepareForData
{
    self.resultLab.text=self.getStr;
}
- (void)goInWebView
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.getStr]]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
