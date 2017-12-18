//
//  EPAroundController.m
//  55555
//
//  Created by jeaderQ on 16/4/1.
//  Copyright © 2016年 jeaderQ. All rights reserved.
//

#import "EPAroundController.h"
#import "HeaderFile.h"


@interface EPAroundController ()
@property (nonatomic, strong) UIImageView *aroundCenter;
@property (nonatomic, strong) UIImageView *around;
@property (nonatomic, strong) UIImageView *aroundGuang;

@end

@implementation EPAroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, EPScreenH)];
    bgView.backgroundColor = RGBColor(255, 64, 67);

    UIImageView *image = [[UIImageView alloc]initWithFrame:bgView.frame];
    image.image = [UIImage imageNamed:@"背景"];
    [bgView addSubview:image];
    [self.view addSubview:bgView];
    UIScrollView *scroBG = [[UIScrollView alloc]initWithFrame:bgView.frame];
    [bgView addSubview:scroBG];
    scroBG.contentSize = CGSizeMake(EPScreenW, EPScreenH+30);

    UIButton *goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBack setTitle:@"返回" forState:UIControlStateNormal];
    [goBack setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
    [goBack setFrame:CGRectMake(-20, HEIGHT(20.0, 667), 100,60)];
    [goBack addTarget:self action:@selector(GobackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBack];
    
    UIImageView *luckyDraw = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"幸运大抽奖"]];
    luckyDraw.width= WIDTH(188.0, 375);
    luckyDraw.height = HEIGHT(40.0, 667);
    luckyDraw.centerX = EPScreenW/2;
    luckyDraw.y = HEIGHT(63.0, 667);
    [scroBG addSubview:luckyDraw];

    //添加转盘
    UIImageView *aroundGuang = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"转盘外围"]];
  
    aroundGuang.y = luckyDraw.y +luckyDraw.height +HEIGHT(23.5, 667);
    aroundGuang.centerX = EPScreenW/2;
    [scroBG addSubview:aroundGuang];
    
    UIImageView *around = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"转盘内容"]];
 
    around.center = aroundGuang.center;
    [scroBG addSubview:around];
    self.around = around;
    //添加转针
    UIImageView *aroundCenter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"转盘中心"]];
  
    aroundCenter.centerX = around.centerX;
    aroundCenter.centerY = around.centerY -10;
    [scroBG addSubview:aroundCenter];
    //开始抽奖
    UIButton *aroundRun = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aroundRun.frame = aroundCenter.frame;
    [aroundRun addTarget:self action:@selector(choujiang:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aroundRun];

    UIImageView *numAround = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"您还有1次抽奖机会"]];
    numAround.width= WIDTH(222.0, 375);
    numAround.height = HEIGHT(26.0, 667);
    numAround.y = aroundGuang.y +aroundGuang.height +HEIGHT(10.0, 667);
    numAround.centerX = EPScreenW/2;
    [scroBG addSubview:numAround];
    
    UIImageView *aroundRules = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"抽奖规则"]];
    aroundRules.width= WIDTH(93.0, 375);
    aroundRules.height = HEIGHT(26.0, 667);
    aroundRules.y = numAround.y +numAround.height +HEIGHT(10.0, 667);
    aroundRules.centerX = EPScreenW/2;
    [scroBG addSubview:aroundRules];
    
    UILabel *rulesLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(50.0, 375), aroundRules.y +aroundRules.height , EPScreenW -WIDTH(50.0, 375)*2, HEIGHT(80.0, 667))];
    rulesLabel.font = [UIFont systemFontOfSize:WIDTH(15.0, 375)];
    rulesLabel.numberOfLines = 0;
    rulesLabel.text = @"抽到奖品之后，请将有关信息告知于我们；\n最终解释权归本公司所有";
    rulesLabel.textColor = [UIColor whiteColor];
    [scroBG addSubview:rulesLabel];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)isVisible{
    return (self.isViewLoaded && self.view.window);
}
-(void)GobackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)choujiang:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    CABasicAnimation* animation = [[CABasicAnimation alloc] init];
    float nunX = arc4random() % 12;
    
    animation.keyPath = @"transform.rotation";
    animation.toValue = @(2 * M_PI * 4 - M_PI * 2 / 12 * (nunX+0.5));
    animation.duration = 3;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.around.layer addAnimation:animation forKey:@"yamiedie"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.around.transform = CGAffineTransformMakeRotation([animation.toValue floatValue]);
        
        [self.around.layer removeAnimationForKey:@"yamiedie"];
        if ([self isVisible]==0) {
            return ;
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"恭喜您中奖!!!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(snowDown) userInfo:nil repeats:YES];
        sender.userInteractionEnabled = YES;

    });

    //******************旋转动画******************
    //产生随机角度
