//
//  EPFinancialController.m
//  EPin-IOS
//  金融理财
//  Created by jeaderQ on 16/4/6.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPFinancialController.h"
#import "HeaderFile.h"
#import "SDCycleScrollView.h"
#import "EPFinanController.h"
@interface EPFinancialController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bgScroll;


@property (nonatomic, strong) UIView *moveLine;
/**
 *  新手
 */
@property (strong, nonatomic)  UIButton *frashBtn;
/**
 *  收益
 */
@property (strong, nonatomic)  UIButton *highBtn;
/**
 *  回本
 */
@property (strong, nonatomic)  UIButton *fastBtn;

@end

@implementation EPFinancialController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"金融理财"];
    [self prepareForScrollVi];
    
}
- (void)prepareForScrollVi
{
    NSArray * imgName =[[NSArray alloc]initWithObjects:@"黄",@"红",@"橙", nil];
    SDCycleScrollView *Cycle =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, EPScreenW, HEIGHT(150.0, 667)) shouldInfiniteLoop:YES imageNamesGroup:imgName];
    Cycle.showPageControl=YES;
    Cycle.autoScrollTimeInterval=4;
    [self.view addSubview:Cycle];
    
    self.frashBtn = [self creatBtnWithFrame:CGRectMake(0, Cycle.y +Cycle.height, EPScreenW/3, 39) tag:15 title:@"新手专享"];
    [self.frashBtn setTitleColor:RGBColor(29, 32, 40) forState:UIControlStateNormal];
    self.highBtn= [self creatBtnWithFrame:CGRectMake(WIDTH(125.0, 375),Cycle.y +Cycle.height, WIDTH(124.0, 375), 39.0) tag:16 title:@"收益最高"];
    self.fastBtn =[self creatBtnWithFrame:CGRectMake(WIDTH(251.0, 375), Cycle.y +Cycle.height, WIDTH(124.0, 375), 39.0) tag:17 title:@"回本最快"];
    [self creatLineWithFrame:CGRectMake(WIDTH(124.0, 375), self.frashBtn.y+3, WIDTH(1.0, 375), HEIGHT(34.0, 667))];
    [self creatLineWithFrame:CGRectMake(WIDTH(250.0, 375),self.frashBtn.y+3, WIDTH(1.0, 375), HEIGHT(34.0, 667))];
    [self creatLineWithFrame:CGRectMake(0, self.frashBtn.y +self.frashBtn.height-3, EPScreenW, HEIGHT(1.0, 667))];
    
    UIView *move = [[UIView alloc]initWithFrame:CGRectMake(0, self.frashBtn.y+self.frashBtn.height-5, WIDTH(124.0, 375), 3)];
    move.backgroundColor = RGBColor(29, 32, 40);
    move.tag = 250;
    [self.view addSubview:move];

    /**
     滑动的背景View
     */
    _bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,move.y+3, EPScreenW, EPScreenH-move.y+3)];
    
    _bgScroll.contentSize = CGSizeMake(EPScreenW*3, 0);
    _bgScroll.pagingEnabled = YES;
    //    _bgScroll.showsVerticalScrollIndicator = NO;
    //    _bgScroll.showsHorizontalScrollIndicator = NO;
    _bgScroll.delegate = self;
    _bgScroll.bounces = NO;
    [self.view addSubview:_bgScroll];
    /**
    新手页面的背景View
    */
    UIView * cardHoder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, _bgScroll.height)];
    cardHoder.backgroundColor = RGBColor(255, 255, 255);
    [self.bgScroll addSubview:cardHoder];
    UIImageView *cardView = [self creatBgholderImageWithImageName:@"新人专享"  BgView:cardHoder];
    UIButton *touzi = [self bingBtnWithView:cardView BgView:cardHoder title:@"立即投资"];
    touzi.y = cardView.height-80;
    /**
        页面的背景View
    */
    UIView *card2 = [[UIView alloc]initWithFrame:CGRectMake(EPScreenW, 0, EPScreenW, _bgScroll.height)];
    card2.backgroundColor =RGBColor(237, 237, 237);
    [self.bgScroll addSubview:card2];
    EPFinanController *table = [[EPFinanController alloc]init];
    table.view.frame = CGRectMake(0, 0, EPScreenW, _bgScroll.height);
    [card2 addSubview:table.view];
    [self addChildViewController:table];
    
}

