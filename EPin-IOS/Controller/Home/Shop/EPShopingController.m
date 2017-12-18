//
//  EPShopingController.m
//  EPin-IOS
//  购物界面
//  Created by jeaderQ on 16/4/2.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPShopingController.h"
#import "HeaderFile.h"
#import "SDCycleScrollView.h"
#import "EPGoodsDetailVC.h"
#import "EPMainModel.h"
#import "EPGoods.h"
#import "MJExtension.h"
#import "UIButton+WebCache.h"
#import "EPDefineButton.h"
#import "EPMainTableViewCell.h"
#import "EPSpendCell.h"
#import "EPMoreController.h"
@interface EPShopingController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *bannerArr;
@property (nonatomic, strong) NSArray *otherArr;
@property (nonatomic, strong) NSArray *highArr;
@property (nonatomic, strong) NSArray *wholeGoodsArr;

@end

@implementation EPShopingController
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self getshopingData];
    [self readLocaLData];

}
-(void)readLocaLData{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:path];
    [self getDataWithDic:responseObject];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addNavigationBar:0 title:@"购物"];
}
static NSString *path=@"ShopingData";

-(void)getshopingData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"type"]= @"2";
    NSString *url = [NSString stringWithFormat:@"%@/getYPgoodsList.json",EPUrl];
    [manager POST:url parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"购物---%@",responseObject);
        FileHander *hander = [FileHander shardFileHand];
        [self getDataWithDic:responseObject];
        NSString *sss=@"ss";
        [hander saveFile:responseObject withForName:path withError:&sss];

        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    parame[@"type"] = @"1";
    parame[@"goodsType"] = @"3";
    NSString *urlbottom = [NSString stringWithFormat:@"%@/getYPMoregoodsList.json",EPUrl];
    [manager POST:urlbottom parameters:parame success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"下部res%@",responseObject);
        [self loadDataWithDic:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s>>>>%@",__func__,error);
        
    }];
    
    
}
-(void)loadDataWithDic:(NSDictionary *)responseObject{
    EPMainModel *mainMode = [EPMainModel mj_objectWithKeyValues:responseObject];
    self.wholeGoodsArr = mainMode.goodsArr;
  
}
-(void)getDataWithDic:(id)responseObject{
    EPMainModel *mainModel = [EPMainModel mj_objectWithKeyValues:responseObject];

    self.otherArr = mainModel.shoppingActivity2Arr;
    self.highArr = mainModel.shoppingActivity1Arr;
    self.bannerArr = mainModel.bannerArr;


}
#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.wholeGoodsArr.count+4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 152.0;
    }else if (indexPath.row==1){
        return 490.0;
    }else if (indexPath.row ==2) {
        return 202.0;
    }else if (indexPath.row == 3){
        return 38.0;
    }else if (indexPath.row==4){
        return 111.0;
    }else{
        return 111.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell1";
    EPSpendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell =[[NSBundle mainBundle] loadNibNamed:@"EPMainTableViewCell" owner:nil options:nil][2];
    if (indexPath.row ==0) {
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 152.0)];
        viewBG.backgroundColor = RGBColor(255, 255, 255);
        NSMutableArray *goodsImg = [NSMutableArray array];
        NSMutableArray *goodsId = [NSMutableArray array];
        for (EPGoods *goods in self.bannerArr) {
            [goodsImg addObject:goods.goodsSaleImg];
        }
        for (EPGoods *goods in self.bannerArr) {
            [goodsId addObject:goods.goodsId];
        }
        SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, EPScreenSize.width,152.0) delegate:self placeholderImage:nil];
        banner.imageURLStringsGroup = goodsImg;
        banner.delegate = self;
        [viewBG addSubview:banner];
        [cell.contentView addSubview:viewBG];
    }else if (indexPath.row == 1){
        cell =[[NSBundle mainBundle] loadNibNamed:@"EPMainTableViewCell" owner:nil options:nil][3];
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, cell.height)];
        viewBG.backgroundColor = RGBColor(217, 217, 217);
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, cell.height-7)];
        bg.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:bg];
        [cell.contentView addSubview:viewBG];
