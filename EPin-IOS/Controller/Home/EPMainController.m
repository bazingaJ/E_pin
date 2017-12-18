//
//  EPMainController.m
//  EPin-IOS
//  首页
//  Created by jeaderQ on 16/3/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMainController.h"
#import "HeaderFile.h"
#import "EPScanVC.h"
#import "EPSearchVC.h"
#import "EPMainTableViewCell.h"
#import "SDCycleScrollView.h"
#import "EPMenuController.h"
#import "QuadCurveMenu.h"
#import "EPLostVC.h"
#import "EPShopingController.h"
#import "EPSubmitController.h"
#import "EPLeisureController.h"
#import "EPFinancialController.h"
#import "EPGoodsDetailVC.h"
#import "EPPeccCell.h"
#import "AFNetworking.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD.h"
#import "EPCallCarVC.h"
#import "JDPeccancyViewController.h"
#import "EPLoginViewController.h"
#import "EPMainCellView.h"
#import "SYQrCodeScanne.h"
#import "EPFaresController.h"
#import "EPEPaiViewController.h"
#define FourthCellH 273.0 //第四行Cell的高度
#import "DWBubbleMenuButton.h"
#import "EPShopVC.h"
@interface EPMainController ()<UITableViewDataSource,UITableViewDelegate,QuadCurveMenuDelegate,SDCycleScrollViewDelegate,UIScrollViewDelegate,DWBubbleMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) NSMutableArray * imgNames;
@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat row;
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, strong) NSMutableArray *shopArr;
@property (nonatomic, strong) NSMutableArray *bannerId;
@property (nonatomic, strong) NSMutableArray *goodId;
@property (nonatomic, strong) NSMutableArray *shopId;
@property (nonatomic, strong) UIImageView *titleView;
@property (nonatomic, strong) UIImageView  *describeBg;
@property (nonatomic, strong) NSMutableArray *shopName;
@property (nonatomic)  BOOL isloading;
@property (nonatomic, strong) UIRefreshControl *downRef;
@property (nonatomic, strong) NSArray *leftMiddleArr;
@property (nonatomic, strong) NSArray *rightMiddleArr;

/**
 *  顶部左边的绿色视图
 */
@property (nonatomic, strong) UILabel *topLefView;
/**
 *  顶部右边的蓝色视图
 */
@property (nonatomic, strong)UIView *topRightView;


@property (nonatomic, strong) NSMutableDictionary *bannerdic;

@property (nonatomic, strong) DWBubbleMenuButton *upMenuView;
@property (nonatomic, assign) BOOL isOne;

@end

@implementation EPMainController
static NSString *path=@"mainData";

- (void)viewWillAppear:(BOOL)animated
{
    //    [self.tableView setContentOffset:CGPointMake(0, -20) animated:NO];
    //
    //    [self.titleBtn setFrame:CGRectMake(60, 29.5, 0, 0)];
    
    [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
        if (statusCode == 0)
        {
            NSLog(@"网络连接中断");
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"当前网络不可用"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
            [self readLocaLData];
        }
        else
        {
            NSLog(@"网路链接正常");
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getMainData];

            });

        }
    }];

}


