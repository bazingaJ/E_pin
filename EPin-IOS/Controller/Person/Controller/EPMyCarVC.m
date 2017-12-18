//
//  EPMyCarVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/7.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMyCarVC.h"
#import "HeaderFile.h"
#import "EPAddInfoVC.h"
#import "EPCarModel.h"
@interface EPMyCarVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation EPMyCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"我的车辆"];
    [self tb];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCarData];
}
- (void)getCarData{
    [self.dataSource removeAllObjects];
    EPData * data=[EPData new];
    [data bindCarMessageWithType:@"1" withPlateNo:nil withEnineNo:nil withCarNo:nil withCompletion:^(NSString *returnCode, NSString *msg,NSMutableDictionary * dic) {
       // NSLog(@"获取车辆====%@",dic);
        if ([returnCode intValue]==0) {
            NSArray * arr=dic[@"PassengerCarArr"];
            for (NSDictionary * dict in arr) {
                EPCarModel * model=[EPCarModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:model];
            }
        }
        [self.tb reloadData];
    }];
}
- (void)deleteTanchu:(UIButton *)btn
{
    NSInteger  index=btn.tag-900;
    EPCarModel * model=[self.dataSource objectAtIndex:index];
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"确定取消绑定该车辆？" count:1 doWhat:^{
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@""];
        EPData * data=[EPData new];
        [data bindCarMessageWithType:@"2" withPlateNo:nil withEnineNo:nil withCarNo:model.plateNo withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            if ([returnCode intValue]==0) {
                [self getCarData];
            }else if ([returnCode intValue]==2){
                [EPLoginViewController publicDeleteInfo];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                    EPLoginViewController * login=[[EPLoginViewController alloc]init];
                    [self presentViewController:login animated:YES completion:nil];
                }];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题,删除车辆失败，请稍后重试" count:0 doWhat:nil];
            }
        }];
    }];
}
- (void)addCar{
    EPAddInfoVC * vc=[[EPAddInfoVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma---------- tableViewDelegate--------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.dataSource.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str=@"cellID";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    if (indexPath.section==0) {
        if (self.dataSource.count>0) {
            EPCarModel * model=[self.dataSource objectAtIndex:indexPath.row];
            UIView * vc=[[UIView alloc]init];
            [cell.contentView addSubview:vc];
            vc.backgroundColor=[UIColor whiteColor];
            vc.frame=CGRectMake(0, 0, EPScreenW, 60);
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [vc addSubview:btn];
            CGSize ss=[UIImage imageNamed:@"shanchu"].size;
            btn.frame=CGRectMake(EPScreenW-40-ss.width, 0, 40+ss.width, 60);
            [btn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
            btn.tag=indexPath.row+900;
            [btn addTarget:self action:@selector(deleteTanchu:) forControlEvents:UIControlEventTouchUpInside];
            UILabel * lb1=[[UILabel alloc]init];
            [vc addSubview:lb1];
            lb1.frame=CGRectMake(20,10,200 , 17);
            lb1.font=[UIFont systemFontOfSize:16];
            lb1.textColor=RGBColor(0, 0, 0);
            lb1.text=model.plateNo;
            UILabel * lb2=[[UILabel alloc]init];
            [vc addSubview:lb2];
            lb2.frame=CGRectMake(20,60-13-10,200 ,13);
            lb2.font=[UIFont systemFontOfSize:13];
            lb2.textColor=RGBColor(128, 128, 128);
            lb2.text=[NSString stringWithFormat:@"发动机缸号:%@",model.engineNo];
            
        }
        
    }else{
        UIView * vc=[[UIView alloc]init];
        vc.frame=CGRectMake((EPScreenW-160)/2, 0, 160, 50);
        [cell.contentView addSubview:vc];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0,0,30,50);
        [btn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addCar) forControlEvents:UIControlEventTouchUpInside];
        [vc addSubview:btn];
        
        UILabel * lb=[[UILabel alloc]init];
        lb.x=CGRectGetMaxX(btn.frame)+6;
        lb.y=15;
        lb.width=124;
        lb.height=20;
        lb.text=@"点击添加车辆";
        lb.font=[UIFont systemFontOfSize:18];
        lb.textColor=RGBColor(128, 128, 128);
        [vc addSubview:lb];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 60;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        EPAddInfoVC * vc=[[EPAddInfoVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, EPScreenW, EPScreenH-64) style:UITableViewStylePlain];
        _tb.dataSource=self;
        _tb.delegate=self;
        _tb.separatorInset=UIEdgeInsetsMake(59, 20, 1, 20);
        _tb.separatorColor=RGBColor(238,238,238);
        _tb.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_tb];
    }
    return _tb;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
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
