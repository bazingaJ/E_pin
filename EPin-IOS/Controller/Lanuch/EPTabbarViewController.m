//
//
//  Created by jeaderQ on 16/3/21.
//  Copyright © 2016年 jeaderQ. All rights reserved.
//

#import "EPTabbarViewController.h"
#import "EPDefineLayer.h"
#import "HeaderFile.h"
#import "EPMainController.h"
#import "EPMyViewController.h"
#import "EPSpendViewController.h"
#import "EPTabBar.h"
#import "EPEPaiViewController.h"

@interface EPTabbarViewController ()<UIGestureRecognizerDelegate>

@end

@implementation EPTabbarViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"goMain" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test1) name:@"goHuaJF" object:nil];

    
}
-(void)test{
     self.selectedIndex = 0;
}
-(void)test1{
    self.selectedIndex = 2;
    UIButton * seach  =(UIButton *)[self.view viewWithTag:101];
    UIButton * market =(UIButton *)[self.view viewWithTag:102];
    UIButton * mainBtn =(UIButton *)[self.view viewWithTag:100];
    mainBtn.selected=NO;
    seach.selected = NO;
    market.selected = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   //    self.hidesBottomBarWhenPushed = YES;
//    [self setTabBar];
    [self bindViewController];
     EPTabBar *tabBar = [[EPTabBar alloc] initWithFrame:CGRectMake(0, EPScreenH-50, EPScreenW, 50)];
    [self.view addSubview:tabBar];
//    self.navigationController.navigationBarHidden = YES;
    for (UIButton *btn in tabBar.btnArr)
    {
        [btn addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
//    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (self.childViewControllers.count == 0) {
        // 根控制器下,不允许接受手势
        return NO;
    }
    return YES;
}
-(void)bindViewController
{
    EPMainController *firstVc = [[EPMainController alloc] init];

    EPEPaiViewController * secondVc =[[EPEPaiViewController alloc] init];
    
    EPSpendViewController *thirdVC = [[EPSpendViewController alloc] init];
    
    EPMyViewController *fourthVC = [[EPMyViewController alloc] init];
   

    NSArray *viewControllers = [NSArray arrayWithObjects:firstVc,secondVc,thirdVC, fourthVC, nil];
    self.viewControllers = viewControllers;
}

-(void)changeViewController:(UIButton *)sender
{
    if (sender.selected ==YES) {
        return;
    }
    UIButton * home   =(UIButton *)[self.view viewWithTag:100];
    UIButton * seach  =(UIButton *)[self.view viewWithTag:101];
    UIButton * market =(UIButton *)[self.view viewWithTag:102];
    UIButton * person =(UIButton *)[self.view viewWithTag:103];
    switch (sender.tag) {
        case 100:
        {
            [self tabBarAnima:sender];
            seach.selected = NO;
            market.selected = NO;
            person.selected = NO;
        }
            break;
        case 101:
        {
            [self tabBarAnima:sender];
            
            home.selected = NO;
            market.selected = NO;
            person.selected = NO;


        }
            break;
        case 102:
        {
            [self tabBarAnima:sender];
            seach.selected = NO;
            home.selected = NO;
            person.selected = NO;
        }
             break;
        case 103:
        {
            [self tabBarAnima:sender];
            seach.selected = NO;
            market.selected = NO;
            home.selected = NO;
        }
            break;

        default:
            break;
    }
}
-(void)tabBarAnima:(UIButton *)sender
{
    self.selectedIndex = sender.tag - 100;
  
    NSArray * barText = @[@"首页文字",@"找积分文字",@"花积分文字",@"我的文字"];
    
    UIImage *image = [UIImage imageNamed:barText[sender.tag-100]];
    CGSize imageS = [image size];
    
    UIImageView *textImage = [[UIImageView alloc]init];
    textImage.frame = CGRectMake(0, 0,imageS.width/10, imageS.height/10);
    textImage.center = CGPointMake(EPScreenW/8, 48/2);

    textImage.hidden = YES;

    textImage.image = image;
    [sender addSubview:textImage];
    
    [UIView animateWithDuration:.2 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.01, 0.01);
        sender.selected = YES;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 animations:^{
            
            textImage.hidden = NO;
            textImage.transform = CGAffineTransformMakeScale(1000, 1000);
            //通过Btn的tag值来切换视图控制器
        
        } completion:^(BOOL finished) {
            [NSThread sleepForTimeInterval:.3];
            [UIView animateWithDuration:.2 animations:^{
                textImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                textImage.hidden = YES;
                [UIView animateWithDuration:.2 animations:^{
                    sender.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
            }];
        }];
    }];

}

@end
