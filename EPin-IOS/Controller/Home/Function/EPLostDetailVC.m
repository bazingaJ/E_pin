//
//  EPFoundViewController.m
//  EPin-IOS
//  失物招领 详情
//  Created by jeader on 16/4/2.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPLostDetailVC.h"
#import "EPLostCell.h"
#import "HeaderFile.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "EPMoreWayVC.h"
#import "UIImageView+photoBrowser.h"

@interface EPLostDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pleaceImg;
@property (nonatomic, strong) NSMutableArray *lostArr;
@property (nonatomic, strong) NSMutableArray *lostTimeArr;
@property (nonatomic, strong) NSMutableArray *lostTypeArr;
@property (nonatomic, strong) NSMutableArray *lostDescArr;
@property (nonatomic, strong) NSMutableArray *lostIdArr;
@end

@implementation EPLostDetailVC
static NSString * const path=@"lostOther";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:self.getString];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getLostData];
    
}
-(void)readLocaLData
{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:@"lostOther"];
    if (responseObject)
    {
        [self getDataWithDic:responseObject];
    }
}
-(void)getLostData{
    EPData *data = [EPData new];
    NSString*type = [NSString stringWithFormat:@"%ld",(long)self.type];
    [data getLosterDataWithType:type withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic)
    {
        FileHander *hander = [FileHander shardFileHand];
        [self getDataWithDic:dic];
        NSString *sss=@"ss";
        [hander saveFile:dic withForName:@"lostOther" withError:&sss];
        if (self.lostArr.count==0)
        {
            self.tableVi.hidden = YES;
            self.pleaceImg.hidden = NO;
        }else{
            self.tableVi.hidden = NO;
            self.pleaceImg.hidden = YES;
            [self.tableVi reloadData];
        }
    }];
}
-(void)getDataWithDic:(id)dic{
    NSArray *lost = dic[@"lostArr"];
    NSMutableArray *lostArr = [EPMainModel mj_objectArrayWithKeyValuesArray:lost];
    NSMutableArray *lostImageArr = [NSMutableArray array];
    NSMutableArray *lostTimeArr = [NSMutableArray array];
    NSMutableArray *lostTypeArr = [NSMutableArray array];
    NSMutableArray *lostDescArr = [NSMutableArray array];
    NSMutableArray *lostIdArr   = [NSMutableArray array];
    for (EPMainModel *mode in lostArr) {
        [lostImageArr addObject:mode.lostImage];
        [lostTimeArr addObject:mode.lostTime];
        [lostTypeArr addObject:mode.lostType];
        if (mode.lostDesc) {
            [lostDescArr addObject:mode.lostDesc];
        }else{
            NSString *desc = @"暂无描述";
            [lostDescArr addObject:desc];
        }

        [lostIdArr addObject:mode.lostId];
    }
    self.lostTypeArr = lostTypeArr;
    self.lostTimeArr = lostTimeArr;
    self.lostArr = lostImageArr;
    self.lostDescArr=lostDescArr;
    self.lostIdArr=lostIdArr;
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lostArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier =@"cell1";
    EPLostCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EPLostCell" owner:nil options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.lostArr.count>0)
    {
        [cell.lostThing sd_setImageWithURL:[NSURL URLWithString:self.lostArr[indexPath.row]]];
        [cell.lostThing showBiggerPhotoInview:self.view];
        cell.someThing.text = self.lostTypeArr[indexPath.row];
        cell.lostTime.text = self.lostTimeArr[indexPath.row];
        NSString * decscribel=self.lostDescArr[indexPath.row];
        if (decscribel.length != 0)
        {
            cell.describeLab.text=decscribel;
        }
        
        cell.takeBtn.layer.masksToBounds=YES;
        cell.takeBtn.layer.cornerRadius=3;
        cell.takeBtn.tag=indexPath.row;
        [cell.takeBtn addTarget:self action:@selector(goGetIt:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.someThing.text=self.getString;
        cell.takeBtn.layer.masksToBounds=YES;
        cell.takeBtn.layer.cornerRadius=3;
        cell.takeBtn.tag=indexPath.row;
        [cell.takeBtn addTarget:self action:@selector(goGetIt:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (void)goGetIt:(UIButton *)button
{
    EPMoreWayVC * vc =[[EPMoreWayVC alloc] init];
    vc.lostId=self.lostIdArr[button.tag];
    [self.navigationController pushViewController:vc  animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
