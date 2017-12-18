//
//  EPLeisureController.m
//  EPin-IOS
//  娱乐
//  Created by jeaderQ on 16/4/3.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPLeisureController.h"
#import "HeaderFile.h"
#import "EPLeisureCell.h"
#import "EPShopVC.h"
#import "EPGoodsDetailVC.h"
#import "MJExtension.h"
#import "EPGoodsModel.h"
#import "UIButton+WebCache.h"
#import "EPGoods.h"
#import "EPDefineButton.h"


@interface EPLeisureController ()<UITableViewDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *amusementArr;

@end

@implementation EPLeisureController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getLeisureData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"娱乐"];
    [self readLocaLData];
}
-(void)getDataWithDic:(id)responseObject{
    
    NSArray * amusementArr = responseObject[@"amusementArr"];
    self.amusementArr = [EPGoodsModel mj_objectArrayWithKeyValuesArray:amusementArr];


}
static NSString *path=@"leisureData";
-(void)readLocaLData{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:path];
    [self getDataWithDic:responseObject];
    [self.tableView reloadData];
}
-(void)getLeisureData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parame = @{@"type":@"4"};
    NSString *url = [NSString stringWithFormat:@"%@/getYPgoodsList.json",EPUrl];
    [manager POST:url parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"res%@",responseObject);
        FileHander *hander = [FileHander shardFileHand];
        [self getDataWithDic:responseObject];
        NSString *sss=@"ss";
        [hander saveFile:responseObject withForName:path withError:&sss];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.amusementArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"leisureCell";
    
    EPLeisureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    EPGoodsModel *model = self.amusementArr[indexPath.row];

    cell = [[NSBundle mainBundle] loadNibNamed:@"EPLeisureCell" owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 326)];
    viewBG.backgroundColor = RGBColor(238, 238, 238);
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 7)];
    line.backgroundColor = RGBColor(237, 237, 237);
    [viewBG addSubview:line];
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 318)];
    bg.backgroundColor = [UIColor whiteColor];
    [viewBG addSubview:bg];
    [cell.contentView addSubview:viewBG];
    EPDefineButton * merchants = [EPDefineButton buttonWithType:UIButtonTypeCustom];
    merchants.frame = CGRectMake(0, 0, EPScreenW, 152.5);
    merchants.btnId = model.shopId;
    [merchants addTarget:self action:@selector(shangjia:) forControlEvents:UIControlEventTouchUpInside];
    [merchants sd_setBackgroundImageWithURL:[NSURL URLWithString:model.shopsImg] forState:UIControlStateNormal];
//    [merchants sd_setImageWithURL:[NSURL URLWithString:model.shopsImg] forState:UIControlStateNormal];
    [cell.contentView addSubview:merchants];
//    UIImageView *sanjiao = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"三角"]];
//    sanjiao.centerX = merchants.centerX;
//    sanjiao.y= merchants.height -sanjiao.height;
//    [viewBG addSubview:sanjiao];
    for (int i = 0; i<model.goodsArr.count; i++) {
        if (i>=2) {
            break;
        }
        CGFloat projectBtnW = (EPScreenW-WIDTH(40.0, 375))/2;
        CGFloat projectBtnH = 95.0;
        CGFloat projectBtnSpace = WIDTH(10.0, 375);
        CGFloat projectBtnX = i *(projectBtnW +projectBtnSpace) +15;
        CGFloat projectBtnY = 162.5;
        EPDefineButton *projectBtn= [EPDefineButton buttonWithType:UIButtonTypeCustom];
        projectBtn.frame = CGRectMake(projectBtnX, projectBtnY, projectBtnW, projectBtnH);
        [cell.contentView addSubview:projectBtn];
        [projectBtn addTarget:self action:@selector(clickDesc:) forControlEvents:UIControlEventTouchUpInside];
        
        if (model.goodsArr.count>0) {
                EPGoods *goods = model.goodsArr[i];
            [projectBtn sd_setImageWithURL:[NSURL URLWithString:goods.goodsImg] forState:UIControlStateNormal];
            CGSize size  = [self sizeWithText:[NSString stringWithFormat:@"￥%@",goods.goodsCheapPrice] font:[UIFont systemFontOfSize:15]];
            CGSize orginalSize  = [self sizeWithText:[NSString stringWithFormat:@"￥%@",goods.goodsPrice] font:[UIFont systemFontOfSize:10] maxW:projectBtn.width - size.width];
            //售价
            UILabel *price = [self creatLabelWithFrame:CGRectMake(projectBtnX, CGRectGetMaxY(projectBtn.frame)+10, size.width, size.height) font:[UIFont systemFontOfSize:15] text:[NSString stringWithFormat:@"￥%@",goods.goodsCheapPrice] textColor:RGBColor(255, 0, 0)];
            [bg addSubview:price];
            //门市价
            UILabel *orginal = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(price.frame)+5, price.y+4, orginalSize.width, orginalSize.height) font:[UIFont systemFontOfSize:10] text:[NSString stringWithFormat:@"￥%@",goods.goodsPrice] textColor:RGBColor(66, 66, 66)];
            [bg addSubview:orginal];
            UIView *lines = [[UIView alloc]init];
            lines.width = orginal.width;
            lines.height = 1;
            lines.x = 0;
            lines.y = orginal.height/2;
            lines.backgroundColor = [UIColor blackColor];
            [orginal addSubview:lines];
            
            
            CGSize NumSize = [self sizeWithText:[NSString stringWithFormat:@"已售0份"] font:[UIFont systemFontOfSize:10]];
            CGFloat NumX = CGRectGetMaxX(projectBtn.frame) - NumSize.width;
            CGFloat NumY = bg.height - 15 - NumSize.height;
            UILabel *Num = [self creatLabelWithFrame:CGRectMake(NumX, NumY, NumSize.width, NumSize.height) font:[UIFont systemFontOfSize:10] text:[NSString stringWithFormat:@"已售0份"] textColor:RGBColor(66, 66, 66)];
            [bg addSubview:Num];
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heart-Shape"]];
            image.x = Num.x-image.width-5;
            image.y = CGRectGetMaxY(bg.frame)-15-image.height;
            [bg addSubview:image];
//            desc.text = [NSString stringWithFormat:@"￥占位 门市价:￥ %@",goods.goodsPrice];
//            [price setTitle:[NSString stringWithFormat:@"门市价:￥ %@",goods.goodsPrice] forState:UIControlStateNormal];
            projectBtn.btnId = goods.goodsId;
        }
        }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 326;
}
-(UILabel *)creatLabelWithFrame:(CGRect)frame font:(UIFont*)font text:(NSString *)text textColor:(UIColor *)color  {
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.text = text;
    label.font = font;
    label.textColor = color;
    return label;
}
-(void)clickDesc:(EPDefineButton *)sender{
    EPGoodsDetailVC  * vc=[[EPGoodsDetailVC alloc]init];
    vc.goodsId=sender.btnId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)shangjia:(EPDefineButton *)sender{
    EPShopVC * vc=[[EPShopVC alloc]init];
    vc.shopId=sender.btnId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
