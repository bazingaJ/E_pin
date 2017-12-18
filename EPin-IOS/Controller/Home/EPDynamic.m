//
//  EPDynamic.m
//  EPin-IOS
//
//  Created by jeaderq on 2016/10/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPDynamic.h"
#import "UIView+EPFrame.h"
#import "UIButton+WebCache.h"
#import "HeaderFile.h"
#import "EPMainModel.h"
#import "MHActionSheet.h"

//------支付宝------
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

#define WIDTH(a,b) (a/b*[UIScreen mainScreen].bounds.size.width)
#define HEIGHT(a,b) ((a/b)*[UIScreen mainScreen].bounds.size.height)
#define RGBColor(a,b,c)  [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define EPScreenH [UIScreen mainScreen].bounds.size.height
#define EPScreenW [UIScreen mainScreen].bounds.size.width
#define EPScreenSize [UIScreen mainScreen].bounds.size
#import "SDCycleScrollView.h"

@interface EPDynamic ()<SDCycleScrollViewDelegate,UIScrollViewDelegate>
{
    NSString *orderId;
}
@property (nonatomic,strong)EPEPaiDetailModel * model;
@property (nonatomic, strong) UIButton *viewBg;
@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation EPDynamic

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:1];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    EPData * data=[EPData new];
    [data getAuctionDataWithType:@"1" withGoodsId:self.goodsId withOrderId:nil Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        NSLog(@"拍品详情--%@",dic);
        if ([returnCode intValue]==0) {
            [self loadDataWithDic:dic];
        }
    }];

    
}

