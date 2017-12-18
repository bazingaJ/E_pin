//
//  EPMyViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/3/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMyViewController.h"
#import "EPMyTableViewCell.h"
#import "EPPerViewController.h"
#import "EPMemberController.h"
#import "EPCollectionViewController.h"
#import "HeaderFile.h"
#import "EPNewsViewController.h"
#import "EPSettingViewController.h"
#import "EPMyJudgeViewController.h"
#import "EPPerModel.h"
#import "EPAddInfoVC.h"
#import "EPDetailModel.h"
#import "EPMyCarVC.h"
#import "UIImage+ImageEffects.h"
#import "EPPointsController.h"
#import "EPMyEpaiViewController.h"
#import "EPVIsitVC.h"
#import "EPCooprationVC.h"
#import "EPMyOrderVC.h"
@interface EPMyViewController ()<UITableViewDataSource,UITableViewDelegate>

/**UITableView*/
@property(nonatomic,strong)UITableView * tb;
@property(nonatomic,strong)EPPerViewController * per;
@property(nonatomic,strong)EPLoginViewController * login;
@property(nonatomic,strong)UIImageView * hImg;
@property(nonatomic,strong)UIImageView * backImg;
@property(nonatomic,strong)UILabel * nameLb;
@property(nonatomic,strong)EPPerModel * model;
@property(nonatomic,strong)EPVIPModel * mode;
@end
@implementation EPMyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _per=[[EPPerViewController alloc]init];
    _login=[[EPLoginViewController alloc]init];
    [self creatTb];
    [self setNav];
    [self addObserve];
    if (LOGINTIME==nil) {
        [self presentViewController:_login animated:YES completion:nil];
    }else{
        [self creatFileLoad];
        [self creatFileLoadVIP];
        [self.tb reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode == 0)
        {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
            if (LOGINTIME!=nil)
            {
                [self creatFileLoad];
                [self creatFileLoadVIP];
            }else
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExit) name:@"exit" object:nil];
                [self getExit];
            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExit) name:@"exit" object:nil];
            if (LOGINTIME==nil) {
                [self getExit];
            }
        }
    }];
}
- (void)getExit{
    [self setNil];
    [self.tb reloadData];
}
- (void)setNil{
    _model=nil;
    _mode=nil;
}
- (void)creatFileLoad{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:@"myData"];
    [self loadData:responseObject];
}
- (void)creatFileLoadVIP{
    FileHander *hander = [FileHander shardFileHand];
    NSDictionary *responseObject =[hander readFile:@"vipData"];
    [self  loadVIPData:responseObject];
}
- (void)loadData:(NSDictionary *)responseObject{
    EPPerModel * model=[EPPerModel mj_objectWithKeyValues:responseObject];
    _model=model;
    NSString * name=responseObject[@"name"];
    NSString * inviteCode=responseObject[@"inviteCode"];
    NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
    [userDef  setObject:name forKey:@"name"];
    [userDef setObject:inviteCode forKey:@"inviteCode"];
    [userDef  synchronize];
}
- (void)loadVIPData:(NSDictionary *)responseObject{
    EPVIPModel * model=[EPVIPModel mj_objectWithKeyValues:responseObject];
    _mode=model;
}
- (void)addObserve
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLogin) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHead:) name:@"getHead" object:nil];
}
- (void)getLogin{
    [self creatFileLoad];
    [self creatFileLoadVIP];
    [self.tb reloadData];
}
- (void)getHead:(NSNotification *)no
{
    _hImg.image=no.object;
    UIImage *lastImage = [_hImg.image applyDarkEffect];
    _backImg.image =lastImage;
}
-(void)clickImg:(UITapGestureRecognizer *)tap{
    [_per returnText:^(NSString *name) {
        _nameLb.text=name;
    }];
    if (LOGINTIME==nil) {
        [self presentViewController:_login animated:YES completion:^{
        }];
    }else{
        _per.hImg=_hImg.image;
        _per.cellName=_nameLb.text;
        [self.navigationController pushViewController:_per animated:YES];
    }
}
-(void)toMember{
    EPMemberController *member = [[EPMemberController alloc]init];
    if (LOGINTIME==nil) {
        member.num=nil;
        member.memLevel=nil;
        member.name=nil;
    }else{
        member.num=_mode.referrals;
        member.memLevel=_mode.level;
        member.name=NAME;
    }
    [self.navigationController pushViewController:member animated:YES];
}
#pragma mark------tableView 的delegate--------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // return 11;
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellID";
    UITableViewCell * syscell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    EPMyTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"EPMyTableViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //图片数组
    //  NSArray * imgs=[NSArray arrayWithObjects:@"purse",@"integral",@"我的订单",@"my_half_price",@"我的评论",@"collection",@"my_car",@"推荐好友",@"我要合作", nil];
    NSArray * imgs=[NSArray arrayWithObjects:@"integral",@"我的订单",@"my_half_price",@"我的评论",@"collection",@"my_car",@"推荐好友",@"我要合作", nil];
    //文字数组
    //NSArray * titles=[NSArray arrayWithObjects:@"我的钱包",@"我的积分",@"我的订单",@"我的半价",@"我的评论",@"我的收藏",@"我的车辆",@"邀请好友",@"我要合作", nil];
    NSArray * titles=[NSArray arrayWithObjects:@"我的积分",@"我的订单",@"我的半价",@"我的评论",@"我的收藏",@"我的车辆",@"邀请好友",@"我要合作", nil];
    if (indexPath.row==0) {
        cell.label.text=titles[0];
        cell.imgV.image=[UIImage imageNamed:imgs[0]];
    }
    if (indexPath.row==1) {
        cell.label.text=titles[1];
        cell.imgV.image=[UIImage imageNamed:imgs[1]];
    }
    if (indexPath.row==2) {
        cell.label.text=titles[2];
        cell.imgV.image=[UIImage imageNamed:imgs[2]];
    }
    if (indexPath.row==3) {
        cell.label.text=titles[3];
        cell.imgV.image=[UIImage imageNamed:imgs[3]];
    }
    if (indexPath.row==4) {
        cell.label.text=titles[4];
        cell.imgV.image=[UIImage imageNamed:imgs[4]];
    }
    if (indexPath.row==5) {
        cell.label.text=titles[5];
        cell.imgV.image=[UIImage imageNamed:imgs[5]];
    }
    //    if (indexPath.row==6) {
    //        cell.label.text=titles[6];
    //        cell.imgV.image=[UIImage imageNamed:imgs[6]];
    //    }
    //if (indexPath.row==7||indexPath.row==9) {
    if (indexPath.row==6||indexPath.row==8) {
        UIView * vc=[[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 10)];
        vc.backgroundColor=RGBColor(234, 234, 234);
        [syscell.contentView addSubview:vc];
        return syscell;
    }
    //    if (indexPath.row==8) {
    //        cell.label.text=titles[7];
    //        cell.imgV.image=[UIImage imageNamed:imgs[7]];
    //    }
    if (indexPath.row==7) {
        cell.label.text=titles[6];
        cell.imgV.image=[UIImage imageNamed:imgs[6]];
    }
    //    if (indexPath.row==10) {
    //        cell.label.text=titles[8];
    //        cell.imgV.image=[UIImage imageNamed:imgs[8]];
    //    }
    if (indexPath.row==9) {
        cell.label.text=titles[7];
        cell.imgV.image=[UIImage imageNamed:imgs[7]];
    }
    
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * vc=[[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 237)];
    vc.backgroundColor=[UIColor whiteColor];
    vc.userInteractionEnabled=YES;
    UIPanGestureRecognizer * pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestures:)];
    [vc addGestureRecognizer:pan];
    UIImageView *backImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,EPScreenW,140)];
    _backImg=backImg;
    backImg.userInteractionEnabled=YES;
    UIView * mceng=[[UIView alloc]initWithFrame:backImg.frame];
    mceng.backgroundColor=RGBColor(29, 32, 40);
    mceng.alpha=0.4;
    [backImg addSubview:mceng];
    
    [vc addSubview:backImg];
    
    CGSize headSize=[[UIImage imageNamed:@"头像框"] size];
    UIImageView * headLine=[[UIImageView alloc]initWithFrame:CGRectMake(EPScreenW/2-35,10,headSize.width,headSize.height)];
    headLine.layer.masksToBounds=YES;
    headLine.layer.cornerRadius=headSize.width/2;
    headLine.userInteractionEnabled=YES;
    headLine.image=[UIImage imageNamed:@"头像框"];
    [backImg addSubview:headLine];
    
    UIImageView *hImg=[[UIImageView alloc]initWithFrame:CGRectMake(1, 1, CGRectGetWidth(headLine.frame)-2, CGRectGetHeight(headLine.frame)-2)];
    _hImg=hImg;
    hImg.userInteractionEnabled=YES;
    hImg.layer.masksToBounds=YES;
    hImg.layer.cornerRadius=hImg.width/2;
    if (_model.icon==nil) {
        hImg.image=[UIImage imageNamed:@"登录头像"];
        backImg.backgroundColor=RGBColor(29, 32, 40);
    }else{
        if ([_model.icon isEqualToString:@""]) {
            hImg.image=[UIImage imageNamed:@"登录头像"];
            backImg.backgroundColor=RGBColor(29, 32, 40);
        }else{
        [hImg sd_setImageWithURL:[NSURL URLWithString:_model.icon]];
        UIImage * img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.icon]]];
        UIImage * back=[img applyDarkEffect];
        backImg.image=back;
        }
    }
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg:)];
    [hImg addGestureRecognizer:tap];
    [headLine addSubview:hImg];
    
    UILabel *nameLb=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headLine.frame)+5,EPScreenW, 14)];
    _nameLb=nameLb;
    nameLb.textColor=RGBColor(216, 186, 131);
    nameLb.textAlignment=NSTextAlignmentCenter;
    nameLb.font=[UIFont systemFontOfSize:14];
    if (_model.name==nil) {
        nameLb.text=@"立即登录";
    }else{
        if (_model.name.length==0) {
            nameLb.text=@"起个昵称吧";
        }else{
            nameLb.text=_model.name;
        }
    }
    UITapGestureRecognizer * taps=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg:)];
    [nameLb addGestureRecognizer:taps];

    nameLb.userInteractionEnabled=YES;
    [backImg addSubview:nameLb];
    
    UILabel * memLevel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLb.frame)+5, EPScreenW, 20)];
    if (_mode.grade==nil) {
        memLevel.text=@"普通会员";
    }else{
        memLevel.text=_mode.grade;
    }
    memLevel.textColor=RGBColor(216,186,131);
    memLevel.textAlignment=NSTextAlignmentCenter;
    memLevel.font=[UIFont systemFontOfSize:12];
    [backImg addSubview:memLevel];
    
    [backImg sendSubviewToBack:mceng];
    
    UIView * vc2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backImg.frame), EPScreenW, 96)];
    vc2.backgroundColor=[UIColor whiteColor];
    CGFloat leftX=15;
    UIImageView * img=[[UIImageView alloc]init];
    img.x=leftX;
    img.y=12;
    img.size=[[UIImage imageNamed:@"推荐好友"] size];
    img.image=[UIImage imageNamed:@"推荐好友"];
    [vc2 addSubview:img];
    
    UILabel * ren=[[UILabel alloc]init];
    ren.x=CGRectGetMaxX(img.frame)+5;
    ren.y=14;
    ren.width=200;
    ren.height=16;
    if (_mode.conditions==nil||_mode.referrals==nil) {
        ren.text=@"已邀请0人,升级还差15人";
    }else{
        ren.text=[NSString stringWithFormat:@"已邀请%@人。升级还差%@人",_mode.referrals,_mode.conditions];
    }
    
    ren.textColor=[UIColor blackColor];
    ren.font=[UIFont systemFontOfSize:14];
    [vc2 addSubview:ren];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(EPScreenW-leftX-80, 7, 80, 27);
    [btn setTitle:@"会员中心>" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toMember) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    btn.layer.masksToBounds=YES;
    btn.layer.borderColor=[[UIColor blackColor] CGColor];
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=5;
    [vc2 addSubview:btn];
    
    //背景图像
    CGSize backSize=[[UIImage imageNamed:@"进度条底框"] size];
    float Pwidth=EPScreenW-leftX*2;
    UIImageView * backProgress=[[UIImageView alloc]initWithFrame:CGRectMake(leftX, 57, Pwidth, backSize.height-1)];
    backProgress.image=[UIImage imageNamed:@"进度条底框"];
    //平均宽度
    CGFloat avgWidth=Pwidth/30;
    [vc2 addSubview:backProgress];
    //Pwidth/2+30
    UIImageView * progress=[[UIImageView alloc]init];
    progress.x=1;
    progress.y=1;
    progress.height=backSize.height;
    if (_mode.referrals==nil)
    {
        progress.width=0;
    }else
    {
        progress.width=_mode.referrals.integerValue*avgWidth;
    }
    UIImage * proImg=[UIImage imageNamed:@"进度条"];
    progress.image=proImg;
    //切圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:progress.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4,4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = progress.bounds;
    maskLayer.path = maskPath.CGPath;
    progress.layer.mask = maskLayer;
    
    [backProgress addSubview:progress];
    [vc2 addSubview:backProgress];
    //人数
    CGSize countSize=[[UIImage imageNamed:@"人数定位"] size];
    UIImageView * imgCount=[[UIImageView alloc]init];
    imgCount.x=CGRectGetMaxX(progress.frame)+8;
    imgCount.y=CGRectGetMinY(backProgress.frame)-4-countSize.height;
    imgCount.width=countSize.width;
    imgCount.height=countSize.height;
    imgCount.image=[UIImage imageNamed:@"人数定位"];
    [vc2 addSubview:imgCount];
    UILabel * lbCount=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgCount.frame)+4, CGRectGetMinY(imgCount.frame),80,countSize.height)];
        if (_mode.referrals==nil)
    {
        lbCount.text=@"0人";
    }else
    {
        lbCount.text=[NSString stringWithFormat:@"%@人",_mode.referrals];
    }
    lbCount.textColor=[UIColor blackColor];
    lbCount.font=[UIFont systemFontOfSize:11];
    [vc2 addSubview:lbCount];
    float width=(EPScreenW-leftX*2)/3;
    float height=16;
    NSArray * arr=[[NSArray alloc]init];
    if (_mode.level1Count==nil||_mode.level2Count==nil||_mode.level3Count==0) {
        NSArray * lbTitle=@[@"普通会员",@"白金会员",@"钻石会员"];
        arr=lbTitle;
    }else{
        NSString * count1=[NSString stringWithFormat:@"普通会员 (%@人)",_mode.level1Count];
        NSString * count2=[NSString stringWithFormat:@"白金会员 (%@人)",_mode.level2Count];
        NSString * count3=[NSString stringWithFormat:@"钻石会员 (%@人)",_mode.level3Count];
        NSArray * lbTitle=@[count1,count2,count3];
        arr=lbTitle;
    }
    for (int i=0; i<3; i++) {
        UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(15+i*width, CGRectGetMaxY(backProgress.frame)+7, width, height)];
        lb.text=arr[i];
        if (i==1)
        {
            lb.textAlignment=NSTextAlignmentCenter;
        }
        if (i==2)
        {
            lb.textAlignment=NSTextAlignmentRight;
        }
        lb.font=[UIFont systemFontOfSize:11];
        lb.textColor=[UIColor blackColor];
        
        [vc2 addSubview:lb];
        
    }
    UIView * vcL=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(vc2.frame), EPScreenW, 1)];
    vcL.backgroundColor=RGBColor(231, 231, 231);
    [vc addSubview:vcL];
    [vc addSubview:vc2];
    
    return vc;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 237;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==6||indexPath.row==8)
    {
        return 10;
    }
    return 68;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            if (LOGINTIME==nil)
            {
                [self presentViewController:_login animated:YES completion:nil];
            }else
            {
                //我的积分
                EPPointsController * vc=[[EPPointsController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        }
            
        case 1:{
            //我的订单
            EPMyOrderVC * vc=[[EPMyOrderVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            //我的半价
            EPMyEpaiViewController * VC=[[EPMyEpaiViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 3:{
            //我的评论
            EPMyJudgeViewController * VC=[[EPMyJudgeViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 4:{
            //我的收藏
            EPCollectionViewController * VC=[[EPCollectionViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 5:{
            //我的车辆
            if (LOGINTIME==nil)
            {
                [self presentViewController:_login animated:YES completion:nil];
            }else
            {
                EPData * data=[EPData new];
                [data bindCarMessageWithType:@"1" withPlateNo:nil withEnineNo:nil withCarNo:nil withCompletion:^(NSString *returnCode, NSString *msg,NSMutableDictionary * dic) {
                    NSArray * arr=dic[@"PassengerCarArr"];
                    if (arr.count==0) {
                        EPAddInfoVC * VC=[[EPAddInfoVC alloc] init];
                        [self.navigationController pushViewController:VC animated:YES];
                    }else{
                        EPMyCarVC * vc=[[EPMyCarVC alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
                
            }
            break;
        }
        case 7:{
            if (LOGINTIME==nil)
            {
                [self presentViewController:_login animated:YES completion:nil];
            }else
            {
                //邀请好友
                EPVIsitVC * vc=[[EPVIsitVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 9:{
            if (LOGINTIME==nil)
            {
                [self presentViewController:_login animated:YES completion:nil];
            }else
            {
                //我要合作
                EPCooprationVC * vc=[[EPCooprationVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        default:
            break;
    }
}
//设置导航栏
- (void)setNav{
    [self addNavigationBar:2 title:@"我的"];
    [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(setClick) name:@"设置"];
    [self addRightItemWithFrame:CGRectZero textOrImage:0 action:@selector(newsClick) name:@"消息"];
}
//左右导航栏按钮点击方法
- (void)setClick
{
    EPSettingViewController * vc =[[EPSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)newsClick
{
    if (LOGINTIME==nil) {
        [self presentViewController:_login animated:YES completion:nil];
    }else{
        EPNewsViewController * vc =[[EPNewsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)creatTb{
    self.tb=[[UITableView alloc]initWithFrame:CGRectMake(0,44, EPScreenW,EPScreenH-49-44) style:UITableViewStylePlain];
    self.tb.showsVerticalScrollIndicator=NO;
    self.tb.separatorInset=UIEdgeInsetsMake(46, 20, 1, 20);
    self.tb.separatorColor=RGBColor(217,217, 217);
    self.tb.bounces=NO;
    //设置代理
    self.tb.delegate=self;
    self.tb.dataSource=self;
    //注册xib
    [self.tb registerNib:[UINib nibWithNibName:@"EPMyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPMyTableViewCell"];
    [self.view addSubview:self.tb];
}
- (void)handlePanGestures:(UIPanGestureRecognizer *)pan{
    NSLog(@"禁止滑动");
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
