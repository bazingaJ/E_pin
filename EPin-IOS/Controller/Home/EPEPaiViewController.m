//
//  EPEPaiViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/7/14.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPEPaiViewController.h"
#import "HeaderFile.h"
#import "EPWinnerViewController.h"
#import "EPEpaiModel.h"
#import "MJRefresh.h"
#import "EPDynamic.h"

@interface EPEPaiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;

@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation EPEPaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:2 title:@"半价购"];
    [self addRightBtnWithFrame:CGRectMake(0, 10,80, 30) action:@selector(clickRightBarButtonItem) name:@"得主风采"];
    [self tb];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
- (void)getData{
    [self.dataArr removeAllObjects];
    EPData * data=[EPData new];
    [data getAuctionDataWithType:@"0" withGoodsId:nil withOrderId:nil  Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
       // NSLog(@"拍卖列表----%@",dic);
        if ([returnCode intValue]==0) {
            [self.tb.mj_header endRefreshing];
            NSArray * aucitionArr=dic[@"aucitionArr"];
            if (aucitionArr.count>0) {
                for (NSDictionary * dict in aucitionArr) {
                    EPEpaiModel * model=[EPEpaiModel mj_objectWithKeyValues:dict];
                    [self.dataArr addObject:model];
                }
            }else{
                UILabel * lb=[[UILabel alloc]init];
                [self.view addSubview:lb];
                lb.frame=CGRectMake(0, EPScreenH/2-10, EPScreenW, 20);
                lb.text=@"暂无商品";
                lb.font=[UIFont systemFontOfSize:14];
                lb.textAlignment=NSTextAlignmentCenter;
                lb.textColor=RGBColor(128, 128, 128);
            }
        }
        [self.tb reloadData];
    }];
}
- (void)setDownRefresh
{
    self.tb.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.tb.mj_header beginRefreshing];
}
/**得主风采*/
- (void)clickRightBarButtonItem{
        EPWinnerViewController * vc=[[EPWinnerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attri  =[NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize =CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArr.count>0) {
        EPEpaiModel * model=[self.dataArr objectAtIndex:indexPath.section];
        UIImageView * img=[[UIImageView alloc]init];
        img.frame=CGRectMake(0, 0, EPScreenW, 169);
        [img sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];
        [cell.contentView addSubview:img];
        
        UILabel * state=[[UILabel alloc]init];
        state.frame=CGRectMake(0, 0, 60, 30);
        [img addSubview:state];
        state.backgroundColor=[UIColor blackColor];
        state.alpha=0.75;
        state.textColor=[UIColor whiteColor];
        state.textAlignment=NSTextAlignmentCenter;
        state.font=[UIFont systemFontOfSize:14];
        if (model.subscribe==nil) {
            state.hidden=YES;
        }else if ([model.subscribe intValue]==1){
            state.text=@"认购中";
        }else if ([model.subscribe intValue]==0){
            state.text=@"待付款";
        }
        
        UIView * back=[[UIView alloc]init];
        back.frame=CGRectMake(0, 169-20, EPScreenW, 20);
        back.backgroundColor=[UIColor blackColor];
        back.alpha=0.75;
        [img addSubview:back];
        UILabel * endTime=[[UILabel alloc]init];
        endTime.frame=CGRectMake(0, 0, back.width, back.height);
        endTime.font=[UIFont systemFontOfSize:12];
        endTime.text=[NSString stringWithFormat:@"还有%@结束",model.lostTime];
        endTime.textColor=[UIColor whiteColor];
        endTime.textAlignment=NSTextAlignmentCenter;
        [back addSubview:endTime];
        
        UIView * vc=[[UIView alloc]init];
        vc.frame=CGRectMake(0, 169, EPScreenW, 62);
        vc.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:vc];
        
        CGSize s=[[UIImage imageNamed:@"price"] size];
        UIImageView * price=[[UIImageView alloc]init];
        price.y=0;
        price.width=s.width;
        price.height=62;
        price.x=EPScreenW-s.width;
        price.image=[UIImage imageNamed:@"price"];
        [vc addSubview:price];
        
        UILabel * lb1=[[UILabel alloc]init];
        [price addSubview:lb1];
        lb1.frame=CGRectMake(0, 8, price.width, 25);
        lb1.text=[NSString stringWithFormat:@"¥%@",model.goodsClapPrice];
        lb1.textAlignment=NSTextAlignmentCenter;
        lb1.font=[UIFont systemFontOfSize:24];
        lb1.textColor=RGBColor(218, 187, 132);
        
        UILabel * lb2=[[UILabel alloc]init];
        [price addSubview:lb2];
        lb2.frame=CGRectMake(0,CGRectGetMaxY(lb1.frame)+5, price.width,15);
        lb2.text=@"半价，巨优惠";
        lb2.textAlignment=NSTextAlignmentCenter;
        lb2.font=[UIFont systemFontOfSize:12];
        lb2.textColor=RGBColor(218, 187, 132);
        
        UILabel * name=[[UILabel alloc]init];
        name.frame=CGRectMake(12, 12, 250,16);
        name.font=[UIFont systemFontOfSize:16];
        name.text=model.goodsName;
        CGSize sizeName=[self sizeWithText:name.text font:[UIFont systemFontOfSize:16] maxW:EPScreenW-s.width];
        name.width=sizeName.width;
        [vc addSubview:name];
        UILabel * yuanPrice=[[UILabel alloc]init];
        yuanPrice.frame=CGRectMake(12,CGRectGetMaxY(name.frame)+10,120,15);
        yuanPrice.font=[UIFont systemFontOfSize:12];
        yuanPrice.textColor=RGBColor(153, 153, 153);
        yuanPrice.text=[NSString stringWithFormat:@"原价: %@",model.goodsPrice];
        CGSize size=[self sizeWithText:yuanPrice.text font:[UIFont systemFontOfSize:12] maxW:200];
        yuanPrice.size=size;
        [vc addSubview:yuanPrice];
        
        UILabel * perCount=[[UILabel alloc]init];
        perCount.frame=CGRectMake(CGRectGetMaxX(yuanPrice.frame)+21,CGRectGetMaxY(name.frame)+10, 120,15);
        perCount.font=[UIFont systemFontOfSize:12];
        perCount.textColor=RGBColor(153, 153, 153);
        perCount.text=[NSString stringWithFormat:@"认购人数: %@",model.onlookers];
        [vc addSubview:perCount];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 231;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 8;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count>0) {
        EPEpaiModel * model=[self.dataArr objectAtIndex:indexPath.section];
        EPDynamic *dynamic = [[EPDynamic alloc]init];
        dynamic.goodsId=model.goodsId;
        [self.navigationController pushViewController:dynamic animated:YES];
    }
}
- (UITableView *)tb{
    if (_tb==nil) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0,64,EPScreenW,EPScreenH-49-44) style:UITableViewStylePlain];
        _tb.showsVerticalScrollIndicator=NO;
        _tb.backgroundColor=RGBColor(233, 233, 233);
        _tb.delegate=self;
        _tb.dataSource=self;
        _tb.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_tb];
    }
    return _tb;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
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
