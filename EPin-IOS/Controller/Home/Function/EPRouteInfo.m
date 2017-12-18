//
//  EPMoreWayVC.m
//  EPin-IOS
//
//  Created by jeader on 16/5/3.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPRouteInfo.h"
#import "HeaderFile.h"
#import "EPWayCell.h"
#import "EPData.h"

@class EPTool;

@interface EPRouteInfo ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
}
@property (nonatomic, strong) NSArray * travelArr;
@property (nonatomic, strong) NSDictionary * tempDic;
@end

@implementation EPRouteInfo

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareForNav];
    [self prepareForData];
}
//获取请求数据
- (void)prepareForData
{
    self.travelArr=[NSArray array];
    EPData * data =[EPData new];
    [data getTravelInfoWithNumber:@"" withLostId:@"" withType:@"0" withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic)
     {
        self.travelArr=dic[@"getTravelArr"];
        [self.tableVi reloadData];
    }];
}
- (void)prepareForNav
{
    [self addNavigationBar:0 title:@"行程信息"];
    self.tableVi.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 20)];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)                                                                                                                                                                                                                                                                                                                                                                                                                                               tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _travelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier1 =@"cell1";
    EPWayCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EPWayCell" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary * smallDic=_travelArr[indexPath.row];
    cell.payTime.text=smallDic[@"time"];
    cell.plateNo.text=smallDic[@"plateNo"];
    cell.moneyLab.text=smallDic[@"address"];
    cell.pointLab.text=smallDic[@"destination"];
    [cell.choiceBtn addTarget:self action:@selector(choiceBntClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.choiceBtn.tag=indexPath.row;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123;
}

- (void)choiceBntClick:(UIButton *)btn
{
    NSIndexPath * lastIndexPath =[NSIndexPath indexPathForRow:_index inSection:0];
    EPWayCell * lastCell =[self.tableVi cellForRowAtIndexPath:lastIndexPath];

    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:btn.tag inSection:0];
    EPWayCell * nowCell =[self.tableVi cellForRowAtIndexPath:indexPath];
    
    if (lastIndexPath.row != indexPath.row)
    {
        lastCell.choiceBtn.selected=NO;
    }
    nowCell.choiceBtn.selected=YES;

    _index=indexPath.row;
    
    NSDictionary * smallDic=_travelArr[indexPath.row];
    //把付款时间和车牌号码 存储到本地 pop回去的时候 直接从本地取
    NSString * saveStr =[NSString stringWithFormat:@"付款时间: %@\n\n车牌号码: %@",smallDic[@"time"],smallDic[@"plateNo"]];
    //把相对应的number 存到本地
    NSString * numberStr =smallDic[@"number"];
    self.tempDic =[NSDictionary dictionaryWithObjectsAndKeys:saveStr,@"lostInfo",numberStr,@"lostNum", nil];
    
    [self performSelector:@selector(delayPerform) withObject:nil afterDelay:0.35];
}
- (void)delayPerform
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"road" object:nil userInfo:self.tempDic];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