-(void)loadDataWithDic:(NSDictionary *)dic{
    EPEPaiDetailModel * model=[EPEPaiDetailModel mj_objectWithKeyValues:dic];
    _model=model;
       NSLog(@"goodsId===%@",self.goodsId);
    UIScrollView *BGScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, EPScreenW, EPScreenH-64-58)];
    BGScroller.backgroundColor = RGBColor(191, 191, 191);
    BGScroller.delegate = self;
    BGScroller.scrollEnabled = YES;
    BGScroller.bounces = NO;
    
    [self addDataView:BGScroller];
    
       if ([model.lostTime isEqualToString:@"0日0时0分"]) {
        [self addNavigationBar:1 title:@"活动已结束"];
        [self creatBtn:@"已结束"];

    }else{
        NSArray * hours = [model.lostTime componentsSeparatedByString:@"时"];
        NSString *tm  = [hours[1] substringToIndex:1];

    if ([tm isEqualToString:@"-"]) {
        [self addNavigationBar:1 title:@"活动已结束"];
        [self creatBtn:@"已结束"];

    }else{
        [self addNavigationBar:1 title:[NSString stringWithFormat:@"还有%@结束",model.lostTime]];
        [self creatBtn:@"立即参与"];
    }
    [self.view addSubview:BGScroller];
    
    }
}
-(void)addDataView:(UIScrollView *)bgScroller{
    
    CGFloat viewHeight = 0;
    NSMutableArray * arrImg=[[NSMutableArray alloc]init];
    for (NSDictionary * dict in _model.imgArray) {
        NSString * goodsImg=dict[@"goodsImg"];
        [arrImg addObject:goodsImg];
    }
    //展示图片
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, EPScreenSize.width,289) delegate:self placeholderImage:[UIImage imageNamed:@"bg椭圆"]];
    banner.localizationImageNamesGroup = arrImg;
    //        banner.imageURLStringsGroup = self.bannerArr;
    banner.delegate = self;
    [bgScroller addSubview:banner];
    viewHeight = CGRectGetMaxY(banner.frame);
    
    //商品名称以及价格
    UIView *viewBg =[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(banner.frame), EPScreenW-16, 106)];
    
    viewBg.backgroundColor = RGBColor(255, 255, 255);
    viewBg.layer.cornerRadius = 5;
    //半价商品名称
    UILabel *nameL = [[UILabel alloc]init];
    CGSize nameLSize = [self sizeWithText:_model.goodsName font:[UIFont systemFontOfSize:14]];
    nameL.text = _model.goodsName;
    nameL.frame = (CGRect){{8,31},nameLSize};
    nameL.font = [UIFont systemFontOfSize:14];
    nameL.textColor = RGBColor(0, 0, 0);
    [viewBg addSubview:nameL];
    //半价商品原价
    UILabel *originalL = [[UILabel alloc]init];
    CGSize originalSize = [self sizeWithText:_model.goodsPrice font:[UIFont systemFontOfSize:14]];
    originalL.frame = (CGRect){{CGRectGetMaxX(nameL.frame),31},originalSize};
    originalL.text = _model.goodsPrice;
    originalL.font = [UIFont systemFontOfSize:14];
    originalL.textColor = RGBColor(255, 67, 67);
    [viewBg addSubview:originalL];
    //认购价
    UIButton * renGou = [UIButton buttonWithType:UIButtonTypeCustom];
    renGou.titleLabel.font = [UIFont systemFontOfSize:17];
    [renGou setTitle:@"认购价:" forState:UIControlStateNormal];
    [renGou setTitleColor:RGBColor(255, 67, 67) forState:UIControlStateNormal];
    CGSize btnSize = [self sizeWithText:@"认购价:" font:[UIFont systemFontOfSize:17]];
    renGou.frame = (CGRect){{8,CGRectGetMaxY(nameL.frame)+24},btnSize};
    renGou.layer.cornerRadius = 5;
    renGou.backgroundColor = RGBColor(255, 255, 255);
    [viewBg addSubview:renGou];
    //认购价格
    UILabel *priceL = [[UILabel alloc]init];
    CGSize priceSize = [self sizeWithText:_model.goodsClapPrice font:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    [priceL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    priceL.frame = (CGRect){{CGRectGetMaxX(renGou.frame)+8,CGRectGetMaxY(nameL.frame)+18},priceSize};
    priceL.text = [NSString stringWithFormat:@"%@",_model.goodsClapPrice];
    priceL.textColor = RGBColor(255, 67, 67);
    [viewBg addSubview:priceL];
    
    UIView *line = [[UIView alloc]init];
    line.frame = (CGRect){{CGRectGetMaxX(priceL.frame)+16,CGRectGetMaxY(nameL.frame)+28},1,15};
    line.backgroundColor = RGBColor(204, 204, 204);
    [viewBg addSubview:line];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"people_banjiapai"]];
    imageV.x = CGRectGetMaxX(line.frame)+16;
    imageV.y = CGRectGetMaxY(nameL.frame)+31;
    [viewBg addSubview:imageV];
    
    UILabel *count = [[UILabel alloc]init];
    CGSize countSize = [self sizeWithText:[NSString stringWithFormat:@"%@人参与",_model.onlookers] font:[UIFont systemFontOfSize:12]];
    count.frame = (CGRect){{CGRectGetMaxX(imageV.frame)+5,imageV.y-2},countSize};
    count.font = [UIFont systemFontOfSize:12];
    count.textColor = RGBColor(0, 0, 0);
    count.text = [NSString stringWithFormat:@"%@人参与",_model.onlookers];
    [viewBg addSubview:count];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = (CGRect){{EPScreenW-43,10},16,16};
    [shareBtn setImage:[UIImage imageNamed:@"share_banjia2"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:shareBtn];
    //
    //        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        collectionBtn.frame = (CGRect){{CGRectGetMidX(shareBtn.frame)-35,10},16,16};
    //        [collectionBtn setImage:[UIImage imageNamed:@"love_banjia2"] forState:UIControlStateNormal];
    //        [viewBg addSubview:collectionBtn];
    [bgScroller addSubview:viewBg];
    viewHeight = CGRectGetMaxY(viewBg.frame);

    
    //基本参数数据展示
    UIView *viewBg1 =[[UIView alloc]init];
    viewBg1.x = WIDTH(8.0, 375);
    viewBg1.y = CGRectGetMaxY(viewBg.frame)+7;
    viewBg1.width = EPScreenW-WIDTH(16.0, 375);
    viewBg1.backgroundColor = RGBColor(255, 255, 255);
    viewBg1.layer.cornerRadius = 5;
    CGFloat viewBgH = 0;
    
    UILabel *parametersL = [[UILabel alloc]init];
    CGSize parametersSize = [self sizeWithText:@"基本参数" font:[UIFont systemFontOfSize:14]];
    parametersL.frame = (CGRect){{8,9},parametersSize};
    parametersL.text = @"基本参数";
    parametersL.font = [UIFont systemFontOfSize:14];
    parametersL.textColor = RGBColor(0, 0, 0);

    
    for (int i = 0; i < _model.record.count; i++) {
        NSString * label=_model.record[i][@"label"];
        NSString * value=_model.record[i][@"value"];
        CGSize labelSize = [self sizeWithText:[NSString stringWithFormat:@"%@:%@",label,value] font:[UIFont systemFontOfSize:12] maxW:155];
        CGFloat labelX = 8 +((EPScreenW-16)/2-10)*(i%2);
        CGFloat y=11+CGRectGetMaxY(parametersL.frame)+(10+labelSize.height)*(i/2);
        UILabel * lb=[[UILabel alloc]init];
        lb.x=labelX;
        lb.y=y;
        lb.size=labelSize;
        lb.text=[NSString stringWithFormat:@"%@:%@",label,value];
        lb.font=[UIFont systemFontOfSize:12];
        [viewBg1 addSubview:lb];
        viewBgH = CGRectGetMaxY(lb.frame)+9;
    }
    if (_model.record.count) {
        viewBg1.height = viewBgH;
        [viewBg1 addSubview:parametersL];
        [bgScroller addSubview:viewBg1];
        viewHeight = CGRectGetMaxY(viewBg1.frame);

    }
    //细节展示图片
    UIView *viewBg2 =[[UIView alloc]init];
    viewBg2.x = 8;
    viewBg2.y = viewHeight+7;
    viewBg2.width = EPScreenW-16.0;
    viewBg2.backgroundColor = RGBColor(255, 255, 255);
    viewBg2.layer.cornerRadius = 5;
    viewBg2.userInteractionEnabled = YES;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"左按钮正常"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"左按钮高亮"] forState:UIControlStateSelected];
    leftBtn.frame = (CGRect){{0,0},viewBg.width/2,48.0};
    [leftBtn setTitle:@"细节欣赏" forState:UIControlStateNormal];
    [leftBtn setTitle:@"细节欣赏" forState:UIControlStateSelected];
    [leftBtn setTitleColor:RGBColor(106, 106, 106) forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    leftBtn.selected = YES;
    
    leftBtn.tag = 35;
    [leftBtn addTarget:self action:@selector(selectedImg:) forControlEvents:UIControlEventTouchUpInside];
    [viewBg2 addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"右按钮正常"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"右按钮高亮"] forState:UIControlStateSelected];
    [rightBtn setTitle:@"认购须知" forState:UIControlStateNormal];
    [rightBtn setTitle:@"认购须知" forState:UIControlStateSelected];
    [rightBtn setTitleColor:RGBColor(106, 106, 106) forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateSelected];
    rightBtn.tag = 36;
    [rightBtn addTarget:self action:@selector(selectedImg:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.frame = (CGRect){{viewBg.width/2,0},viewBg.width/2,48.0};
    [viewBg2 addSubview:rightBtn];
    UIView *line1 = [[UIView alloc]init];
    line1.frame = (CGRect){{0,CGRectGetMaxY(leftBtn.frame)-1},viewBg.width,1};
    line1.backgroundColor = RGBColor(217, 217, 217);
    [viewBg2 addSubview:line1];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.describeImg] forState:UIControlStateNormal placeholderImage:nil];
    [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.SubscriptionImg] forState:UIControlStateSelected placeholderImage:nil];
    imageBtn.x = 0;
    imageBtn.y = CGRectGetMaxY(leftBtn.frame);
    imageBtn.width = viewBg2.width;
      UIImage * img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.SubscriptionImg]]];
    CGSize ss=img.size;
    imageBtn.height = ss.height;
    imageBtn.tag = 3333;
    imageBtn.userInteractionEnabled = NO;
    [viewBg2 addSubview:imageBtn];
    
