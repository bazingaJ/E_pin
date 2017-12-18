//
//  EPCallCompleteVC.m
//  EPin-IOS
//
//  Created by jeader on 16/7/18.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCallCompleteVC.h"
#import "HeaderFile.h"

@interface EPCallCompleteVC ()

@end

@implementation EPCallCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBar:0 title:@"召车"];
    
    self.goMoreBtn.layer.borderColor=[UIColor blackColor].CGColor;
    self.goMoreBtn.layer.borderWidth=1;
    
    self.sependBtn.layer.borderColor=[UIColor blackColor].CGColor;
    self.sependBtn.layer.borderWidth=1;
    
    NSString * str =[[NSUserDefaults standardUserDefaults]objectForKey:@"paySuccessMoney"];
    self.moneyLabel.text=[NSString stringWithFormat:@"¥%@",str];
    
}
- (IBAction)goMoreBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"goMain" object:nil];
}
- (IBAction)goSpendBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"goHuaJF" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
