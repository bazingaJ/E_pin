//
//  EPcollectionViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/4/1.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCollectionViewController.h"
//#import "EPSearchCell.h"
#import "HeaderFile.h"
#import "EPDetailModel.h"
#import "EPGoodsDetailVC.h"
@interface EPCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tb;

/**数据源数组*/
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation EPCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"我的收藏"];
    self.tb.hidden=YES;
    self.tb.separatorColor=RGBColor(238, 238, 238);
    self.tb.separatorInset=UIEdgeInsetsMake(109, 15, 1, 15);
    self.tb.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LOGINTIME==nil) {
        [self nofavorView];
    }else{
        [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
            if (statusCode == 0)
            {
                [EPTool addMBProgressWithView:self.view style:0];
                [EPTool showMBWithTitle:@"当前网络不可用"];
                [EPTool hiddenMBWithDelayTimeInterval:1];
                [self readLocalData];
                [self.tb reloadData];
            }
            else
            {
                [self getData];
            }
        }];
    }
}
- (void)nofavorView{
    self.tb.hidden=YES;
    self.view.backgroundColor=RGBColor(234, 234, 234);
    UIImageView * tuan=[[UIImageView alloc]init];
    tuan.y=164;
    tuan.size=CGSizeMake(150, 150);
    tuan.x=EPScreenW/2-75;
    tuan.image=[UIImage imageNamed:@"图案"];
    [self.view addSubview:tuan];
    UILabel * lb=[[UILabel alloc]init];
    lb.x=0;
    lb.y=CGRectGetMaxY(tuan.frame)+17;
    lb.width=EPScreenW;
    lb.height=20;
    lb.text=@"您还没有心仪的收藏";
    lb.textColor=RGBColor(181, 181, 181);
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:lb];
}
- (void)readLocalData{
    FileHander *hander = [FileHander shardFileHand];
    NSMutableDictionary *responseObject=(NSMutableDictionary *)[hander readFile:@"favorData"];
    if (responseObject)
    {
        [self getDataWithDic:responseObject];
    }
}
- (void)getDataWithDic:(id)responseObject{
    NSArray * collectionArr=responseObject[@"collectionArr"];
    for (NSDictionary * dict in collectionArr) {
        EPGoodsFavorModel * model=[EPGoodsFavorModel mj_objectWithKeyValues:dict];
        [self.dataSource addObject:model];
    }

}
//请求数据
- (void)getData{
    [self.dataSource removeAllObjects];
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getMyCollectionInfo.json",EPUrl];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime", nil];
    [manager GET:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"收藏获取======%@",responseObject);
        NSString * returnCode=responseObject[@"returnCode"];
        if ([returnCode integerValue]==0) {
            NSArray * arr=responseObject[@"collectionArr"];
            if (arr.count==0) {
                [self nofavorView];
            }else{
                self.tb.hidden=NO;
                [self getDataWithDic:responseObject];
                FileHander *hander = [FileHander shardFileHand];
                NSString *sss=@"ss";
                [hander saveFile:responseObject withForName:@"favorData" withError:&sss];
            }
            [self.tb reloadData];
        }else if ([returnCode integerValue]==2){
            NSString * msg=[responseObject objectForKey:@"msg"];
            [EPLoginViewController publicDeleteInfo];
            EPLoginViewController * vc=[[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [self presentViewController:vc animated:YES completion:nil];
            }];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败，请稍后重试" count:0 doWhat:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
       
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
    }];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId=@"cellID";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat minY=10;
    if (self.dataSource.count>0) {
        EPDetailModel * model=[self.dataSource objectAtIndex:indexPath.row];
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.frame=CGRectMake(0, 0, EPScreenW, 110);
        vc.backgroundColor=[UIColor whiteColor];
        UIImageView * img=[[UIImageView alloc]init];
        [vc addSubview:img];
        img.frame=CGRectMake(15, minY, WIDTH(140.0, 375),90);
        [img sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];
        CGFloat leftX=WIDTH(12.0, 375)+CGRectGetMaxX(img.frame);
        UILabel * goodName=[[UILabel alloc]init];
        [vc addSubview:goodName];
        goodName.frame=CGRectMake(leftX, minY, EPScreenW-leftX-15, 14);
        goodName.font=[UIFont boldSystemFontOfSize:14];
        goodName.textColor=RGBColor(51, 51, 51);
        goodName.text=model.goodsName;
        UILabel * priceLb=[[UILabel alloc]init];
        [vc addSubview:priceLb];
        priceLb.frame=CGRectMake(leftX, CGRectGetMaxY(goodName.frame)+25, goodName.width, 14);
        priceLb.font=[UIFont boldSystemFontOfSize:14];
        priceLb.textColor=RGBColor(255, 8, 8);
        priceLb.text=[NSString stringWithFormat:@"¥%@",model.goodsCheapPrice];
        UILabel * soldLb=[[UILabel alloc]init];
        [vc addSubview:soldLb];
        soldLb.y=110-minY-10;
        soldLb.height=10;
        NSString * str=[NSString stringWithFormat:@"月售%@份",model.soldNumber];
        CGSize soldSize=[self sizeWithText:str font:[UIFont boldSystemFontOfSize:10]];
        soldLb.width=soldSize.width;
        soldLb.x=EPScreenW-15-soldSize.width;
        soldLb.font=[UIFont boldSystemFontOfSize:10];
        soldLb.textColor=RGBColor(51, 51, 51);
        soldLb.text=str;
        UIImageView * xinImg=[[UIImageView alloc]init];
        [vc addSubview:xinImg];
        CGSize xinSize=[UIImage imageNamed:@"心"].size;
        xinImg.x=CGRectGetMinX(soldLb.frame)-10-xinSize.width;
        xinImg.y=soldLb.y;
        xinImg.size=xinSize;
        xinImg.image=[UIImage imageNamed:@"心"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count>0) {
        EPGoodsFavorModel * model=[self.dataSource objectAtIndex:indexPath.row];
        EPGoodsDetailVC * vc=[[EPGoodsDetailVC alloc]init];
        vc.goodsId=model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark---懒加载----
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
