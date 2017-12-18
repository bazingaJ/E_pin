//
//  EPNewsViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/4/2.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPNewsViewController.h"
#import "EPLostCell.h"
#import "HeaderFile.h"
#import "EPNewsCell.h"
#import "EPNewsDetailVC.h"
#import "JDPushDataTool.h"
#import "JDPushData.h"
@interface EPNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * jifenArr;
@property(nonatomic,strong)NSMutableArray * carArr;
@property(nonatomic,strong)NSMutableArray * orderArr;
@end

@implementation EPNewsViewController
{
    NSString * _str;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"消息"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.jifenArr removeAllObjects];
    [self.carArr removeAllObjects];
    [self.orderArr removeAllObjects];
   // NSLog(@"查询数据---%@",[[JDPushDataTool new] query]);
    for (NSDictionary *dict in [[JDPushDataTool new] query]) {
        JDPushData *data = [JDPushData pushDataWithDictionary:dict];
        if ([dict[@"methodName"] isEqualToString:@"use_yipin"]) {
            [self.jifenArr addObject:data];
        }
        if ([dict[@"methodName"] isEqualToString:@"use_callCar"]) {
            [self.carArr addObject:data];
        }
        if ([dict[@"methodName"] isEqualToString:@"use_order"]) {
            [self.orderArr addObject:data];
        }
    }
    [self.tableVi reloadData];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier =@"zcCell";
    EPNewsCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EPNewsCell" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    NSArray * imgArr=@[@"img_xiaoxi_jifen",@"message_Car",@"indent"];
    NSArray * title=@[@"易品",@"召车消息",@"订单消息"];
    cell.titile.text=title[indexPath.row];
    cell.newsImg.image=[UIImage imageNamed:imgArr[indexPath.row]];
    if (indexPath.row==0) {
        if (self.jifenArr.count==0) {
            cell.content.text=@"暂无消息";
        }else{
            JDPushData *data = self.jifenArr[0];
            cell.content.text=data.content;
            if ([isUse intValue]==1) {
                cell.redView.hidden=NO;
            }else{
                cell.redView.hidden=YES;
            }
        }
    }else if (indexPath.row==1){
        if (self.carArr.count==0) {
            cell.content.text=@"暂无消息";
        }else{
            JDPushData *data = self.carArr[0];
            cell.content.text=data.content;
            if ([isGetOn intValue]==1) {
                cell.redView.hidden=NO;
            }else{
                cell.redView.hidden=YES;
            }
        }
    }else{
        if (self.orderArr.count==0) {
            cell.content.text=@"暂无消息";
        }else{
            JDPushData *data = self.orderArr[0];
            cell.content.text=data.content;
            cell.redView.hidden=NO;
            if ([isShopRest intValue]==1) {
                cell.redView.hidden=NO;
            }else{
                cell.redView.hidden=YES;
            }
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EPNewsCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    EPNewsDetailVC * VC=[[EPNewsDetailVC alloc]init];
    if ([cell.titile.text isEqualToString:@"易品"]) {
        VC.dataArr=self.jifenArr;
    }else if ([cell.titile.text isEqualToString:@"召车消息"]){
        VC.dataArr=self.carArr;
    }else if ([cell.titile.text isEqualToString:@"订单消息"]){
        VC.dataArr=self.orderArr;
    }
    VC.news=cell.titile.text;
    [self.navigationController pushViewController:VC animated:YES];
}
-(NSMutableArray *)jifenArr
{
    if (!_jifenArr) {
        _jifenArr = [NSMutableArray array];
    }
    return _jifenArr;
}
-(NSMutableArray *)carArr
{
    if (!_carArr) {
        _carArr = [NSMutableArray array];
    }
    return _carArr;
}
-(NSMutableArray *)orderArr
{
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