//    self.view.userInteractionEnabled = NO;
////    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
//    random = (rand() % 20) / 10.0;
//     //设置动画
//    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    [spin setFromValue:[NSNumber numberWithFloat:M_PI * (0.0+orign)]];
//    
//    [spin setToValue:[NSNumber numberWithFloat:M_PI * (10.0+random+orign)]];
//    [spin setDuration:2.5];
//    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
//    //速度控制器
//    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    //添加动画
//    [[self.around layer] addAnimation:spin forKey:nil];
//    //锁定结束位置
//    self.around.transform = CGAffineTransformMakeRotation(M_PI * (10.0+random+orign));
//    NSLog(@"%f",10.0+random+orign);
//    //锁定fromValue的位置
//    orign = 10.0+random+orign;
//    orign = fmodf(orign, 2.0);
}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    //判断抽奖结果
//    if (orign >= 0.0 && orign < (0.5/3.0)) {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 100元现金！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//      
//    }
//    else if (orign >= (0.5/3.0) && orign < ((0.5/3.0)*2))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"谢谢您的参与！" message:@"不要灰心下次一定中奖！ " delegate:self cancelButtonTitle:@"继续努力！" otherButtonTitles: nil];
//        [result show];
//      
//    }else if (orign >= ((0.5/3.0)*2) && orign < ((0.5/3.0)*3))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 100元现金！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//  
//    }else if (orign >= (0.0+0.5) && orign < ((0.5/3.0)+0.5))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 冰箱一台！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//
//    }else if (orign >= ((0.5/3.0)+0.5) && orign < (((0.5/3.0)*2)+0.5))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 100元现金！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//
//    }else if (orign >= (((0.5/3.0)*2)+0.5) && orign < (((0.5/3.0)*3)+0.5))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"谢谢您的参与！" message:@"祝您下次中奖 " delegate:self cancelButtonTitle:@"继续努力！" otherButtonTitles: nil];
//        [result show];
//
//    }else if (orign >= (0.0+1.0) && orign < ((0.5/3.0)+1.0))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 100元现金！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//   
//    }else if (orign >= ((0.5/3.0)+1.0) && orign < (((0.5/3.0)*2)+1.0))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 平板电脑一台！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//    
//    }else if (orign >= (((0.5/3.0)*2)+1.0) && orign < (((0.5/3.0)*3)+1.0))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 100元现金！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//
//    }else if (orign >= (0.0+1.5) && orign < ((0.5/3.0)+1.5))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 100元现金！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//  
//    }else if (orign >= ((0.5/3.0)+1.5) && orign < (((0.5/3.0)*2)+1.5))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 洗衣机一台！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
// 
//    }else if (orign >= (((0.5/3.0)*2)+1.5) && orign < (((0.5/3.0)*3)+1.5))
//    {
//        UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"恭喜中奖！" message:@"您中了 智能手机一部！ " delegate:self cancelButtonTitle:@"领奖去！" otherButtonTitles: nil];
//        [result show];
//    }
//    _timer =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(snowDown) userInfo:nil repeats:YES];
//  
//}
-(void)snowDown
{
    int beginX = arc4random()%(375 + 1);
    
    int endX =arc4random()%(375 + 1);
    
   
    static int i = 0;
    NSString *imageName = [NSString stringWithFormat:@"彩纸屑%d",i];
    UIImageView * snowView = [self creatViewWith:beginX Y:-10 imageName:imageName];
    if (i == 21) {
        [_timer invalidate];
        i = 0;
    }else{
        i++;
    }
   
    
    [UIView beginAnimations:nil context:(__bridge void *)(snowView)];
    
    [UIView setAnimationDuration:2];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    snowView.frame = CGRectMake(endX, HEIGHT(667.0 , 667), 12, 14);
    
    [UIView commitAnimations];
    self.view.userInteractionEnabled = YES;
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView * image = (__bridge UIImageView *)context;
    [image removeFromSuperview];
}
-(UIImageView *)creatViewWith:(CGFloat)x Y:(CGFloat)y imageName:(NSString *)imageName
{
    UIImageView * snowView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 12, 14)];
    snowView.image = [UIImage imageNamed:imageName];
    // CGRectMake(beginX, 64, weidth, weidth)];
      [self.view addSubview:snowView];
    return snowView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