//    UIImageView *imageTitle = [[UIImageView alloc]init];
//    [imageTitle sd_setImageWithURL:[NSURL URLWithString:_model.SubscriptionImg]];
//
//    UIImage *imageT = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.SubscriptionImg]]];
//    CGSize ssT=imageT.size;
//    imageTitle.frame = (CGRect){{0,CGRectGetMaxY(line.frame)},EPScreenW-16,ssT.height};
//    [viewBg2 addSubview:imageTitle];
//    [bgScroller addSubview:viewBg2];
//    self.imageV = [[UIImageView alloc]init];
//    //self.imageV.image = [UIImage imageNamed:@"xijie"];
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_model.describeImg]];
//    UIImage * img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.describeImg]]];
//    CGSize ss=img.size;
//    self.imageV.x = 0;
//    self.imageV.y = CGRectGetMaxY(line.frame);
//    self.imageV.frame = (CGRect){{0,CGRectGetMaxY(line.frame)},EPScreenW-16,ss.height};
//    [viewBg2 addSubview:self.imageV];
    viewBg2.height = CGRectGetMaxY(imageBtn.frame);
    viewHeight = CGRectGetMaxY(viewBg2.frame)+7;
    
    [bgScroller addSubview:viewBg2];
    bgScroller.contentSize = CGSizeMake(EPScreenW, viewHeight);

   }


