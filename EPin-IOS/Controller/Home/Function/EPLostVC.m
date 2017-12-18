//
//  EPLostViewController.m
//  EPin-IOS
//  失物招领
//  Created by jeader on 16/3/31.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPLostVC.h"
#import "HeaderFile.h"
#import "EPLostCell.h"
#import "EPLostDetailVC.h"
#import "EPDefineCell.h"
#import "EPMoreWayVC.h"
#import "EPData.h"
#import "MJExtension.h"
#import "EPMainModel.h"
#import "UIImageView+photoBrowser.h"

static NSString * cellID =@"collCell";
@interface EPLostVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * coll;
@property (nonatomic, strong) NSArray * nameArr;
@property (nonatomic, strong) NSArray * imgArr;

@property (nonatomic, strong) NSMutableArray * lostArr;
@property (nonatomic, strong) NSMutableArray * lostTimeArr;
@property (nonatomic, strong) NSMutableArray * lostTypeArr;
@property (nonatomic, strong) NSMutableArray * lostDescArr;
@property (nonatomic, strong) NSMutableArray * lostIdArr;
@end

@implementation EPLostVC

static NSString *path=@"lostData";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getLostData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"失物招领"];
    [self setupNavView];
    [self prepareForCollectionView];
//    [self btnSel];
     [self readLocaLData];
}
-(void)readLocaLData{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:path];
    if (responseObject) {
        [self getDataWithDic:responseObject];
        [self.tableVi reloadData];
    }

}
-(void)getLostData{
    EPData *data = [EPData new];
    [data getLosterDataWithType:@"8" withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        FileHander *hander = [FileHander shardFileHand];
        [self getDataWithDic:dic];
        NSString *sss=@"ss";
        [hander saveFile:dic withForName:path withError:&sss];
        [self.tableVi reloadData];
        
    }];
}
-(void)getDataWithDic:(id)dic{
    
    NSArray *lost = dic[@"lostArr"];
    NSMutableArray *lostArr = [EPMainModel mj_objectArrayWithKeyValuesArray:lost];
    NSMutableArray *lostImageArr = [NSMutableArray array];
    NSMutableArray *lostTimeArr = [NSMutableArray array];
    NSMutableArray *lostTypeArr = [NSMutableArray array];
    NSMutableArray *lostDescribArr = [NSMutableArray array];
    NSMutableArray * lostIdArr=[NSMutableArray array];
    for (EPMainModel *mode in lostArr) {
        [lostImageArr addObject:mode.lostImage];
        [lostTimeArr addObject:mode.lostTime];
        [lostTypeArr addObject:mode.lostType];
        if (mode.lostDesc) {
            [lostDescribArr addObject:mode.lostDesc];
        }else{
            NSString *desc = @"暂无描述";
            [lostDescribArr addObject:desc];
        }
        [lostIdArr addObject:mode.lostId];
    }
    self.lostTypeArr = lostTypeArr;
    self.lostTimeArr = lostTimeArr;
    self.lostArr = lostImageArr;
    self.lostDescArr=lostDescribArr;
    self.lostIdArr=lostIdArr;
}
- (NSArray *)nameArr
{
    if (_nameArr == nil)
    {
        _nameArr=@[@"钱包",@"手提包",@"文件",@"钥匙",@"衣物",@"电子物品",@"手机",@"耳机",@"还没找到"];
    }
    return _nameArr;
}
- (NSArray *)imgArr
{
    if (_imgArr == nil)
    {
        _imgArr=@[@"钱包",@"手提包",@"文件",@"钥匙",@"衣物",@"电子物品",@"手机失物",@"耳机",@"还没找到"];
    }
    return _imgArr;
}
- (void)setupNavView
{
    self.tableVi.tableHeaderView.height=200;
    self.tableVi.tableHeaderView=self.headView;
    self.tableVi.tableHeaderView.userInteractionEnabled=YES;
    
}

