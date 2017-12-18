//
//  EPGuideViewController.m
//  EPin-IOS
//
//  Created by jeaderQ on 16/5/4.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPGuideViewController.h"
#import "SDCycleScrollView.h"
#import "HeaderFile.h"
@interface EPGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, strong) UIPageControl *pageControl;


@end

@implementation EPGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *images = @[@"购物引导",@"违章引导",@"电召引导",@"失物招领引导"];
    [self showGuideViewWithImages:images];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)showGuideViewWithImages:(NSArray *)images {
    
    UIScrollView *bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, EPScreenW, EPScreenH)];
    _bgScroll = bgScroll;
    bgScroll.contentSize = CGSizeMake(EPScreenW*images.count, 0);
    _bgScroll.pagingEnabled = YES;
    //    _bgScroll.showsVerticalScrollIndicator = NO;
    //    _bgScroll.showsHorizontalScrollIndicator = NO;
    _bgScroll.delegate = self;
    _bgScroll.bounces = NO;
    [self.view addSubview:bgScroll];
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.centerX = EPScreenW/2;
    pageControl.y =EPScreenH-50;
    
    [self.view addSubview:pageControl];
    _pageControl = pageControl;
    pageControl.backgroundColor = [UIColor blackColor];
    
    NSArray *textL = @[@"乐享消费文字",@"违章处理文字",@"预约召车文字",@"失物招领文字"];
    NSArray *textR = @[@"乐享消费小字",@"违章处理小字",@"预约召车小字",@"失物招领小字"];
    //设置pageControl的总页码
    pageControl.numberOfPages = textL.count;
    //设置当前页码
