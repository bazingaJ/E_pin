//
//  EPWebViewController.m
//  EPin-IOS
//
//  Created by jeaderQ on 16/5/4.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPWebViewController.h"
#import "HeaderFile.h"
@interface EPWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"问卷调查"];
    [self goInWebView];
    // Do any additional setup after loading the view from its nib.
}
- (void)goInWebView
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://com-jeader-tad.6655.la:10915/tad/wenjuan/index"]]];
}

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
