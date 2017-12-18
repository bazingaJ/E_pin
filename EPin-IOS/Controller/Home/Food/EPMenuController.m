//
//  EPMeunController.m
//  EPin-IOS
//  美食商城3


//  Created by jeaderQ on 16/3/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMenuController.h"
#import "HeaderFile.h"
#import "SDCycleScrollView.h"
#import "EPGoodsDetailVC.h"
#import "EPMyTableViewCell.h"
#import "EPMenuTableViewCell.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "UIButton+WebCache.h"
#import "EPMoreController.h"
#import "EPGoods.h"
@interface EPMenuController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *bannerArr;
@property (nonatomic, strong) NSArray *discountInfoArr;
@property (nonatomic, strong) NSArray *favoriteInfoArr;
@property (nonatomic, strong) NSArray *eachLikeInfoArr;
@property (nonatomic, strong) NSArray *discountId;
@property (nonatomic, strong) NSArray *favoriteId;
@property (nonatomic, strong) NSArray *eachLikeId;
@end

@implementation EPMenuController
#if 0
//一个section刷新
NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
[tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//一个cell刷新
NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

#endif
static NSString *path=@"MenuData";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"美食商城"];
    [self getMenuData];

//    [self readLocaLData];

    // Do any additional setup after loading the view from its nib.
}

