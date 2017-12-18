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
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "EPAnalysis.h"
#import "FileHander.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "EPMoreController.h"
#import "EPViewInCell.h"
#import "EPSpendView.h"
#import "EPGoodsDetailVC.h"
#import "NSString+PlaceholderString.h"

static NSString * const kSection1 = @"200积分专区";
static NSString * const kSection2 = @"500积分专区";
static NSString * const kSection3 = @"全部商品";

@interface EPSpendViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * titles;
@property (nonatomic, strong) NSMutableArray * getDataArrUp;
@property (nonatomic, strong) NSMutableArray * getDataArrDown;
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
            // [self prepareForData];
        }
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [EPTool addMBProgressWithView:self.view style:0];
    [EPTool showMBWithTitle:@"正在加载..."];
    self.tableVi.hidden=YES;
    [self prepareForData];
    
//    [self readLocaLData];
    [self prepareForTableViewHeaderView];
    //更改导航栏背景图片
    [self addNavigationBar:2 title:@"花积分"];
}
- (NSMutableArray *)titles
{
    if (!_titles)
    {
        self.titles = [NSMutableArray array];
        self.titles[0] = kSection1;
        self.titles[1] = kSection2;
        self.titles[2] = kSection3;
    }
    return _titles;
}

- (void)prepareForData
{
    EPData * data =[EPData new];
    [data getSpendInfoWithCompletion:^(NSString *returnCode, NSString *msg,id responseObject)
     {
         [self getDataWithDic:responseObject withSpendUp:YES];
         [self prepareForTableViewHeaderView];
         [EPTool hiddenMBWithDelayTimeInterval:0];
         self.tableVi.hidden=NO;
         [self.tableVi reloadData];
         
     }];
    
    [data getSpendDownInfoWithCompletion:^(NSString *returnCode, NSString *msg, id responseObject) {
        [self getDataWithDic:responseObject withSpendUp:NO];
        [self.tableVi reloadData];
    }];
}
-(void)getDataWithDic:(id)responseObject withSpendUp:(BOOL)isUp
{
    if (isUp)
    {
        NSArray * arr1 = responseObject[@"bannerArr"];
        NSArray * data1 = [EPMainModel mj_objectArrayWithKeyValuesArray:arr1];
        NSArray * arr2 =responseObject[@"costScoreActivity1Arr"];
        NSArray * data2 =[EPMainModel mj_objectArrayWithKeyValuesArray:arr2];
        NSArray * arr3 = responseObject[@"costScoreActivity2Arr"];
        NSArray * data3 = [EPMainModel mj_objectArrayWithKeyValuesArray:arr3];
        
        self.getDataArrUp=[[NSMutableArray alloc] initWithObjects:data1,data2,data3, nil];
    }
    else
    {
        NSArray * arr4 =responseObject[@"goodsArr"];
        NSArray * data4 =[EPMainModel mj_objectArrayWithKeyValuesArray:arr4];
        self.getDataArrDown=[[NSMutableArray alloc] initWithObjects:data4, nil];
    }
    
}
- (void)readLocaLData
{
    FileHander *hander = [FileHander shardFileHand];
    NSMutableDictionary *responseObject =(NSMutableDictionary *)[hander readFile:@"spendModule"];
    if (responseObject)
    {
        [EPTool hiddenMBWithDelayTimeInterval:0];
        [self getDataWithDic:responseObject withSpendUp:YES];
    }
    [self prepareForTableViewHeaderView];
}
- (void)prepareForTableViewHeaderView
{
    UIView * headImgView =[[UIView alloc] init];
    headImgView.frame=CGRectMake(0, 0, EPScreenW, 151);
    NSArray *bannArr = self.getDataArrUp[0];
    NSMutableArray * imgName = [NSMutableArray array];
    for (EPMainModel *model  in bannArr)
    {
        [imgName addObject:model.goodsSaleImg];
    }
    SDCycleScrollView *Cycle = [SDCycleScrollView cycleScrollViewWithFrame:headImgView.frame delegate:self placeholderImage:[UIImage imageNamed:@"banner图"]];
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
    EPGoodsDetailVC * Detail=[[EPGoodsDetailVC alloc]init];
    NSArray *bannArr = self.getDataArrUp[0];
    EPMainModel *data =bannArr[index];
    Detail.goodsId =data.goodsId;
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
        NSArray * arr =self.getDataArrDown[0];
        return arr.count;
    }
    else
    {
//        NSArray * wholeArr = self.getDataArrUp[section+1];
//        if (wholeArr.count>2) return 2;
//        else return 1;
        return 1;
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier1 =@"cell4";
    static NSString * cellIdentifier2 =@"cell3";
    
    EPSpendCell * cell1 =nil;
    
    if (indexPath.section == 0)
    {
        cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell1)
        {
            cell1=[[[NSBundle mainBundle]loadNibNamed:@"EPSpendCell" owner:nil options:nil]objectAtIndex:1];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        NSArray * wholeArr = self.getDataArrUp[1];
        if (wholeArr.count==0)
        {
            NSLog(@"这个里面啥也没有");
        }
        else if (wholeArr.count==2)
        {
            EPMainModel * model = wholeArr[0];
            [cell1.imgs1 sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"500积分测试"]];
            //商品名称
            cell1.goodsLabel.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"优质黄桃"];
            //商品详细说明
            cell1.detailLabel.hidden = YES;
            //商品月售数量
            cell1.mouthSalesLabel.text = [NSString stringByRealString:model.goodsCounts WithReplaceString:@"月售2份"];
            //商品价格
            NSString * priceString = [NSString stringWithFormat:@"¥ %@",model.goodsPrice];
            cell1.prices1.text = [NSString stringByRealString:priceString WithReplaceString:@"¥99.99"];
            cell1.btns1.tag = [model.goodsId intValue];
            [cell1.btns1 addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            EPMainModel * model1 = wholeArr[1];
            [cell1.imgs2 sd_setImageWithURL:[NSURL URLWithString:model1.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"500积分测试"]];
            cell1.goodsLabel2.text = [NSString stringByRealString:model1.goodsName WithReplaceString:@"优质黄桃"];
            cell1.detailLabel2.hidden = YES;
            cell1.mouthSalesLabel2.text = [NSString stringByRealString:model1.goodsCounts WithReplaceString:@"月售2份"];
            NSString * priceString2 = [NSString stringWithFormat:@"¥ %@",model1.goodsPrice];
            cell1.prices2.text = [NSString stringByRealString:priceString2 WithReplaceString:@"¥99.99"];
            cell1.btns2.tag = [model1.goodsId intValue];
            [cell1.btns2 addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if (wholeArr.count==1)
        {
            EPMainModel * model = wholeArr[0];
            [cell1.imgs1 sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"500积分测试"]];
            cell1.goodsLabel.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"优质黄桃"];
            cell1.detailLabel.hidden = YES;
            cell1.mouthSalesLabel.text = [NSString stringByRealString:model.goodsCounts WithReplaceString:@"月售2份"];
            //商品价格
            NSString * priceString = [NSString stringWithFormat:@"¥ %@",model.goodsPrice];
            cell1.prices1.text = [NSString stringByRealString:priceString WithReplaceString:@"¥99.99"];
            cell1.btns1.tag = [model.goodsId intValue];
            [cell1.btns1 addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell1.imgs2.hidden = YES;
            cell1.btns2.hidden = YES;
            cell1.heart2.hidden = YES;
            cell1.prices2.hidden = YES;
            cell1.goodsLabel2.hidden = YES;
            cell1.detailLabel2.hidden = YES;
            cell1.mouthSalesLabel2.hidden = YES;
        }
        else
        {
            NSLog(@"服务器你不按套路出牌啊! 有错啊!");
        }
            
        
        
        return cell1;
    }
    else if (indexPath.section == 1)
    {
        cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell1)
        {
            cell1=[[[NSBundle mainBundle]loadNibNamed:@"EPSpendCell" owner:nil options:nil]objectAtIndex:1];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        NSArray * wholeArr = self.getDataArrUp[2];
        if (wholeArr.count==0)
        {
            NSLog(@"这个里面啥也没有");
        }
        else if (wholeArr.count==2)
        {
            EPMainModel * model = wholeArr[0];
            [cell1.imgs1 sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"500积分测试"]];
            //商品名称
            cell1.goodsLabel.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"优质黄桃"];
            //商品详细说明
            cell1.detailLabel.hidden = YES;
            //商品月售数量
            cell1.mouthSalesLabel.text = [NSString stringByRealString:model.goodsCounts WithReplaceString:@"月售2份"];
            //商品价格
            NSString * priceString = [NSString stringWithFormat:@"¥ %@",model.goodsPrice];
            cell1.prices1.text = [NSString stringByRealString:priceString WithReplaceString:@"¥99.99"];
            cell1.btns1.tag = [model.goodsId intValue];
            [cell1.btns1 addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            EPMainModel * model1 = wholeArr[1];
            [cell1.imgs2 sd_setImageWithURL:[NSURL URLWithString:model1.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"500积分测试"]];
            cell1.goodsLabel2.text = [NSString stringByRealString:model1.goodsName WithReplaceString:@"优质黄桃"];
            cell1.detailLabel2.hidden = YES;
            cell1.mouthSalesLabel2.text = [NSString stringByRealString:model1.goodsCounts WithReplaceString:@"月售2份"];
            NSString * priceString2 = [NSString stringWithFormat:@"¥ %@",model1.goodsPrice];
            cell1.prices2.text = [NSString stringByRealString:priceString2 WithReplaceString:@"¥99.99"];
            cell1.btns2.tag = [model1.goodsId intValue];
            [cell1.btns2 addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (wholeArr.count==1)
        {
            EPMainModel * model = wholeArr[0];
            [cell1.imgs1 sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg] placeholderImage:[UIImage imageNamed:@"500积分测试"]];
            cell1.goodsLabel.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"优质黄桃"];
            cell1.detailLabel.hidden = YES;
            cell1.mouthSalesLabel.text = [NSString stringByRealString:model.goodsCounts WithReplaceString:@"月售2份"];
            //商品价格
            NSString * priceString = [NSString stringWithFormat:@"¥ %@",model.goodsPrice];
            cell1.prices1.text = [NSString stringByRealString:priceString WithReplaceString:@"¥99.99"];
            cell1.btns1.tag = [model.goodsId intValue];
            [cell1.btns1 addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell1.imgs2.hidden = YES;
            cell1.btns2.hidden = YES;
            cell1.heart2.hidden = YES;
            cell1.prices2.hidden = YES;
            cell1.goodsLabel2.hidden = YES;
            cell1.detailLabel2.hidden = YES;
            cell1.mouthSalesLabel2.hidden = YES;
            
        }
        else
        {
            NSLog(@"服务器你不按套路出牌啊! 有错啊!");
        }
        
        return cell1;
    }
    else
    {
        cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (!cell1)
        {
            cell1=[[NSBundle mainBundle]loadNibNamed:@"EPSpendCell" owner:nil options:nil][2];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        NSArray * wholeArr = self.getDataArrDown[0];
        EPMainModel * model = wholeArr[indexPath.row];
        [cell1.commodityImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg] placeholderImage:[UIImage imageNamed:@"200积分测试图"]];
        cell1.commodityName.text = [NSString stringByRealString:model.goodsName WithReplaceString:@"商品名称"];
        NSString * str = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
        cell1.commodityPrice.text = [NSString stringByRealString:str WithReplaceString:@"¥1.00"];
        cell1.commoditySales.text = [NSString stringByRealString:model.sellCounts WithReplaceString:@"已售30个"];
        cell1.myID = [model.goodsId integerValue];
        return cell1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 || indexPath.section == 1)
    {
        return 185;
    }
    else
    {
        return 110;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vi =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 40)];
    vi.backgroundColor=[UIColor whiteColor];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(vi.frame)-40, 8, 30, 30);
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"花积分-更多"] forState:UIControlStateNormal];
    rightBtn.tag=section*10;
    [rightBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:rightBtn];
    
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 21)];
    titleLab.font=[UIFont systemFontOfSize:15];
    switch (section)
    {
        case 0:
            titleLab.text= [NSString stringByRealString:self.titles[0] WithReplaceString:@"200积分专区"];
            break;
        case 1:
            titleLab.text=[NSString stringByRealString:self.titles[1] WithReplaceString:@"500积分专区"];
            break;
        case 2:
            titleLab.text=[NSString stringByRealString:self.titles[2] WithReplaceString:@"全部商品"];
            break;
            
        default:
            break;
    }
    
    [vi addSubview:titleLab];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(15, CGRectGetMaxY(vi.frame)-1, EPScreenW-30, 1);
    lineView.backgroundColor = RGBColor(153, 153, 153);
    [vi addSubview:lineView];
    
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
        EPGoodsDetailVC * Detail=[[EPGoodsDetailVC alloc]init];
        Detail.goodsId=[NSString stringWithFormat:@"%ld",(long)lastCell.myID];
        [self.navigationController pushViewController:Detail animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = 30;
    CGFloat sectionFooterHeight = 8;
    CGFloat offsetY = tableview.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
    }
}

- (void)firstBtnClick:(UIButton*)btn
{
    //跳转到商品详情
    EPGoodsDetailVC * Detail=[[EPGoodsDetailVC alloc]init];
    Detail.goodsId=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:Detail animated:YES];
}
- (void)secondBtnClick:(UIButton*)btn
{
    //跳转到商品详情
    EPGoodsDetailVC * Detail=[[EPGoodsDetailVC alloc]init];
    Detail.goodsId=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:Detail animated:YES];
}
//去更多界面
- (void)changePage:(UIButton *)btn
{
    NSInteger indexPath = btn.tag/10;
    EPMoreController * vc =[[EPMoreController alloc] init];
    switch (indexPath) {
        case 0:
        {
            vc.moreArr=self.getDataArrUp[1];
            
        }
            break;
        case 1:
        {
            vc.moreArr=self.getDataArrUp[2];
            
        }
            break;
        case 2:
        {
            vc.moreArr=self.getDataArrDown[0];
            
        }
            break;
            
        default:
            break;
    }
    vc.titles=self.titles[indexPath];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toNext:(UIButton *)btn
{
    //跳转到商品详情
    EPGoodsDetailVC * Detail=[[EPGoodsDetailVC alloc]init];
    Detail.goodsId=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:Detail animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
