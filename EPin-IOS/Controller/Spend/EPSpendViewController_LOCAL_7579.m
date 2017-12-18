//
//  SpenViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/3/30.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSpendViewController.h"
#import "HeaderFile.h"
#import "EPSpendCell.h"
#import "EPDetailViewController.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "EPAnalysis.h"
#import "FileHander.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "EPMoreController.h"
#import "EPShopCell.h"

@interface EPSpendViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * titles;
@property (nonatomic, strong) NSArray * getDataArr;
@property (nonatomic, strong) NSArray * dataArr;
@end

@implementation EPSpendViewController
- (void)viewWillAppear:(BOOL)animated
{
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode == 0)
        {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
            [self readLocaLData];
        }
        else
        {
            [self prepareForData];
        }
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [EPTool addMBProgressWithView:self.view style:0];
    [EPTool showMBWithTitle:@"正在加载..."];
    self.tableVi.hidden=YES;
    [self readLocaLData];
    [self setupNavView];
}
- (void)prepareForData
{
    EPData * data =[EPData new];
    [data getSpendInfoWithCompletion:^(NSString *returnCode, NSString *msg,id responseObject)
    {
        [self getDataWithDic:responseObject];
        [self prepareForTableViewHeaderView];
        [EPTool hiddenMBWithDelayTimeInterval:0];
        self.tableVi.hidden=NO;
        [self.tableVi reloadData];
    }];
}
-(void)getDataWithDic:(id)responseObject
{
    NSArray * arr1 = responseObject[@"bannerImg"];
    NSArray * data1 = [EPMainModel mj_objectArrayWithKeyValuesArray:arr1];
//    NSArray * arr2 =responseObject[@"guessLike"];
//    NSArray * data2 =[EPMainModel mj_objectArrayWithKeyValuesArray:arr2];
//    NSArray * arr3 = responseObject[@"hotRecommend"];
//    NSArray * data3 = [EPMainModel mj_objectArrayWithKeyValuesArray:arr3];
    NSArray * arr2 =responseObject[@"secondRegion"];
    NSArray * data2 =[EPMainModel mj_objectArrayWithKeyValuesArray:arr2];
    NSArray * arr3 = responseObject[@"thirdRegion"];
    NSArray * data3 = [EPMainModel mj_objectArrayWithKeyValuesArray:arr3];
    NSArray * arr4 =responseObject[@"wholeGoods"];
    NSArray * data4 =[EPMainModel mj_objectArrayWithKeyValuesArray:arr4];
    NSArray * arrr =@[data1,data2,data3,data4];
    self.getDataArr = arrr;
}
- (void)readLocaLData
{
    FileHander *hander = [FileHander shardFileHand];
    NSMutableDictionary *responseObject =(NSMutableDictionary *)[hander readFile:@"spendModule"];
    if (responseObject)
    {
        [EPTool hiddenMBWithDelayTimeInterval:0];
        [self getDataWithDic:responseObject];
    }
    [self prepareForTableViewHeaderView];
}
- (void)setupNavView
{
    //更改导航栏背景图片
    [self addNavigationBar:2 title:@"花积分"];
    self.titles=[[NSMutableArray alloc] initWithObjects:@"200积分专区",@"500积分专区",@"全部商品", nil];
    
}
- (void)prepareForTableViewHeaderView
{
    UIView * headImgView =[[UIView alloc] init];
    headImgView.frame=CGRectMake(0, 0, EPScreenW, 150);
    NSArray *bannArr = self.getDataArr[0];
    NSMutableArray * imgName = [NSMutableArray array];
    for (EPMainModel *model  in bannArr)
    {
        [imgName addObject:model.bannerImg];
    }
    SDCycleScrollView *Cycle = [SDCycleScrollView cycleScrollViewWithFrame:headImgView.frame delegate:self placeholderImage:nil];
    Cycle.imageURLStringsGroup = imgName;
    Cycle.delegate = self;
    Cycle.showPageControl=YES;
    Cycle.autoScrollTimeInterval=4;
    [headImgView addSubview:Cycle];
    
    self.tableVi.tableHeaderView=headImgView;
}