- (void)prepareForCollectionView
{
    UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize =CGSizeMake(EPScreenW/4, 265/3);
    layout.minimumLineSpacing=1;
    layout.sectionInset=UIEdgeInsetsMake(0,20,0,20);
    
    _coll =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, EPScreenW, 265) collectionViewLayout:layout];
    _coll.backgroundColor=[UIColor whiteColor];
    _coll.delegate=self;
    _coll.dataSource=self;
    _coll.scrollEnabled=NO;
    [_coll registerNib:[UINib nibWithNibName:@"EPDefineCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    self.headView.userInteractionEnabled=YES;
    [self.headView addSubview:_coll];
    
    [self createLineView];
}
- (void)createLineView
{
    UIView * view1 =[[UIView alloc] init];
    view1.frame=CGRectMake(_coll.width/3, 0, 1, _coll.height);
    view1.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    [_coll addSubview:view1];
    UIView * view2 =[[UIView alloc] init];
    view2.frame=CGRectMake(_coll.width/3*2, 0, 1, _coll.height);
    view2.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    [_coll addSubview:view2];
    UIView * view3 =[[UIView alloc] init];
    view3.frame=CGRectMake(0, _coll.height/3, _coll.width, 1);
    view3.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    [_coll addSubview:view3];
    UIView * view4 =[[UIView alloc] init];
    view4.frame=CGRectMake(0, _coll.height/3*2, _coll.width, 1);
    view4.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    [_coll addSubview:view4];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EPDefineCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.titleLab.text=self.nameArr[indexPath.row];
    cell.img.image=[UIImage imageNamed:self.imgArr[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==8)
    {
        EPMoreWayVC * vc =[[EPMoreWayVC alloc] init];
       
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        EPLostDetailVC * vc =[[EPLostDetailVC alloc] init];
        vc.getString=self.nameArr[indexPath.row];
        vc.type = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
    static NSString * cellIdentifier =@"cell";
    EPLostCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EPLostCell" owner:nil options:nil]objectAtIndex:0];
        
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (self.lostArr.count>0)
    {
        //失物图片
        [cell.lostThing sd_setImageWithURL:[NSURL URLWithString:self.lostArr[indexPath.row]]];
        [cell.lostThing showBiggerPhotoInview:self.view];
        NSLog(@"=====%@",self.lostArr[indexPath.row]);
        //失物名字
        cell.someThing.text = self.lostTypeArr[indexPath.row];
        //丢失时间
        cell.lostTime.text = [NSString stringWithFormat:@"发布时间 : %@",[self takeNumberWith:self.lostTimeArr[indexPath.row]]];
        cell.takeBtn.layer.masksToBounds=YES;
        cell.takeBtn.layer.cornerRadius=5;
        cell.takeBtn.tag=indexPath.row;
        [cell.takeBtn addTarget:self action:@selector(clickToGetIt:) forControlEvents:UIControlEventTouchUpInside];
        NSString * descirble=self.lostDescArr[indexPath.row];
        cell.describeLab.text= [NSString stringWithFormat:@"失物描述 : %@",descirble];
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =[[UIView alloc] init];
    view.backgroundColor=[UIColor whiteColor];
    
    
    UILabel * lab =[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 75, 21)];
    lab.text=@"失物浏览 |";
    lab.font = [UIFont boldSystemFontOfSize:15];
    lab.textColor = RGBColor( 51, 51, 51);
    [view addSubview:lab];
    
    UILabel * lab2 =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame)+2, 5, 200, 21)];
    lab2.text=@"The lost to browse";
    lab2.font = [UIFont systemFontOfSize:11];
    lab2.textColor = RGBColor( 51, 51, 51);
    [view addSubview:lab2];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(15, CGRectGetMaxY(lab.frame)+ 3, EPScreenW - 30, 1);
    lineView.backgroundColor = RGBColor(153, 153, 153);
    [view addSubview:lineView];
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//手势点击事件
- (void)tapClick:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}
- (void)clickToGetIt:(UIButton *)button
{
    EPMoreWayVC * vc =[[EPMoreWayVC alloc] init];
    vc.lostId=self.lostIdArr[button.tag];
    vc.lostDescribe = self.lostDescArr[button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 将服务器返回的时间转化成可以显示出来的时间格式

 @param string 服务器返回的时间格式
 @return 最后要显示出来的时间格式
 */
- (NSString *)takeNumberWith:(NSString *)string
{
    NSRange yearRange = NSMakeRange(0, 4);
    NSRange mouthRange = NSMakeRange(4, 2);
    NSRange dayRange = NSMakeRange(6, 2);
    
    NSString * firstString = [string substringWithRange:yearRange];
    NSString * secondString = [string substringWithRange:mouthRange];
    NSString * thirdString = [string substringWithRange:dayRange];
    NSString * finally = [NSString stringWithFormat:@"%@-%@-%@",firstString,secondString,thirdString];
    return finally;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}




@end