/**
 *   按钮
 */
-(UIButton *)creatBtnWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title{
    
    UIButton *card = [UIButton buttonWithType:UIButtonTypeCustom];
    [card setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
    [card setFrame:frame];
    [card setTitle:title forState:UIControlStateNormal];
    card.tag = tag;
    [card addTarget:self action:@selector(cardClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:card];
    return card;
}
/**
 *  黑线
 */
-(void)creatLineWithFrame:(CGRect)frame{
    UIView * line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = RGBColor(216, 216, 216);
    [self.view addSubview:line];
}
/**
 *  背景图
 *
 *  @param imageName 图片名称
 *
 *  @return 背景View
 */
-(UIImageView *)creatBgholderImageWithImageName:(NSString *)imageName BgView:(UIView *)BgView{
    
    UIImage *cardImage = [UIImage imageNamed:imageName];
    UIImageView *cardView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(375.0, 375), HEIGHT(375.0, 667))];
    cardView.image = cardImage;
    cardView.centerX  = EPScreenW/2;
    cardView.y = 0;
    [BgView addSubview:cardView];
    return cardView;
}
/**
 *  提示label
 */
-(UILabel *)creatCardLabelWithView:(UIView *)cardView BgView:(UIView *)BgView text:(NSString *)text{
    UILabel * prompt= [[UILabel alloc]initWithFrame:CGRectMake(cardView.x, cardView.y +cardView.height +HEIGHT(10.0, 667), cardView.width, HEIGHT(15.0, 667))];
    prompt.text = text;
    prompt.textColor = RGBColor(174, 174, 174);
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.font = [UIFont systemFontOfSize:12];
    [BgView addSubview:prompt];
    return prompt;
}
/**
 *  Btn
 */
-(UIButton *)bingBtnWithView:(UIView *)prompt BgView:(UIView *)BgView title:(NSString *)title
{
    UIButton * bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bindingBtn.width = EPScreenW -WIDTH(100.0, 375);
    bindingBtn.height = HEIGHT(40.0, 667);
    bindingBtn.x = WIDTH(50.0, 375);
    bindingBtn.y = prompt.y + prompt.height+HEIGHT(15.0, 667);
    [bindingBtn.layer setBorderColor:[RGBColor(199, 64, 55) CGColor]];
    [bindingBtn.layer setBorderWidth:1];
    bindingBtn.layer.cornerRadius = 5;
    [bindingBtn setTitle:title forState:UIControlStateNormal];
    [bindingBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    bindingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [BgView addSubview:bindingBtn];
    return bindingBtn;
}


- (void)cardClick:(UIButton *)sender {
    switch (sender.tag) {
        case 15:
        {
            [UIView animateWithDuration:.3 animations:^{
                self.bgScroll.contentOffset = CGPointMake(0, 0);
            } completion:nil];
        }
            break;
        case 16:
        {
            [UIView animateWithDuration:.3 animations:^{
                
                self.bgScroll.contentOffset = CGPointMake(EPScreenW, 0);
                NSLog(@"%f",  self.bgScroll.contentOffset.x);
            } completion:nil];
        }
            break;
        case 17:
        {
            [UIView animateWithDuration:.3 animations:^{
                self.bgScroll.contentOffset = CGPointMake(EPScreenW *2, 0);
            } completion:nil];
        }
            break;
        default:
            break;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    UIView *Line = [self.view viewWithTag:250];
    if (!offsetY) {
         Line.x = offsetX/3;
        if (offsetX == 0) {
            [self.frashBtn setTitleColor:RGBColor(29, 32, 40) forState:UIControlStateNormal];
            [self.highBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
            [self.fastBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        }else if (offsetX ==EPScreenW){
            [self.highBtn setTitleColor:RGBColor(29, 32, 40) forState:UIControlStateNormal];
            [self.frashBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
            [self.fastBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        }else if (offsetX ==EPScreenW *2){
            [self.fastBtn setTitleColor:RGBColor(29, 32, 40) forState:UIControlStateNormal];
            [self.frashBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
            [self.highBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        }

    }
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