//        [self creatViewWithView:bg];
        UILabel *label = [[UILabel alloc]init];
        label.x = 15;
        label.y = 10;
        label.size = [self sizeWithText:@"精选推荐" font:[UIFont systemFontOfSize:15]];
        label.text = @"精选推荐";
        label.textColor = RGBColor(51, 51, 51);
        label.font = [UIFont systemFontOfSize:15];
        [bg addSubview:label];
        UIView *lin = [[UIView alloc]init];
        lin.x = CGRectGetMaxX(label.frame)+6;
        lin.y = label.y+3;
        lin.width = 1;
        lin.height = label.height-4;
        lin.backgroundColor = [UIColor blackColor];
        [bg addSubview:lin];
        
        UILabel *la = [[UILabel alloc]init];
        la.text = @"Recommend boutique";
        CGSize laSize = [self sizeWithText:@"Recommend boutique" font:[UIFont systemFontOfSize:11]];
        la.x = CGRectGetMaxX(lin.frame)+6;
        la.size = laSize;
        la.y = 15;
        la.font = [UIFont systemFontOfSize:11];
        la.textColor = RGBColor(51, 51, 51);
        [bg addSubview:la];
        UIButton *morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        morebtn.tag = 41;
        [morebtn setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
        morebtn.width = 60;
        morebtn.height = 16;
        morebtn.x = EPScreenW-morebtn.width;
        morebtn.y = label.y;
        
        [morebtn addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:morebtn];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, label.y +label.height+7, EPScreenW, 1)];
        line.backgroundColor = RGBColor(217, 217, 217);
        [bg addSubview:line];

        CGFloat liulianW = WIDTH(154.0, 375);
        CGFloat liulianH = 154.0;
        
        NSMutableArray *goodsImg = [NSMutableArray array];
        NSMutableArray *goodsId = [NSMutableArray  array];
        NSMutableArray *goodsName = [NSMutableArray  array];
        NSMutableArray *goodsPrice = [NSMutableArray  array];

        for (EPGoods *goods in self.highArr) {
            [goodsImg addObject:goods.goodsSaleImg];
        }
        for (EPGoods *goods in self.highArr) {
            [goodsId addObject:goods.goodsId];
        }
        for (EPGoods *goods in self.highArr) {
            [goodsName addObject:goods.goodsName];
        }
        for (EPGoods *goods in self.highArr) {
            [goodsPrice addObject:goods.goodsPrice];
        }
        for (int i = 0 ; i<self.highArr.count; i++) {
            CGFloat liulianX = WIDTH(20.0, 375);
            CGFloat liulianY = line.y +10;
            CGFloat liulianSpace = EPScreenW-2*liulianX -2*liulianW;
            if (i == 1|| i==3) {
                liulianX = liulianX +liulianW +liulianSpace;
            }
            if (i == 2) {
                liulianX =WIDTH(20.0, 375);
            }
            if (i >=2) {
                liulianY = liulianY +liulianH +72.0;
            }
            EPDefineButton *liulian = [EPDefineButton buttonWithType:UIButtonTypeCustom];
            liulian.frame = CGRectMake(liulianX, liulianY, liulianW, liulianH);
           
            [liulian addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:liulian];
            UILabel *liuLabel = [[UILabel alloc]initWithFrame:CGRectMake(liulianX, CGRectGetMaxY(liulian.frame)+12.5, liulianW, 14.0)];
            liuLabel.numberOfLines = 0;
            liuLabel.textColor = RGBColor(6, 6, 6);
            liuLabel.font = [UIFont systemFontOfSize:14];
            [bg addSubview:liuLabel];
            UILabel *jiFen = [[UILabel alloc]initWithFrame:CGRectMake(liulianX, CGRectGetMaxY(liuLabel.frame)+5, liulianW, 11.0)];
         
            jiFen.textColor = RGBColor(3, 3, 3);
            jiFen.font = [UIFont systemFontOfSize:11];
            [bg addSubview:jiFen];
                [liulian sd_setImageWithURL:[NSURL URLWithString:goodsImg[i]] forState:UIControlStateNormal];
                liulian.btnId = goodsId[i];
                NSString * price = [NSString stringWithFormat:@"%@",goodsName[i]];
                liuLabel.text = price;
                jiFen.text = goodsPrice[i];
        }
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,line.y +215 , EPScreenW, 1)];
        line2.backgroundColor = RGBColor(217, 217, 217);
        [bg addSubview:line2];

    }else if (indexPath.row == 2){
        cell =[[NSBundle mainBundle] loadNibNamed:@"EPMainTableViewCell" owner:nil options:nil][3];
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, cell.height)];
        viewBG.backgroundColor = RGBColor(217, 217, 217);
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, cell.height-7)];
        bg.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:bg];
        [cell.contentView addSubview:viewBG];
        UILabel *label = [[UILabel alloc]init];
        label.x = 15;
        label.y = 10;
        label.size = [self sizeWithText:@"其他推荐" font:[UIFont systemFontOfSize:15]];
        label.text = @"其他推荐";
        label.textColor = RGBColor(51, 51, 51);
        label.font = [UIFont systemFontOfSize:15];
        [bg addSubview:label];
        UIView *lin = [[UIView alloc]init];
        lin.x = CGRectGetMaxX(label.frame)+6;
        lin.y = label.y+3;
        lin.width = 1;
        lin.height = label.height-4;
        lin.backgroundColor = [UIColor blackColor];
        [bg addSubview:lin];
        
        UILabel *la = [[UILabel alloc]init];
        la.text = @"Other recommendtion";
        CGSize laSize = [self sizeWithText:@"Other recommendtion" font:[UIFont systemFontOfSize:11]];
        la.x = CGRectGetMaxX(lin.frame)+6;
        la.size = laSize;
        la.y = 15;
        la.font = [UIFont systemFontOfSize:11];
        la.textColor = RGBColor(51, 51, 51);
        [bg addSubview:la];
        UIButton *morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        morebtn.tag = 41;
        [morebtn setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
        morebtn.width = 60;
        morebtn.height = 16;
        morebtn.x = EPScreenW-morebtn.width;
        morebtn.y = label.y;
        
        [morebtn addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:morebtn];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, label.y +label.height+7, EPScreenW, 1)];
        line.backgroundColor = RGBColor(217, 217, 217);
        [bg addSubview:line];
        CGFloat liulianW = WIDTH(160.0, 375);
        CGFloat liulianH = 100.0;
        NSMutableArray *goodsImg = [NSMutableArray array];
        NSMutableArray *goodsId = [NSMutableArray  array];
        NSMutableArray *goodsName = [NSMutableArray  array];
        NSMutableArray *goodsPrice = [NSMutableArray  array];
        for (EPGoods *goods in self.otherArr) {
            [goodsImg addObject:goods.goodsSaleImg];
        }
        for (EPGoods *goods in self.otherArr) {
            [goodsId addObject:goods.goodsId];
        }
        for (EPGoods *goods in self.otherArr) {
            [goodsName addObject:goods.goodsName];
        }
        for (EPGoods *goods in self.otherArr) {
            [goodsPrice addObject:goods.goodsPrice];
        }
        for (int i = 0 ; i<self.otherArr.count; i++) {
            CGFloat liulianX = 15.0;
            CGFloat liulianY = line.y +10;
//            CGFloat liulianSpace = EPScreenW-2*liulianX -2*liulianW;
//            if (i == 1|| i==3) {
//                liulianX = liulianX +liulianW +liulianSpace;
//            }
//            if (i == 2) {
//                liulianX =WIDTH(20.0, 375);
//            }
//            if (i >=2) {
//                liulianY = liulianY +liulianH +HEIGHT(102.0, 667);
//            }
            if (i == 1) {
                liulianX = EPScreenW-15-liulianW;
            }
            EPDefineButton *liulian = [EPDefineButton buttonWithType:UIButtonTypeCustom];
            liulian.frame = CGRectMake(liulianX, liulianY, liulianW, liulianH);
            
            [liulian addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:liulian];
            UILabel *liuLabel = [[UILabel alloc]initWithFrame:CGRectMake(liulianX, CGRectGetMaxY(liulian.frame)+12.5, liulianW, 14.0)];
            liuLabel.textColor = RGBColor(6, 6, 6);
            liuLabel.font = [UIFont systemFontOfSize:14];
            [bg addSubview:liuLabel];
            UILabel *jiFen = [[UILabel alloc]initWithFrame:CGRectMake(liulianX, CGRectGetMaxY(liuLabel.frame)+6, liulianW, 11.0)];
            jiFen.textColor = RGBColor(3, 3, 3);
            jiFen.font = [UIFont systemFontOfSize:11];
            [bg addSubview:jiFen];
                [liulian sd_setImageWithURL:[NSURL URLWithString:goodsImg[i]] forState:UIControlStateNormal];
                liulian.btnId = goodsId[i];
                NSString * price = [NSString stringWithFormat:@"%@",goodsName[i]];
                liuLabel.text = price;
                jiFen.text = goodsPrice[i];
        }
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,line.y +239.0+10, EPScreenW, 1)];
        line2.backgroundColor = RGBColor(217, 217, 217);
        [bg addSubview:line2];
    }else if (indexPath.row == 3){
       cell=[[NSBundle mainBundle]loadNibNamed:@"EPMainTableViewCell" owner:nil options:nil][3];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 38)];
        viewBG.backgroundColor = RGBColor(217, 217, 217);
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, 31)];
        bg.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:bg];
        [cell.contentView addSubview:viewBG];
        UILabel *label = [[UILabel alloc]init];
        label.x = 15;
        label.y = 6;
        label.size = [self sizeWithText:@"全部商品" font:[UIFont systemFontOfSize:15]];
        label.text = @"全部商品";
        label.textColor = RGBColor(51, 51, 51);
        label.font = [UIFont systemFontOfSize:15];
        [bg addSubview:label];
        UIView *lin = [[UIView alloc]init];
        lin.x = CGRectGetMaxX(label.frame)+6;
        lin.y = label.y+3;
        lin.width = 1;
        lin.height = label.height-4;
        lin.backgroundColor = [UIColor blackColor];
        [bg addSubview:lin];
        
        UILabel *la = [[UILabel alloc]init];
        la.text = @"All goods";
        CGSize laSize = [self sizeWithText:@"All goods" font:[UIFont systemFontOfSize:11]];
        la.x = CGRectGetMaxX(lin.frame)+6;
        la.size = laSize;
        la.y = 10;
        la.font = [UIFont systemFontOfSize:11];
        la.textColor = RGBColor(51, 51, 51);
        [bg addSubview:la];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,29.0, EPScreenW, 1)];
        line2.backgroundColor = RGBColor(217, 217, 217);
        [bg addSubview:line2];
    }else{
        cell=[[NSBundle mainBundle]loadNibNamed:@"EPSpendCell" owner:nil options:nil][0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        EPGoods *goods = self.wholeGoodsArr[indexPath.row-4];
        cell.goodsName.text = goods.goodsName;
        [cell.leadingImg sd_setImageWithURL:[NSURL URLWithString:goods.goodsImg]];
        cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",goods.goodsPrice];
        cell.sellCounts.text = goods.goodsCounts;
        cell.discountsPrice.text = [NSString stringWithFormat:@"%@元",goods.goodsCheapPrice];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
    
}
-(void)loadMore:(UIButton *)sender {
    switch (sender.tag) {
        case 42:
        {
            EPMoreController *detail = [[EPMoreController alloc]init];
            detail.moreArr = self.highArr;
            detail.titles = @"精选推荐";
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 43:
        {
            EPMoreController *detail = [[EPMoreController alloc]init];
            detail.titles = @"其他推荐";
            detail.moreArr = self.otherArr;
            
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    EPMainModel *model = self.bannerArr[index];
    EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
    detail.goodsId = model.goodsId;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>3) {
        EPGoodsDetailVC * vc=[[EPGoodsDetailVC alloc]init];
        EPGoods * goods=self.wholeGoodsArr[indexPath.row-4];
        vc.goodsId=goods.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)pushgoods:(EPDefineButton *)sender{
    EPGoodsDetailVC * vc=[[EPGoodsDetailVC alloc]init];
    vc.goodsId = sender.btnId;
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)creatViewWithView:(UIView *)bg{
    UILabel *label = [[UILabel alloc]init];
    label.x = 15;
    label.y = 5;
    label.size = [self sizeWithText:@"精选推荐" font:[UIFont systemFontOfSize:15]];
    label.text = @"精选推荐";
    label.textColor = RGBColor(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    [bg addSubview:label];
    UIView *lin = [[UIView alloc]init];
    lin.x = CGRectGetMaxX(label.frame)+6;
    lin.y = label.y+3;
    lin.width = 1;
    lin.height = label.height-4;
    lin.backgroundColor = [UIColor blackColor];
    [bg addSubview:lin];
    
    UILabel *la = [[UILabel alloc]init];
    la.text = @"Recommend boutique";
    CGSize laSize = [self sizeWithText:@"Recommend boutique" font:[UIFont systemFontOfSize:11]];
    la.x = CGRectGetMaxX(lin.frame)+6;
    la.size = laSize;
    la.y = 10;
    la.font = [UIFont systemFontOfSize:11];
    la.textColor = RGBColor(51, 51, 51);
    [bg addSubview:la];
 //更多按钮
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    [more setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    more.x = EPScreenW-20;
    more.y = label.y;
    
    
    UIView *line = [[UIView alloc]init];
    line.x = label.x;
    line.y = CGRectGetMaxY(label.frame)+3;
    line.width = EPScreenW-30;
    line.height = 0.5;
    line.backgroundColor = RGBColor(51, 51, 51);
    [bg addSubview:line];
    
    UIScrollView *scroll  = [[UIScrollView alloc]init];
    scroll.frame = CGRectMake(15, CGRectGetMaxY(line.frame)+10, EPScreenW-30, 135);
    scroll.backgroundColor  = [UIColor orangeColor];
    scroll.contentSize = CGSizeMake((EPScreenW-30) * 3, 0);
    scroll.bounces = NO;
    scroll.pagingEnabled = YES;
    [bg addSubview:scroll];
    for (int i = 0 ; i < 3; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake((EPScreenW-30) * i, 0, EPScreenW-30, 135);
        [scroll addSubview:imageV];
    }
    
    
    
    
}
@end