-(void)selectedImg:(UIButton *)sender{
    UIButton *imageBtn = (UIButton *)[self.view viewWithTag:3333];

    switch (sender.tag) {
        case 35:
        {
            sender.selected = YES;
            UIButton *otherBtn = (UIButton *)[self.view viewWithTag:36];
            otherBtn.selected = NO;
            imageBtn.selected = NO;
        }
            break;
        case 36:
        {
            sender.selected = YES;
            UIButton *otherBtn = (UIButton *)[self.view viewWithTag:35];
            otherBtn.selected = NO;
            imageBtn.selected = YES;
            
        }
            break;
            
        default:
            break;
    }
}

//底部认购按钮
-(void)creatBtn:(NSString *)str
{
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(0, EPScreenH-58, WIDTH(145.0, 360), 58)];
    price.textColor = [UIColor whiteColor];
    price.text = [NSString stringWithFormat:@"认购金￥%@",_model.currentPrice];
    price.font = [UIFont systemFontOfSize:18];
    price.textAlignment = NSTextAlignmentCenter;
    price.backgroundColor  = RGBColor(29, 32, 40);
    [self.view addSubview:price];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMaxX(price.frame), EPScreenH-58, WIDTH(215.0, 360), 58);
    if ([str isEqualToString:@"已结束"]) {
        btn.userInteractionEnabled = NO;
    }
    [btn setBackgroundColor:RGBColor(255, 67, 67)];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:24];
    [btn addTarget:self action:@selector(addAlterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attri  =[NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize =CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}

-(void)addAlterView{
    
    UIButton *viewBg = [UIButton buttonWithType:UIButtonTypeCustom];
    viewBg.frame = self.view.frame;
    viewBg.y = EPScreenH;
    viewBg.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
    self.viewBg = viewBg;
    [viewBg addTarget:self action:@selector(dismissBg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewBg];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, EPScreenH-263, EPScreenW, 263)];
    bottomView.backgroundColor = RGBColor(255, 255, 255);
    [viewBg addSubview:bottomView];
    
    UILabel *title = [[UILabel alloc]init];
    title.font = [UIFont systemFontOfSize:16];
    title.y = 10;
    title.size = [self sizeWithText:@"认购报名" font:[UIFont systemFontOfSize:16]];
    title.centerX = EPScreenW/2;
    title.text = @"认购报名";
    [bottomView addSubview:title];
    
    UILabel *renGou = [[UILabel alloc]init];
    renGou.font = [UIFont systemFontOfSize:18];
    renGou.size = [self sizeWithText:@"认购金" font:[UIFont systemFontOfSize:18]];
    renGou.text = @"认购金";
    renGou.x = 8;
    renGou.y = CGRectGetMaxY(title.frame)+14;
    [bottomView addSubview:renGou];
    UILabel *price = [[UILabel alloc]init];
    price.font = [UIFont boldSystemFontOfSize:18];
    price.frame = (CGRect){{CGRectGetMaxX(renGou.frame)+5,renGou.y},[self sizeWithText:[NSString stringWithFormat:@"%@元",_model.currentPrice] font:[UIFont boldSystemFontOfSize:18]]};
    price.text = [NSString stringWithFormat:@"%@元",_model.currentPrice];
    price.textColor = RGBColor(255, 67, 67);
    [bottomView addSubview:price];
    
    UILabel *prompt = [[UILabel alloc]init];
    prompt.size = [self sizeWithText:@"如果认购不成功认购金将会在本期活动结束后退还回支付宝,请放心认购" font:[UIFont systemFontOfSize:12] maxW:EPScreenW-16];
    prompt.numberOfLines = 0;
    prompt.x = 8;
    prompt.y = CGRectGetMaxY(renGou.frame)+13;
    prompt.font = [UIFont systemFontOfSize:12];
    prompt.textColor = RGBColor(61, 61, 61);
    prompt.text = @"如果认购不成功认购金将会在本期活动结束后退还回支付宝,请放心认购";
    [bottomView addSubview:prompt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(prompt.frame)+10, EPScreenW-8, 0.5)];
    line.backgroundColor = RGBColor(216, 216, 216);
    [bottomView addSubview:line];
    
    UIButton *selecd = [UIButton buttonWithType:UIButtonTypeCustom];
    [selecd setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    selecd.x = 8;
    selecd.y = CGRectGetMaxY(line.frame)+16;
    selecd.size = CGSizeMake(15, 15);
    [bottomView addSubview:selecd];
    
    UILabel *selecdT = [[UILabel alloc]init];
    selecdT.size = [self sizeWithText:@"您已阅读并同意易品半价购认购协议" font:[UIFont systemFontOfSize:12]];
    selecdT.x = CGRectGetMaxX(selecd.frame)+5;
    selecdT.y = selecd.y;
    selecdT.font = [UIFont systemFontOfSize:12];
    selecdT.text =@"您已阅读并同意易品半价购认购协议";
    selecdT.textColor = RGBColor(61, 61, 61);
    [bottomView addSubview:selecdT];
    
    UIButton *look = [UIButton buttonWithType:UIButtonTypeCustom];
    [look setTitle:@"查看协议" forState:UIControlStateNormal];
    look.x = CGRectGetMaxX(selecdT.frame)+5;
    look.y = selecdT.y;
    look.size = [self sizeWithText:@"查看协议" font:[UIFont systemFontOfSize:12]];
    [look addTarget:self action:@selector(clickLook:) forControlEvents:UIControlEventTouchUpInside];
    look.titleLabel.font = [UIFont systemFontOfSize:12];
    [look setTitleColor:RGBColor(0, 132, 255) forState:UIControlStateNormal];
    [bottomView addSubview:look];
    
    UIButton *goRen = [UIButton buttonWithType:UIButtonTypeCustom];
    [goRen setBackgroundColor:RGBColor(255, 67, 67)];
    goRen.frame = (CGRect){{0,CGRectGetMaxY(selecd.frame)+16},EPScreenW,50};
    [goRen setTitle:@"去认购" forState:UIControlStateNormal];
    goRen.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [goRen setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
    [bottomView addSubview:goRen];
    [goRen addTarget:self action:@selector(clickPayBg:) forControlEvents:UIControlEventTouchUpInside];
    bottomView.height = CGRectGetMaxY(goRen.frame);
    bottomView.y = EPScreenH-bottomView.height;
    [UIView animateWithDuration:.3 animations:^{
        viewBg.y = 0;
        
    } completion:^(BOOL finished) {
        viewBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        
    }];
    
    
    
}
-(void)clickLook:(UIButton *)sender{
    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"测试信息请勿认购" count:0 doWhat:^{
        
    }];
    
    
}
-(void)dismissBg:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
    
    [UIView animateWithDuration:.3 animations:^{
        sender.y = EPScreenH;
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
    }];
}