- (UIImageView *)createHomeButtonView {
    UIImageView *label = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"快捷按钮"]];
    
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"失物招领", @"违章查询", @"k预约召车"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;

        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender {
    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
    switch (sender.tag)
    {
        case 0:
        {
            if (LOGINTIME) {
                EPLostVC * vc =[[EPLostVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [EPTool addAlertViewInView:self title:@"" message:@"您还没有登录 请先登录" count:0 doWhat:^{
                }];
            }
            
        }
            break;
        case 1:
        {
            
            if (LOGINTIME) {
                JDPeccancyViewController * vc =[[JDPeccancyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您还没有登录 请先登录" count:0 doWhat:^{
                }];
            }
        }
            break;
            
        case 2:
        {
//            if (LOGINTIME) {
                EPCallCarVC * vc =[[EPCallCarVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [EPTool addAlertViewInView:self title:@"" message:@"您还没有登录 请先登录" count:0 doWhat:^{
//                }];
//            }
        }
            break;
        case 3:
        {
        }
            break;
        default:
            break;
    }

    
}

- (UIButton *)createButtonWithName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isOne) {
        return;
    }
    [self creatMenuBtn];
}
-(void)creatMenuBtn{

    // Create down menu button
    UIImageView *homeLabel = [self createHomeButtonView];
    _upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 20.f,self.view.frame.size.height - homeLabel.frame.size.height - 64.f,homeLabel.frame.size.width,homeLabel.frame.size.height) expansionDirection:DirectionUp];
    _upMenuView.homeButtonView = homeLabel;
    [_upMenuView addButtons:[self createDemoButtonArray]];
    _upMenuView.delegate = self;
    [_upMenuView bringSubviewToFront:self.view];
    [self.view addSubview:_upMenuView];
    _isOne = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self readLocaLData];
    [self prepareForNavView];
//    [self prepareView];
    Cell1 = 60;
    [self addmengceng];
    [self setDownRefresh];
}


-(void)setDownRefresh
{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMainData)];
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)addmengceng
{

    UITapGestureRecognizer* buttonClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg)];
    UIImageView *imageVie = [[UIImageView alloc]initWithFrame:CGRectMake(EPScreenW-40, 64+20, 0, 0)];
    [imageVie addGestureRecognizer:buttonClick];
    imageVie.userInteractionEnabled = YES;
    imageVie.image = [UIImage imageNamed:@"弹窗"];
    [self.view addSubview:imageVie];
    self.describeBg = imageVie;
    
}
-(void)clickImg{
    
    [UIView animateWithDuration:.3 animations:^{
        self.describeBg.frame = CGRectMake(EPScreenW-40, 64+20, 0, 0);
    } completion:^(BOOL finished) {
    }];
    
}
-(void)big{
    [UIView animateWithDuration:.3 animations:^{

    self.describeBg.frame = CGRectMake(0, 64, WIDTH(375.0, 375),HEIGHT(555.0, 667));
    }];

}
-(void)readLocaLData{
    FileHander *hander = [FileHander shardFileHand];
   NSDictionary *responseObject =[hander readFile:path];
    [self loadDataWithDic:responseObject];
    [self.tableView reloadData];
}

-(void)getMainData{
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"phoneNo"] = PHONENO;
    parame[@"loginTime"] = LOGINTIME;
    AFHTTPSessionManager *manag = [AFHTTPSessionManager manager];
    NSString *urls = [NSString stringWithFormat:@"%@/getPersonalAsset.json",EPUrl];
    [manag POST:urls parameters:parame success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *returnCode = responseObject[@"returnCode"];
        NSString *score = responseObject[@"score"];
        NSString *msg = responseObject[@"msg"];
        if ([returnCode intValue]==0) {
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setValue:score forKey:@"score"];
            if ([msg isEqualToString:@"失败!"]) {
                
            }

        }else if ([returnCode intValue]==2){
            [EPLoginViewController publicDeleteInfo];
            UIViewController *rootVc=   [UIApplication sharedApplication].keyWindow.rootViewController;
            EPLoginViewController *loginVc = [[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:rootVc title:@"温馨提示" message:msg count:1 doWhat:^{
                [rootVc presentViewController:loginVc animated:YES completion:^{
                }];
            }];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s error%@",__func__,error);
    }];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/getYPgoodsList.json",EPUrl];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"type"]=@"0";
    [manager POST:url parameters:parames success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray *bannerArr = responseObject[@"bannerArr"];
        self.bannerArr = [EPMainModel mj_objectArrayWithKeyValuesArray:bannerArr];
        self.leftMiddleArr = [EPMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"leftMiddleArr"]];
        self.rightMiddleArr =[EPMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"rightMiddleArr"]];