//    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    [pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
//    //页码指示的着色
//    pageControl.pageIndicatorTintColor = [UIColor redColor];
//    
//    //当前页码的着色
//    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    

    for (int i = 0; i<images.count; i++) {
        UIImageView *guide = [[UIImageView alloc]initWithFrame:CGRectMake(EPScreenW * i, 0, EPScreenW, EPScreenH)];
        guide.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",images[i]]];
        UIImageView *leftL = [[UIImageView alloc]init];
        leftL.width = WIDTH(37.0, 375);
        leftL.x = EPScreenW/2 -leftL.width-WIDTH(10.0, 375);
        leftL.y = HEIGHT(117.0, 667);
        leftL.height = HEIGHT(159.0, 667);
        leftL.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",textL[i]]];
        leftL.tag = i+15;
        leftL.alpha = 0;
        UIImageView *rightL = [[UIImageView alloc]init];
        rightL.width = WIDTH(23.0, 375);
        rightL.x = EPScreenW/2 +WIDTH(10.0, 375);
        rightL.height = HEIGHT(242.0, 667);
        rightL.y = EPScreenH-HEIGHT(100.0, 667)-rightL.height;
        rightL.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",textR[i]]];
        rightL.tag = i+25;
        rightL.alpha = 0;
        if (i==0) {
            [UIView animateWithDuration:1.2 animations:^{
                leftL.y = HEIGHT(150.0, 667);
                leftL.alpha = 1.0;
                rightL.y = EPScreenH-HEIGHT(190.0, 667)-rightL.height;
                rightL.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }
        [_bgScroll addSubview:guide];
        [guide addSubview:rightL];
        [guide addSubview:leftL];
        if (i==3) {
            UIButton *tiyan = [UIButton buttonWithType:UIButtonTypeCustom];
            [tiyan setImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateNormal];
            [tiyan setFrame:CGRectMake((EPScreenW-WIDTH(182.0, 375))/2, EPScreenH-tiyan.height-HEIGHT(110.0, 667), WIDTH(182.0, 375), HEIGHT(42.0, 667))];
            [tiyan addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
            guide.userInteractionEnabled = YES;
            [guide addSubview:tiyan];
        }
    }

}

-(void)pageControlClick:(UIPageControl *)pageControl
{

}

-(void)goToMain{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goMain" object:nil];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    UIImageView *leftL1 = [self.view viewWithTag:15];
    UIImageView *leftL2 = [self.view viewWithTag:16];
    UIImageView *leftL3 = [self.view viewWithTag:17];
    UIImageView *leftL4 = [self.view viewWithTag:18];
    UIImageView *rightL1 = [self.view viewWithTag:25];
    UIImageView *rightL2 = [self.view viewWithTag:26];
    UIImageView *rightL3 = [self.view viewWithTag:27];
    UIImageView *rightL4 = [self.view viewWithTag:28];
    if (offsetX > EPScreenW *2) {
        self.pageControl.hidden = YES;
    }

    if (offsetX ==0||offsetX<EPScreenW) {
        self.pageControl.hidden = NO;
        self.pageControl.currentPage =0;
        [UIView animateWithDuration:1.2 animations:^{
            leftL1.y = HEIGHT(150.0, 667);
            leftL1.alpha = 1.0;
            rightL1.y = EPScreenH-HEIGHT(190.0, 667)-rightL1.height;
            rightL1.alpha = 1.0;
            leftL2.y = HEIGHT(117.0, 667);
            leftL2.alpha = 0;
            rightL2.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL2.alpha = 0;
            leftL3.y = HEIGHT(117.0, 667);
            leftL3.alpha = 0;
            rightL3.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL3.alpha = 0;
            leftL4.y = HEIGHT(117.0, 667);
            leftL4.alpha = 0;
            rightL4.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL4.alpha = 0;

        } completion:^(BOOL finished) {}];
    }else if (offsetX ==EPScreenW){
        self.pageControl.hidden = NO;
        self.pageControl.currentPage =1;
        [UIView animateWithDuration:1.2 animations:^{
            leftL2.y = HEIGHT(150.0, 667);
            leftL2.alpha = 1.0;
            rightL2.y = EPScreenH-HEIGHT(190.0, 667)-rightL2.height;
            rightL2.alpha = 1.0;
            leftL1.y = HEIGHT(117.0, 667);
            leftL1.alpha = 0;
            rightL1.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL1.alpha = 0;
            leftL3.y = HEIGHT(117.0, 667);
            leftL3.alpha = 0;
            rightL3.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL3.alpha = 0;
            leftL4.y = HEIGHT(117.0, 667);
            leftL4.alpha = 0;
            rightL4.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL4.alpha = 0;
            

        } completion:^(BOOL finished) {
                    }];
    }else if (offsetX == EPScreenW *2){
          self.pageControl.currentPage =2;
         self.pageControl.hidden = NO;
        [UIView animateWithDuration:1.2 animations:^{
            leftL3.y = HEIGHT(150.0, 667);
            leftL3.alpha = 1.0;
            rightL3.y = EPScreenH-HEIGHT(190.0, 667)-rightL3.height;
            rightL3.alpha = 1.0;
            leftL2.y = HEIGHT(117.0, 667);
            leftL2.alpha = 0;
            rightL2.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL2.alpha = 0;
            leftL1.y = HEIGHT(117.0, 667);
            leftL1.alpha = 0;
            rightL1.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL1.alpha = 0;
            leftL4.y = HEIGHT(117.0, 667);
            leftL4.alpha = 0;
            rightL4.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL4.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }else if (offsetX == EPScreenW *3){
        [UIView animateWithDuration:1.2 animations:^{
            leftL4.y = HEIGHT(150.0, 667);
            leftL4.alpha = 1.0;
            rightL4.y = EPScreenH-HEIGHT(190.0, 667)-rightL4.height;
            rightL4.alpha = 1.0;
            leftL2.y = HEIGHT(117.0, 667);
            leftL2.alpha = 0;
            rightL2.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL2.alpha = 0;
            leftL3.y = HEIGHT(117.0, 667);
            leftL3.alpha = 0;
            rightL3.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL3.alpha = 0;
            leftL1.y = HEIGHT(117.0, 667);
            leftL1.alpha = 0;
            rightL1.y = EPScreenH-HEIGHT(100.0, 667)-rightL1.height;
            rightL1.alpha = 0;
        } completion:^(BOOL finished) {
        }];
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