//banner 图片选中时跳转方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    EPDetailViewController * Detail=[[EPDetailViewController alloc]init];
    NSArray *bannArr = self.getDataArr[0];
    EPMainModel *data =bannArr[index];
    Detail.goodId =data.goodsId;
    [self.navigationController pushViewController:Detail animated:YES];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        NSArray *Arr = self.getDataArr[3];
        return Arr.count;
    }
    else
    {
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier1 =@"cell2";
    static NSString * cellIdentifier3 =@"cell3";
    EPShopCell * cell1 =nil;
    EPSpendCell * cell =nil;
    if (indexPath.section==0)
    {
        cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell1)
        {
            cell1=[[NSBundle mainBundle]loadNibNamed:@"EPShopCell" owner:nil options:nil][1];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    
        NSArray *Arr = self.getDataArr[1];
        EPMainModel *data =  Arr[indexPath.row];
        NSLog(@"++++++++%f",[cell1 getCellWidth].size.width);
        
        [cell1.firstView sd_setImageWithURL:[NSURL URLWithString:data.secondImg] placeholderImage:nil];
        cell1.titleLabel.text=data.secondName;
        cell1.cheapLabel.text=@"";
        cell1.pointLabel.text=[NSString stringWithFormat:@"%@积分",data.secondPrice];
        [cell1.leftBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.leftBtn.tag=[data.goodsId intValue];
        
        EPMainModel *data1 =  Arr[indexPath.row+1];
        [cell1.secondView sd_setImageWithURL:[NSURL URLWithString:data1.secondImg] placeholderImage:nil];
        cell1.nameLabel.text=data1.secondName;
        cell1.infoLabel.text=@"";
        cell1.scoreLabel.text=[NSString stringWithFormat:@"%@积分",data1.secondPrice];
        [cell1.rightBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.rightBtn.tag=[data1.goodsId intValue];
        return cell1;
    }
    else if (indexPath.section == 1)
    {
        cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell1)
        {
            cell1=[[NSBundle mainBundle]loadNibNamed:@"EPShopCell" owner:nil options:nil][1];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        NSArray *Arr = self.getDataArr[2];
        EPMainModel *data =  Arr[indexPath.row];
        NSLog(@"---------%f",[cell1 getCellWidth].size.width);
        
        [cell1.firstView sd_setImageWithURL:[NSURL URLWithString:data.thirdImg] placeholderImage:nil];
        cell1.titleLabel.text=data.thirdName;
        cell1.cheapLabel.text=@"";
        cell1.pointLabel.text=[NSString stringWithFormat:@"%@积分",data.thirdPrice];
        [cell1.leftBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.leftBtn.tag=[data.goodsId intValue];
        
        EPMainModel *data1 =  Arr[indexPath.row+1];
        [cell1.secondView sd_setImageWithURL:[NSURL URLWithString:data1.thirdImg] placeholderImage:nil];
        cell1.nameLabel.text=data1.thirdName;
        cell1.infoLabel.text=@"";
        cell1.scoreLabel.text=[NSString stringWithFormat:@"%@积分",data1.thirdPrice];
        [cell1.rightBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.rightBtn.tag=[data1.goodsId intValue];
        return cell1;
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"EPSpendCell" owner:nil options:nil][2];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        NSArray *smallArr5 = self.getDataArr[3];
        EPMainModel *data =  smallArr5[0];
        data=smallArr5[indexPath.row];
        [cell.leadingImg sd_setImageWithURL:[NSURL URLWithString:data.goodsImg] placeholderImage:nil];
        cell.goodsName.text=data.goodsName;
        NSString * str =[NSString stringWithFormat:@"¥%@",data.goodsPrice];
        cell.goodsPrice.text=str;
        cell.discountsPrice.text=data.discountPrice;
        cell.sellCounts.text=data.sellCounts;
        cell.myID=[data.goodsId integerValue];
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 || indexPath.section == 1)
    {
        return 201;
    }
    else
    {
        return 96;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vi =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 30)];
    vi.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    
    UIView * whiteVi =[[UIView alloc] initWithFrame:CGRectMake(0, 5, EPScreenW, 25)];
    whiteVi.backgroundColor=[UIColor whiteColor];
    [vi addSubview:whiteVi];
    
    UIButton * rightBtn =[[UIButton alloc] initWithFrame:CGRectMake(EPScreenW-60, 5, 50, 21)];
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:131/255.0 green:131/255.0 blue:131 /255.0 alpha:1.0] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    rightBtn.tag=section*10;
    [rightBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [whiteVi addSubview:rightBtn];
    
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 21)];
    titleLab.font=[UIFont systemFontOfSize:15];
    switch (section) {
        case 0:
            titleLab.text=self.titles[0];
            break;
        case 1:
            titleLab.text=self.titles[1];
            break;
        case 2:
            titleLab.text=self.titles[2];
            break;
            
        default:
            break;
    }
    [whiteVi addSubview:titleLab];
    return vi;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2)
    {
        //找到点击了是哪一个cell
        NSIndexPath * lastIndexPath =[NSIndexPath indexPathForRow:indexPath.row inSection:2];
        EPSpendCell * lastCell =[tableView cellForRowAtIndexPath:lastIndexPath];
        //跳转到商品详情
        EPDetailViewController * Detail=[[EPDetailViewController alloc]init];
        Detail.goodId=[NSString stringWithFormat:@"%ld",(long)lastCell.myID];
        [self.navigationController pushViewController:Detail animated:YES];
    }
    
    
}
- (void)firstBtnClick:(UIButton*)btn
{
    //跳转到商品详情
    EPDetailViewController * Detail=[[EPDetailViewController alloc]init];
    Detail.goodId=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:Detail animated:YES];
}
- (void)secondBtnClick:(UIButton*)btn
{
    //跳转到商品详情
    EPDetailViewController * Detail=[[EPDetailViewController alloc]init];
    Detail.goodId=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:Detail animated:YES];
}
//去更多界面
- (void)changePage:(UIButton *)btn
{
    EPMoreController * vc =[[EPMoreController alloc] init];
    vc.titles=self.titles[btn.tag/10];
    vc.moreArr=self.getDataArr[btn.tag/10+1];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