-(void)readLocaLData{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:path];
    [self getDataWithDic:responseObject];
    [self.tableView reloadData];
}
-(void)getMenuData{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"type"]= @"1";
    NSString *url = [NSString stringWithFormat:@"%@/getYPgoodsList.json",EPUrl];
    [manager POST:url parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"meishi>>>%@",responseObject);
        FileHander *hander = [FileHander shardFileHand];
        [self getDataWithDic:responseObject];
        NSString *sss=@"ss";
        [hander saveFile:responseObject withForName:path withError:&sss];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    parame[@"type"] = @"1";
    parame[@"goodsType"] = @"1";
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
    self.eachLikeInfoArr = mainMode.goodsArr;
    
}
-(void)getDataWithDic:(id)responseObject{
    NSArray * bannerImgArr = responseObject[@"bannerArr"];
    NSArray * discountInfoArr = responseObject[@"foodActivity1Arr"];
    NSArray *favoriteInfoArr = responseObject[@"foodActivity2Arr"];
    self.bannerArr = [EPMainModel mj_objectArrayWithKeyValuesArray:bannerImgArr];
    self.discountInfoArr = [EPMainModel mj_objectArrayWithKeyValuesArray:discountInfoArr];
    self.favoriteInfoArr = [EPMainModel mj_objectArrayWithKeyValuesArray:favoriteInfoArr];
}
#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eachLikeInfoArr.count+4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200.0;
    }else if (indexPath.row ==1) {
        return 185.0;
    }else if (indexPath.row == 2){
        return 206.0;
    }else if (indexPath.row==3){
        return 38.0;
    }else{
        return HEIGHT(110.0, 667);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell1";
    EPMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[NSBundle mainBundle] loadNibNamed:@"EPMenuTableViewCell" owner:nil options:nil][0];
     if (indexPath.row == 0) {
         NSMutableArray *bannerA = [NSMutableArray array];
         for (EPMainModel *model in self.bannerArr) {
             [bannerA addObject:model.goodsSaleImg];
         }
         
         UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, cell.height)];
        viewBG.backgroundColor = RGBColor(255, 255, 255);
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, cell.height-7)];
        bg.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:bg];
        [cell.contentView addSubview:viewBG];
         UILabel *label = [[UILabel alloc]init];
         label.x = 15;
         label.y = 5;
         label.size = [self sizeWithText:@"免费美味" font:[UIFont systemFontOfSize:15]];
         label.text = @"免费美味";
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
         la.text = @"Free delicious";
         CGSize laSize = [self sizeWithText:@"Free delicious" font:[UIFont systemFontOfSize:11]];
         la.x = CGRectGetMaxX(lin.frame)+6;
         la.size = laSize;
         la.y = 10;
         la.font = [UIFont systemFontOfSize:11];
         la.textColor = RGBColor(51, 51, 51);
         [bg addSubview:la];
        
         UIView *line = [[UIView alloc]init];
         line.x = label.x;
         line.y = CGRectGetMaxY(label.frame)+8;
         line.width = EPScreenW-30;
         line.height = 0.5;
         line.backgroundColor = RGBColor(51, 51, 51);
         [bg addSubview:line];

        SDCycleScrollView *Scro= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, line.y +10, EPScreenW-30, 150.0) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        Scro.imageURLStringsGroup = bannerA;
        Scro.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        Scro.delegate = self;
        [bg addSubview:Scro];
    }else if (indexPath.row == 1){
        NSMutableArray *favoriteImage = [NSMutableArray array];
        NSMutableArray *favoritePrice = [NSMutableArray array];
        NSMutableArray *favoriteName = [NSMutableArray array];
        NSMutableArray *favoriteId = [NSMutableArray array];
        for (EPMainModel *model in self.favoriteInfoArr) {
            [favoriteImage addObject:model.goodsSaleImg];
            [favoritePrice addObject:model.goodsPrice];
            [favoriteName addObject:model.goodsName];
            [favoriteId addObject:model.goodsId];
            
        }
        self.favoriteId = favoriteId;
        cell =[[NSBundle mainBundle] loadNibNamed:@"EPMenuTableViewCell" owner:nil options:nil][2];
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, cell.height)];
        viewBG.backgroundColor = RGBColor(237, 237, 237);
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, cell.height-7)];
        bg.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:bg];
        [cell.contentView addSubview:viewBG];
        UILabel *label = [[UILabel alloc]init];
        label.x = 15;
        label.y = 10;
        label.size = [self sizeWithText:@"天天打折" font:[UIFont systemFontOfSize:15]];
        label.text = @"天天打折";
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
        la.text = @"Every day a discount";
        CGSize laSize = [self sizeWithText:@"Every day a discount" font:[UIFont systemFontOfSize:11]];
        la.x = CGRectGetMaxX(lin.frame)+6;
        la.size = laSize;
        la.y = 15;
        la.font = [UIFont systemFontOfSize:11];
        la.textColor = RGBColor(51, 51, 51);
        [bg addSubview:la];

        UIButton *morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        morebtn.tag = 40;
        [morebtn setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
        morebtn.width = 46;
        morebtn.height = 16;
        morebtn.x = EPScreenW-morebtn.width;
        morebtn.y = label.y;
        morebtn.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [morebtn addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:morebtn];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(label.x, label.y +label.height+7, EPScreenW-2*label.x, 1)];
        line.backgroundColor = RGBColor(237, 237, 237);
        [bg addSubview:line];
        for (int i = 0 ; i<self.favoriteInfoArr.count; i ++) {
            
            CGFloat liulianW = WIDTH(113.0, 375);
            CGFloat liulianH = 119.0;
            CGFloat liulianSpace = (EPScreenW - 2*15.0 - liulianW*3)/2;
            CGFloat liulianX = i* (liulianW + liulianSpace) +15.0;
            CGFloat liulianY = line.y +10.0;
            UIButton *liulian = [UIButton buttonWithType:UIButtonTypeCustom];
            liulian.frame = CGRectMake(liulianX, liulianY, liulianW, liulianH);
            [liulian addTarget:self action:@selector(xiangqing:) forControlEvents:UIControlEventTouchUpInside];
            liulian.tag = 335+i;
            [bg addSubview:liulian];
//            UILabel *liuLabel = [[UILabel alloc]initWithFrame:CGRectMake(liulianX, liulianY +liulianH +5, liulianW,20.0)];
//            liuLabel.textAlignment = NSTextAlignmentCenter;
//            liuLabel.font = [UIFont systemFontOfSize:12];
            if (self.discountInfoArr.count>0) {
                    [liulian sd_setImageWithURL:[NSURL URLWithString:favoriteImage[i]] forState:UIControlStateNormal];
//                    NSString * price = [NSString stringWithFormat:@"%@  ￥%@",favoriteName[i],favoritePrice[i]];
//                    liuLabel.text = price;
                }
//                [bg addSubview:liuLabel];
            }

        }else if (indexPath.row == 2){
               NSMutableArray *discountImage = [NSMutableArray array];
               NSMutableArray *discountPrice = [NSMutableArray array];
               NSMutableArray *discountName = [NSMutableArray array];
               NSMutableArray *discountId = [NSMutableArray array];
               for (EPMainModel *model in self.discountInfoArr) {
                   [discountImage addObject:model.goodsSaleImg];
                   [discountPrice addObject:model.goodsPrice];
                   [discountName addObject:model.goodsName];
                   [discountId addObject:model.goodsId];
               }
               self.discountId = discountId;
               cell = [[NSBundle mainBundle] loadNibNamed:@"EPMenuTableViewCell" owner:nil options:nil][1];
               UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, cell.height)];
               viewBG.backgroundColor = RGBColor(237, 237, 237);
               viewBG.userInteractionEnabled = YES;
               UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, cell.height-7)];
               bg.backgroundColor = [UIColor whiteColor];
               bg.userInteractionEnabled = YES;
               [viewBG addSubview:bg];
               [cell.contentView addSubview:viewBG];
            UILabel *label = [[UILabel alloc]init];
            label.x = 15;
            label.y = 10;
            label.size = [self sizeWithText:@"吃货最爱" font:[UIFont systemFontOfSize:15]];
            label.text = @"吃货最爱";
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
            la.text = @"Like to eat peoples favorite";
            CGSize laSize = [self sizeWithText:@"Like to eat peoples favorite" font:[UIFont systemFontOfSize:11]];
            la.x = CGRectGetMaxX(lin.frame)+6;
            la.size = laSize;
            la.y = 15;
            la.font = [UIFont systemFontOfSize:11];
            la.textColor = RGBColor(51, 51, 51);
            [bg addSubview:la];
            UIButton *morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            morebtn.tag = 41;
            [morebtn setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
            morebtn.width = 46;
            morebtn.height = 16;
            morebtn.x = EPScreenW-morebtn.width;
            morebtn.y = label.y;
            
            [morebtn addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:morebtn];
               UIView *line = [[UIView alloc]initWithFrame:CGRectMake(label.x, label.y +label.height+7, EPScreenW-2*label.x, 1)];
               line.backgroundColor = RGBColor(237, 237, 237);
               [bg addSubview:line];
               CGFloat liulianW = WIDTH(167.5, 375);
               CGFloat liulianH =100.0;
               for (int i = 0 ; i<self.discountInfoArr.count; i++) {
                   CGFloat liulianX = 15.0;
                   CGFloat liulianY = line.y +10;
//                   CGFloat liulianSpace = EPScreenW-2*liulianX -2*liulianW;
//                   if (i == 1|| i==3) {
//                       liulianX = liulianX +liulianW +liulianSpace;
//                   }
//                   if (i == 2) {
//                       liulianX =WIDTH(20.0, 375);
//                   }
//                   if (i >=2) {
//                       liulianY = liulianY +liulianH +HEIGHT(35.0, 667);
//                   }
                   if (i == 1) {
                       liulianX = EPScreenW-15-liulianW;
                   }
                   UIButton *liulian = [UIButton buttonWithType:UIButtonTypeCustom];
                   [liulian setFrame:CGRectMake(liulianX, liulianY, liulianW, liulianH)];
                   [bg addSubview:liulian];
                   liulian.tag = 330 +i;
                   [liulian addTarget:self action:@selector(xiangqing:) forControlEvents:UIControlEventTouchUpInside];
                   UILabel *liuLabel = [[UILabel alloc]initWithFrame:CGRectMake(liulianX, liulianY +liulianH +5, liulianW, 20.0)];
                   liuLabel.size = [self sizeWithText:discountName[i] font:[UIFont systemFontOfSize:15] maxW:liuLabel.width];
                   liuLabel.textAlignment = NSTextAlignmentLeft;
                   liuLabel.font = [UIFont systemFontOfSize:15];
                   liuLabel.textColor = RGBColor(51, 51, 51);
                   UILabel *price = [[UILabel alloc]init];
                   price.x = 15;
                   price.y = CGRectGetMaxY(liuLabel.frame)-6;
                   price.size =[self sizeWithText:discountPrice[i] font:[UIFont systemFontOfSize:11] maxW:liuLabel.width];
                   price.font = [UIFont systemFontOfSize:11];
                   price.textAlignment = NSTextAlignmentLeft;
                   price.textColor = RGBColor(51, 51, 51);
                   if (self.discountInfoArr.count>0) {
                       [liulian sd_setImageWithURL:[NSURL URLWithString:discountImage[0]] forState:UIControlStateNormal];
                       liuLabel.text = [NSString stringWithFormat:@"%@",discountName[i]];
                       price.text = [NSString stringWithFormat:@"%@",discountPrice[i]];
                   }
                   
                   [bg addSubview:liuLabel];
                   [bg addSubview:price];
               }

               
               
           }else if (indexPath.row == 3){
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 38.0)];
        viewBG.backgroundColor = RGBColor(237, 237, 237);
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 7, EPScreenW, viewBG.height-7)];
        bg.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:bg];
        [cell.contentView addSubview:viewBG];
               UILabel *label = [[UILabel alloc]init];
               label.x = 15;
               label.y = 15;
               label.size = [self sizeWithText:@"热门美食" font:[UIFont systemFontOfSize:15]];
               label.text = @"热门美食";
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
               la.text = @"Popular food";
               CGSize laSize = [self sizeWithText:@"Popular food" font:[UIFont systemFontOfSize:11]];
               la.x = CGRectGetMaxX(lin.frame)+6;
               la.size = laSize;
               la.y = 19;
               la.font = [UIFont systemFontOfSize:11];
               la.textColor = RGBColor(51, 51, 51);
               [bg addSubview:la];
               UIView *line = [[UIView alloc]initWithFrame:CGRectMake(label.x, label.y +label.height+7, EPScreenW-2*label.x, 1)];
               line.backgroundColor = RGBColor(237, 237, 237);
               [bg addSubview:line];

    }else {

            EPGoods *goods = self.eachLikeInfoArr[indexPath.row-4];

            UIImageView *image = [[UIImageView alloc]init];
            [image sd_setImageWithURL:[NSURL URLWithString:goods.goodsImg]];
            image.frame = CGRectMake(18.0, 10, WIDTH(140.0, 375), 90.0);
            [cell.contentView addSubview:image];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(image.x, CGRectGetMaxY(image.frame)+10, EPScreenW-2*WIDTH(15.0, 375), 1)];
            line.backgroundColor = RGBColor(237, 237, 237);
            [cell.contentView addSubview:line];
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, image.y, WIDTH(200.0, 375), 20.0)];
            name.text = goods.goodsName;
            name.font=[UIFont systemFontOfSize:14];
            name.textColor = RGBColor(51, 51, 51);
            [cell.contentView addSubview:name];
            UILabel *liulian = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMaxY(name.frame)+25, WIDTH(200.0, 375), 20.0)];
            liulian.text = [NSString stringWithFormat:@"￥%@ ",goods.goodsCheapPrice];
            liulian.font=[UIFont systemFontOfSize:12];
            liulian.textColor = RGBColor(255, 8, 8);
            [cell.contentView addSubview:liulian];
            UILabel *price = [[UILabel alloc]init];
           CGSize  size = [self sizeWithText:goods.goodsCounts font:[UIFont systemFontOfSize:11]];
            price.frame = (CGRect){EPScreenW-15-size.width,CGRectGetMaxY(image.frame)-size.height,size};
            price.text = goods.goodsCounts;
            price.font=[UIFont systemFontOfSize:11];
            price.textColor = RGBColor(51, 51, 51);
            [cell.contentView addSubview:price];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heart-Shape"]];
        imageView.x = CGRectGetMinX(price.frame)-13;
        imageView.centerY = price.centerY;
        [cell.contentView addSubview:imageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)loadMore:(UIButton *)sender {
    switch (sender.tag) {
        case 40:
        {
            EPMoreController *detail = [[EPMoreController alloc]init];
            detail.moreArr = self.discountInfoArr;
            detail.titles = @"天天打折";
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 41:
        {
            EPMoreController *detail = [[EPMoreController alloc]init];
            detail.titles = @"吃货最爱";
            detail.moreArr = self.favoriteInfoArr;

            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        default:
            break;
    }
   

}
#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >=4) {
        EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
        EPGoods *goods = self.eachLikeInfoArr[indexPath.row-4];
        detail.goodsId = goods.goodsId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
-(void)xiangqing:(UIButton *)sender{
     switch (sender.tag) {
        case 330:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            detail.goodsId = self.discountId[sender.tag-330];
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 331:
        {
            EPGoodsDetailVC * detail = [[EPGoodsDetailVC alloc]init];
            detail.goodsId = self.discountId[sender.tag-330];
            [self.navigationController pushViewController:detail animated:YES];
        }
             break;
        case 332:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            detail.goodsId = self.discountId[sender.tag-330];
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 333:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
              detail.goodsId = self.discountId[sender.tag-330];
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 335:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            detail.goodsId = self.favoriteId[sender.tag-335];
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 336:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            detail.goodsId = self.favoriteId[sender.tag-335];
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 337:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            detail.goodsId = self.favoriteId[sender.tag-335];
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
@end