//        for (dic in mainMode.bannerArr) {
//            [bannerArr addObject:dic[@"goodsSaleImg"]];
//            [self.bannerId addObject:dic[@"goodsId"]];
//            
//        }
        FileHander *hander = [FileHander shardFileHand];
        NSString *sss=@"banner";
        [hander saveFile:responseObject withForName:path withError:&sss];
        [self.tableView reloadData];
        self.isloading = NO;
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    NSString *urlbottom = [NSString stringWithFormat:@"%@/getYPMoregoodsList.json",EPUrl];
    [manager POST:urlbottom parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        [self loadDataWithDic:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

-(void)loadDataWithDic:(NSDictionary *)responseObject{
    EPMainModel *mainMode = [EPMainModel mj_objectWithKeyValues:responseObject];
    NSMutableArray *goodArr = [NSMutableArray array];
    NSMutableArray *shopArr = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in mainMode.goodsArr) {
        [goodArr addObject:dic[@"goodsImg"]];
        [self.goodId addObject:dic[@"goodsId"]];
    }
    for (NSMutableDictionary *dic in mainMode.shopsArr) {
        [shopArr addObject:dic[@"shopImg"]];
        [self.shopId addObject:dic[@"shopId"]];
        [self.shopName addObject:dic[@"shopShortName"]];
    }
    self.goodArr = goodArr;
    self.shopArr = shopArr;
}

- (void)prepareForNavView
{
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
    [self addMaintitle:@""];
    [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(searchBtnClick) name:@"导航搜索"];
    [self addRightItemWithFrame:CGRectZero textOrImage:0 action:@selector(sweepBtnClick) name:@"导航扫码"];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"易品LOGO"]];
    titleView.center = CGPointMake(EPScreenW/2, 42);
    [self.view addSubview:titleView];
    _titleView = titleView;
    //看上去是搜索框 但实际上是一个button
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setBackgroundColor:[UIColor whiteColor]];
    [seachBtn setFrame:CGRectMake(60, 29.5+25, 0, 0)];
    seachBtn.layer.cornerRadius = 8.0;
    [seachBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn = seachBtn;
    [seachBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:seachBtn];
}
//动画按钮的实现
- (void)prepareView
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"失物招领"] highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"违章查询"] highlightedContentImage:nil];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"k预约召车"] highlightedContentImage:nil];
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem, placeMenuItem, nil];
    QuadCurveMenu * menu =[[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.delegate=self;
    [self.view addSubview:menu];
}


- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx)
    {
        case 0:
        {
            if (LOGINTIME) {
                EPLostVC * vc =[[EPLostVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [EPTool addAlertViewInView:self title:@"" message:@"您还没有登录 请先登录" count:0 doWhat:^{
                }];
            }
            
        }
            break;
        case 1:
        {
            
            if (LOGINTIME) {
                JDPeccancyViewController * vc =[[JDPeccancyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您还没有登录 请先登录" count:0 doWhat:^{
                }];
            }
        }
            break;
            
        case 2:
        {
            if (LOGINTIME) {
                EPCallCarVC * vc =[[EPCallCarVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [EPTool addAlertViewInView:self title:@"" message:@"您还没有登录 请先登录" count:0 doWhat:^{
                }];
            }
        }
            break;
        case 3:
        {
        }
            break;
        default:
            break;
    }
}
//导航左边按钮点击事件
- (void)searchBtnClick
{
    EPSearchVC * search =[[EPSearchVC alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}
//导航右边按钮点击事件
- (void)sweepBtnClick
{
    SYQrCodeScanne *VC = [[SYQrCodeScanne alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    VC.scanneScusseBlock = ^(SYCodeType codeType, NSString *url){
        
        if (SYCodeTypeUnknow == codeType)
        {
            [EPTool addMBProgressWithView:self.view style:0];
            [EPTool showMBWithTitle:@"无法识别的二维码"];
            [EPTool hiddenMBWithDelayTimeInterval:1];
        }
        else if (SYCodeTypeLink == codeType)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        }
        else
        {
            NSArray * strArr =[url componentsSeparatedByString:@"?"];
            NSString * firstStr = [strArr firstObject];
            if ([firstStr isEqualToString:@"payToDriver"])
            {
                if (LOGINTIME)
                {
                    NSString * urlStr =[strArr lastObject];
                    EPFaresController * vc =[[EPFaresController alloc] init];
                    EPData * data =[EPData new];
                    vc.orderId=[data getUniqueStrByUUID];
                    vc.driverId=urlStr;
                    vc.isScan=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            if ([firstStr isEqualToString:@"gotoShop"]) {
                NSString * goodsId=[strArr lastObject];
                EPShopVC* vc=[[EPShopVC alloc]init];
                vc.shopId=goodsId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    };
    [VC scanning];
    
//    EPScanVC * scan =[[EPScanVC alloc] init];
//    [self.navigationController pushViewController:scan animated:YES];
}

#pragma mark - tableView delegate&datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.shopArr.count==0) {
        return 4;
    }else{
    
    return self.shopArr.count+4;
    }
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
-(void)goLogIn{
    EPLoginViewController *login = [[EPLoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:^{
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"mainCell";
    static NSString * cellIdentifier =@"cell4";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    EPPeccCell * cell1 =nil;
    
    cell = [[NSBundle mainBundle] loadNibNamed:@"EPMainTableViewCell" owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        cell.contentView.backgroundColor = RGBColor(52, 58, 74);
        //登录后的当前积分
        UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 60)];
        self.viewBg = viewBg;
        viewBg.backgroundColor = RGBColor(52, 58, 74);
        UILabel *firstL = [[UILabel alloc]init];
        firstL.text = @"您当前拥有：";
        CGSize firSize = [self sizeWithText:firstL.text font:[UIFont systemFontOfSize:18]];
        firstL.size = firSize;
        firstL.centerY = 61/2;
        firstL.x = 19;
        firstL.font = [UIFont systemFontOfSize:18];
        firstL.textColor = RGBColor(218, 187, 132);
        
        UILabel *secondL = [[UILabel alloc]init];
        
        NSString *tex = TOTALSCORE;
        secondL.text = [NSString stringWithFormat:@"%@",tex];
        CGSize secondSize = [self sizeWithText:secondL.text font:[UIFont systemFontOfSize:28]];
        secondL.size = secondSize;
        secondL.centerY = 61/2-2;
        secondL.x = CGRectGetMaxX(firstL.frame)-5;
        secondL.font = [UIFont systemFontOfSize:28];
        secondL.textColor = RGBColor(218, 187, 132);
        
        UILabel *thirdL = [[UILabel alloc]init];
        thirdL.text = @"积分";
        CGSize thirdSize = [self sizeWithText:firstL.text font:[UIFont systemFontOfSize:15]];
        thirdL.size = thirdSize;
        thirdL.centerY = 61/2-2;
        thirdL.x = CGRectGetMaxX(secondL.frame);
        thirdL.font = [UIFont systemFontOfSize:15];
        thirdL.textColor = RGBColor(218, 187, 132);
        UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logBtn setImage:[UIImage imageNamed:@"请登录或注册"] forState:UIControlStateNormal];
        [logBtn setFrame:CGRectMake(0, 0, 108, 20)];
        logBtn.centerY= 61/2-2;
        logBtn.centerX = EPScreenW/2;
        UIButton *btnBG = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBG.frame = viewBg.frame;
        [btnBG addTarget:self action:@selector(goLogIn) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(EPScreenW-WIDTH(92.0, 375)-button.width, HEIGHT(18.0, 667), WIDTH(72.0, 375), HEIGHT(30.0, 667))];
        button.centerY =  thirdL.centerY = 61/2;
        [button setTitle:@"积分规则" forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(218, 187, 132) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderColor = RGBColor(218, 187, 132).CGColor;
        button.layer.borderWidth = .5;
        button.layer.cornerRadius = 3;
        [button addTarget:self action:@selector(big) forControlEvents:UIControlEventTouchUpInside];
        if (TOTALSCORE) {
            [viewBg addSubview:firstL];
            [viewBg addSubview:secondL];
            [viewBg addSubview:thirdL];
            [viewBg addSubview:button];
        }else{
            [viewBg addSubview:logBtn];
            [viewBg addSubview:btnBG];
        }
//        CGFloat leftX = 0;
//        CGFloat leftY = 0;
//        CGFloat leftW = EPScreenW/3;
//        CGFloat leftH = viewBg.height;
//        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
//        _topLefView = leftView;
//        leftView.textColor = RGBColor(51, 60, 24);
        if (TOTALSCORE) {
//            leftView.text = [NSString stringWithFormat:@"%@ 积分",TOTALSCORE];
        }else{
//             leftView.text =@"0 积分";
        }
        
//        leftView.textAlignment = NSTextAlignmentCenter;
//        leftView.font = [UIFont systemFontOfSize:15];
//        leftView.backgroundColor = RGBColor(181, 222, 64);
//        [viewBg addSubview:leftView];
//        CGFloat rightX = leftW;
//        CGFloat rightY = 0;
//        CGFloat rightW = EPScreenW-leftW;
//        CGFloat rightH = viewBg.height;
//        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
//        _topRightView = rightView;
//        rightView.backgroundColor = RGBColor(125, 221, 233);
//        [viewBg addSubview:rightView];
        [cell.contentView addSubview:viewBg];
    }else if (indexPath.row==1){
        if (self.shopArr.count ==0 ) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
        [EPTool hiddenMBWithDelayTimeInterval:1];
            NSMutableArray *goodsSaleImgArr = [NSMutableArray array];
            
            for (EPMainModel *model in self.bannerArr) {
                [goodsSaleImgArr addObject:model.goodsSaleImg];
                [self.bannerId addObject:model.goodsId];
            }
        SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, EPScreenSize.width,HEIGHT(175.0, 667)) delegate:self placeholderImage:nil];
        banner.imageURLStringsGroup = goodsSaleImgArr;
        banner.delegate = self;
        [cell.contentView addSubview:banner];}
        return cell;
    }else if (indexPath.row == 2)
    {
        NSArray *btnName =@[@"美食",@"娱乐",@"购物"];
        UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
        [cell.contentView addSubview:view];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 1)];
        line.backgroundColor =RGBColor(224, 225, 226);
        [view addSubview:line];
        for (int i = 0; i < 3; i++)
        {
            //计算每一个btn的位置
            CGFloat btnW = EPScreenW/3;
            CGFloat btnH = HEIGHT(58.0, 667);
            CGFloat btnX = btnW * i;
            CGFloat btnY = HEIGHT(2.0, 375);
            UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:menuBtn];
            [menuBtn setImage:[UIImage imageNamed:btnName[i]] forState:UIControlStateNormal];
            menuBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            menuBtn.tag = 433 +i;
//            UILabel *labe = [[UILabel alloc]init];
//            labe.x = CGRectGetMaxX(menuBtn.frame)-30;
//            labe.centerY = menuBtn.centerY-10;
//            labe.size = [self sizeWithText:btnName[i] font:[UIFont systemFontOfSize:16]];
//            labe.text = btnName[i];
//            labe.textAlignment =   NSTextAlignmentLeft;
//            labe.font = [UIFont systemFontOfSize:16];
//            labe.textColor = RGBColor(29, 32, 40);
//            [view addSubview:labe];
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = RGBColor(231, 216, 184);
            
            line.x = EPScreenW/3*i;
            line.y = HEIGHT(20.0, 667);
            line.width = .5;
            line.height = HEIGHT(33.0, 667);
            [view addSubview:line];
        }
    }else if (indexPath.row==3)
    {
        cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell1)
        {
            cell1=[[NSBundle mainBundle]loadNibNamed:@"EPPeccCell" owner:nil options:nil][3];
        }
        EPMainModel *model = [EPMainModel new];
        if (self.leftMiddleArr.count>=1) {
            model = self.leftMiddleArr[0];
            [cell1.btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.goodsSaleImg] forState:UIControlStateNormal];

        }
        if (self.leftMiddleArr.count>=2) {
            model = self.leftMiddleArr[1];
            [cell1.btn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.goodsSaleImg] forState:UIControlStateNormal];

        }
        if (self.rightMiddleArr.count>0) {
            model = self.rightMiddleArr[0];
            [cell1.btn3 sd_setBackgroundImageWithURL:[NSURL URLWithString:model.goodsSaleImg] forState:UIControlStateNormal];
        }
        [cell1.btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.btn2 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.btn3 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell1;
    }
    else
    {
//        UIImageView *cellImage = [[UIImageView alloc]init];
//        [cellImage sd_setImageWithURL:[NSURL URLWithString:self.shopArr[indexPath.row-4]]];
//        cellImage.width = EPScreenW;
//        cellImage.height = HEIGHT(176.0, 667);
//        self.cellImage = cellImage;
//        [cell.contentView addSubview:cellImage];
        cell = [[EPMainCellView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 176.0) andData:self.shopArr[indexPath.row-4] shopsName:self.shopName[indexPath.row-4]];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    if (indexPath.row>=4)
    {
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        //x和y的最终值为1
        [UIView animateWithDuration:0.5 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }
}

- (void)BtnClick:(UIButton *)sender
{
    EPMainModel *model = [EPMainModel new];
    switch (sender.tag) {
        case 18:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            model = self.leftMiddleArr[0];
            detail.goodsId = model.goodsId;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 19:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            model = self.leftMiddleArr[1];
            detail.goodsId = model.goodsId;

            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 20:
        {
            EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
            model = self.rightMiddleArr[0];
            detail.goodsId = model.goodsId;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        default:
            break;
    }
}
/**
 *  首页美食那一行的Btn
 *  @param sender 根据tag值确定选中的按钮
 */
-(void)menuBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 433:
        {
            EPMenuController * menu =[[EPMenuController alloc] init];
            [self.navigationController pushViewController:menu animated:YES];
        }
            break;
        case 434:
        {
            EPLeisureController *leisure = [[EPLeisureController alloc]init];
            [self.navigationController pushViewController:leisure animated:YES];

        }
            break;
        case 435:
        {
            EPShopingController * menu =[[EPShopingController alloc] init];
            [self.navigationController pushViewController:menu animated:YES];
        }
            break;

//            EPEPaiViewController * vc=[[EPEPaiViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        case 437:
        {
//            EPPayViewController * menu =[[EPPayViewController alloc] init];
//            [self.navigationController pushViewController:menu animated:YES];
        }
            break;
           
        default:
            break;
    }
    
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return Cell1;
    }else if (indexPath.row == 1)
    {
        return HEIGHT(175.0, 667);
    }
    else if (indexPath.row == 2)
    {
        return HEIGHT(63.0, 667);
    }
    else if (indexPath.row==3)
    {
        return HEIGHT(160.0, 667);
    }
    else
    {
        return 176.0;
    }
}
//banner 图片选中时跳转方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
    detail.goodsId = self.bannerId[index];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - tableview滚动的时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    self.topLefView.font=[UIFont  systemFontOfSize:15-offsetY/5];
//    //导航字体渐变动画=================
//    if (offsetY>0) {
//            [UIView animateWithDuration:0.5 animations:^{
//                 self.titleView.alpha = 0.0;
//            }];
//    }else {
//        [UIView animateWithDuration:0.3 animations:^{
//        self.titleView.alpha = 1;
//                 }];
//    }

//    if (self.offsetY>offsetY) {
//        if (self.offsetY<40) {
//            if (offsetY<=-20) {
//                [self.titleBtn setFrame:CGRectMake(60, 29.5, 0, 0)];
//            }
//            [UIView animateWithDuration:.3 animations:^{
//
//        [self.tableView setContentOffset:CGPointMake(0, -20) animated:NO];
//            }];
//
//        }
//
//    }else{
//        if (self.offsetY>-20&&offsetY<40) {
//            
//                CGFloat btnX = 60;
//                CGFloat btnY = 54.5-25*(offsetY+20)/60;
//                CGFloat btnW = (EPScreenW-120)*(offsetY+20)/60;
//                CGFloat btnH = 25*(offsetY+20)/60;
//                [self.titleBtn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
//                if (-20<=offsetY&&offsetY<-13) {
//                    [self.titleBtn setFrame:CGRectMake(btnX, 29.5, 0, 0)];
//                }
//            [UIView animateWithDuration:.3 animations:^{
//            [self.tableView setContentOffset:CGPointMake(0, 40) animated:NO];
//            }];
//        }else if (self.offsetY>=40){
//            [self.titleBtn setFrame:CGRectMake(60, 29.5, EPScreenW-120, 25)];
//        }
//    }
//    self.offsetY = offsetY;
//    NSLog(@"%s  offset == %f",__func__ ,offsetY);
//    if (offsetY==2.00||offsetY==25.0||offsetY==3.00||offsetY==4.00||offsetY==5.00) {
//        [UIView animateWithDuration:.3 animations:^{
//
//       [self.tableView setContentOffset:CGPointMake(0, 40) animated:NO];
//            [self.titleBtn setFrame:CGRectMake(60, 29.5, EPScreenW-120, 25)];
//
//        }];
//    }else if (offsetY==-15){
//        [UIView animateWithDuration:.3 animations:^{
//            
//            [self.tableView setContentOffset:CGPointMake(0, -20) animated:NO];
//            [self.titleBtn setFrame:CGRectMake(60, 29.5, EPScreenW-120, 25)];
//
//        }];
//    }
    //绿蓝条动画====================================
//    if (offsetY<-20) {
//        self.topLefView.y = offsetY+20;
//        self.topLefView.height = -offsetY+40;
//        self.topLefView.width = EPScreenW/3 - offsetY - 20;
//        self.topRightView.y = offsetY;
//        self.topRightView.height = -offsetY+60;
//        self.topRightView.x = self.topLefView.width;
//        self.topRightView.width = EPScreenW-self.topLefView.width;
//    }
    
    //搜索框动画========================================
//    if (-20<offsetY&&offsetY<40) {
//        
//        CGFloat btnX = 60;
//        CGFloat btnY = 54.5-25*(offsetY+20)/60;
//        CGFloat btnW = (EPScreenW-120)*(offsetY+20)/60;
//        CGFloat btnH = 25*(offsetY+20)/60;
//        [self.titleBtn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
//        if (-20<=offsetY&&offsetY<-13) {
//            [self.titleBtn setFrame:CGRectMake(btnX, 29.5, 0, 0)];
//        }
//    }
//    
//    if (offsetY>=40) {
//        [self.titleBtn setFrame:CGRectMake(60, 29.5, EPScreenW-120, 25)];
//    }
//    if (offsetY<=-20) {
//        [self.titleBtn setFrame:CGRectMake(60, 29.5, 0, 0)];
//    }
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
////    CGFloat row =indexPath.row;
////    if (self.row <row) {
////        self.cellImage.width = EPScreenW*0.618;
////        self.cellImage.x = EPScreenW*0.191;
////    }
////       self.row = row;
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  
    
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    CGFloat offsetY = scrollView.contentOffset.y;
//
//    if (offsetY>-20&&offsetY<0) {
//        
//        [UIView animateWithDuration:0.5 animations:^{
//
//        [self.tableView setContentOffset:CGPointMake(0, 40) animated:YES];
//        }];
//    }
//}
////给cell滚动时添加动画
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row==self.imgNames.count+4){
//        //设置Cell的动画效果为3D效果˜
//        //设置x和y的初始值为0.1；
//        cell.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
//        //x和y的最终值为1
//        [UIView animateWithDuration:1 animations:^{
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        }];
//    }else if (indexPath.row >3) {
//    //设置Cell的动画效果为3D效果
//    cell.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >3) {
        EPShopVC * vc=[[EPShopVC alloc]init];
        vc.shopId = self.shopId[indexPath.row-4];
        [self.navigationController pushViewController:vc animated:YES];
//        EPShopViewController *detail = [[EPShopViewController alloc]init];
//        detail.shopId = self.shopId[indexPath.row-4];
//        [self.navigationController pushViewController:detail animated:YES];
    }
}
- (NSMutableArray *)bannerId {
    if (!_bannerId) {
        _bannerId = [[NSMutableArray alloc] init];
    }
    return _bannerId;
}
- (NSMutableArray *)shopId {
    if (!_shopId) {
        _shopId = [[NSMutableArray alloc] init];
    }
    return _shopId;
}
- (NSMutableArray *)goodId {
    if (!_goodId) {
        _goodId = [[NSMutableArray alloc] init];
    }
    return _goodId;
}

- (NSMutableArray *)shopName {
    if (!_shopName) {
        _shopName = [[NSMutableArray alloc] init];
    }
    return _shopName;
}


@end