/**分享*/
- (void)clickShare:(UIButton *)sender{
    /**
     *  自定义分享界面
     */
    [JDGoodsTools shareUMInVc:self];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            [EPTool addAlertViewInView:self title:@"提示信息" message:@"发送取消" count:0 doWhat:nil];
            break;
        case MessageComposeResultFailed:// send failed
            [EPTool addAlertViewInView:self title:@"提示信息" message:@"发送失败" count:0 doWhat:nil];
            break;
        case MessageComposeResultSent:
            [EPTool addAlertViewInView:self title:@"提示信息" message:@"发送成功" count:0 doWhat:nil];
            break;
        default:
            break;
    }
}

-(void)clickPayBg:(UIButton *)sender{

    if (LOGINTIME) {
        EPData * data = [EPData new];
        if ([_model.subscribe intValue] == 0) {
            [data getAuctionDataWithType:@"4" withGoodsId:nil withOrderId:_model.orderId Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                if ([returnCode intValue]==0) {
                    NSString *sign = dic[@"sign"];
                    [self PayTreasure:sign orderNo:_model.orderId body:@"0" Price:_model.currentPrice];
                    return ;
                }
            }];
        }else if ([_model.subscribe intValue] == 1){
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您已参与过此活动" count:0 doWhat:nil];
            [self dismissBg:self.viewBg];

            return;
        }
        orderId = [data getUniqueStrByUUID];
        [data getAuctionDataWithType:@"2" withGoodsId:self.goodsId withOrderId:orderId Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            if ([returnCode intValue]== 0) {
                NSLog(@"半价购提交订单%@",dic);
                [data getAuctionDataWithType:@"4" withGoodsId:nil withOrderId:orderId Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                    if ([returnCode intValue]==0) {
                        NSString *sign = dic[@"sign"];
                        [self PayTreasure:sign orderNo:_model.orderId body:@"0" Price:_model.currentPrice];
                        
                    }
                }];
            }
            //                else{
            //                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            //                }
            
        }];
        
    }else{
        EPLoginViewController * vc=[[EPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
        [self dismissBg:self.viewBg];
}

-(void)PayTreasure:(NSString *)sign orderNo:(NSString *)orderNo body:(NSString *)body Price:(NSString *)payPrice {
    
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList objectAtIndex:1];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088221986373276";
    NSString *seller = @"developer@jeader.com";
    
    //partner和seller获取失败,提示
    //    if ([partner length] == 0 ||
    //        [seller length] == 0 ||
    //        [privateKey length] == 0)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
    //                                                        message:@"缺少partner或者seller或者私钥。"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"确定"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = orderNo; //订单ID（由商家自行制定）
    order.subject = @"半价购支付";//product.subject; //商品标题
    order.body = body;//product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",[payPrice floatValue]]; //商品价格
    order.notifyURL =[NSString stringWithFormat:@"%@/successAlipayPay.json",EPUrl];//回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"60m";
    order.returnURL = @"m.alipay.com";
    order.showURL = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    
    
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = sign;//[signer signString:orderSpec];
    NSLog(@"signedString===%@",signedString);
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"orderString===%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *result =resultDic[@"resultStatus"];
            if ([result intValue]==9000) {
                NSLog(@"支付宝交易成功");
                
                
            }else if ([result intValue]==6001){
                //用户取消
                NSLog(@"用户主动取消支付");
            }else{
                NSLog(@"支付失败");
            }
        }];
    }
}


@end
