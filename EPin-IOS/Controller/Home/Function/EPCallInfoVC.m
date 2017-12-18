//
//  EPCallInfoViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/4/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCallInfoVC.h"
#import "HeaderFile.h"
#import "EPNowOrderCell.h"
#import "MJRefresh.h"
#import "NSString+PlaceholderString.h"

@interface EPCallInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray * getArr;
//选中的单元格数组 记录索引
@property (nonatomic, strong) NSMutableArray * selectedArr;

@end

@implementation EPCallInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareForNav];
    [self prepareForData];
    
    //初始化选中单元格数组
    self.selectedArr = [[NSMutableArray alloc] initWithCapacity:0];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDownRefresh];
}
- (void)setDownRefresh
{
    self.tableVi.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(prepareForData)];
    [self.tableVi.mj_header beginRefreshing];
}
- (void)prepareForNav
{
    [self addNavigationBar:0 title:@"召车历史"];
}
- (void)prepareForData
{
    EPData * data=[EPData new];
    [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"" WhatToDo:@"3" withOrderNumber:@"" withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0)
        {
            [self.tableVi.mj_header endRefreshing];
            self.getArr=dic[@"getCallCarArr"];
            [self.tableVi reloadData];
        }
        else if ([returnCode intValue]==1)
        {
            self.getArr=[NSArray array];
            [self.tableVi.mj_header endRefreshing];
            [self.tableVi reloadData];
//            [EPTool addAlertViewInView:self title:@"" message:msg count:0 doWhat:nil];
        }
        else if ([returnCode intValue]==2)
        {
            [self.tableVi.mj_header endRefreshing];
            [EPTool addAlertViewInView:self title:@"" message:msg count:0 doWhat:^{
                EPLoginViewController * vc =[[EPLoginViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
            }];
        }
        else
        {
            [self.tableVi.mj_header endRefreshing];
            [EPTool addAlertViewInView:self title:@"" message:@"您的网络似乎有点问题,请重新尝试" count:0 doWhat:nil];
        }
    }];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.getArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier1 =@"cell4";
    EPNowOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EPNowOrderCell" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary * smallDic =self.getArr[indexPath.row];
    NSString * type =smallDic[@"useType"];
    if ([type intValue] == 0 || [type intValue] == 1)
    {
        if ([type intValue]==0)
        {
            cell.typeLabel.text=@"[现在]";
        }
        if ([type intValue]==1)
        {
            cell.typeLabel.text=@"[预约]";
        }
        NSString * status =smallDic[@"status"];
        if ([status intValue]==3)
        {
            cell.statusLabel.text=@"已取消";
        }
        if ([status intValue]==4 || [status intValue]==6)
        {
            cell.statusLabel.text=@"已完成";
        }
        cell.timeLabel.text=smallDic[@"time"];
        cell.startLocation.text=smallDic[@"address"];
        cell.destination.text=smallDic[@"destination"];
        cell.cellOrderId = smallDic[@"orderId"];
        
        for (NSNumber * number in _selectedArr)
        {
            if (indexPath.row == [number integerValue])
            {
                [self starClickBtn:cell.judgeBtn];
                NSLog(@"%@====",_selectedArr);
            }
        }
        
        cell.judgeBtn.enabled=NO;
        [cell.judgeBtn addTarget:self action:@selector(commitJudge) forControlEvents:UIControlEventTouchUpInside];
        [cell.star1 addTarget:self action:@selector(starClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.star2 addTarget:self action:@selector(starClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.star3 addTarget:self action:@selector(starClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
//        NSString * starCondition = [NSString stringByRealString:smallDic[@"commentStar"] WithReplaceString:@""];
//        //没有星星评价---未评价
//        if (starCondition.length == 0)
//        {
//            //星星状态不发生改变
//            
//        }
//        else
//        {
//            
//        }
        
        
        
        
    }
    
    return cell;
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableVi setEditing:editing animated:animated];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        [self requestWithCancelHistoryWithIndex:indexPath.row];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 25)];
    view.backgroundColor=RGBColor(234, 234, 234);
    
    UILabel * lab =[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 80, 21)];
    lab.text=@"已完成订单";
    lab.textColor=RGBColor(102, 102, 102);
    lab.font=[UIFont systemFontOfSize:12];
    [view addSubview:lab];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123;
}
- (void)requestWithCancelHistoryWithIndex:(NSInteger)index
{
    EPData * data =[EPData new];
    NSDictionary * smallDic =self.getArr[index];
    NSString * numberStr =smallDic[@"orderId"];
    [data getCallCarDataWithGetCarTime:@"" WithGetCarAddress:@"" WtihDestination:@"" WithContect:@"" WithUserType:@"" WhatToDo:@"4" withOrderNumber:numberStr withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            if ([returnCode intValue]==0)
            {
                [self prepareForData];
            }
            else if ([returnCode intValue]==1)
            {
                [EPTool addAlertViewInView:self title:@"" message:msg count:0 doWhat:nil];
            }
            else if ([returnCode intValue]==2)
            {
                [EPTool addAlertViewInView:self title:@"" message:msg count:0 doWhat:^{
                    EPLoginViewController * vc =[[EPLoginViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }];
            }
            else
            {
                [EPTool addAlertViewInView:self title:@"" message:@"您的网络似乎有点问题,请重新尝试" count:0 doWhat:nil];
            }
    }];
}

- (void)starClickBtn:(UIButton *)sender
{
    EPNowOrderCell * cell = (EPNowOrderCell *)[[sender superview]superview];
    
    NSIndexPath * indexPath = [self.tableVi indexPathForCell:cell];
    
    NSNumber * numberIndex = [NSNumber numberWithInteger:indexPath.row];
    [self.selectedArr addObject:numberIndex];
    
    [cell.judgeBtn setTitle:@"提交" forState:UIControlStateNormal];
    [cell.judgeBtn setBackgroundColor:[UIColor redColor]];
    cell.judgeBtn.enabled = YES;
    switch (sender.tag)
    {
        case 1:
        {
            cell.star1.selected = YES;
            cell.star2.selected = NO;
            cell.star3.selected = NO;
        }
            break;
        case 2:
        {
            cell.star1.selected = YES;
            cell.star2.selected = YES;
            cell.star3.selected = NO;
        }
            break;
        case 3:
        {
            cell.star1.selected = YES;
            cell.star2.selected = YES;
            cell.star3.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)commitJudge
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
