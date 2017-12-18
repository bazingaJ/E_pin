//
//  EPPhotoAndMessDetailVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/8/10.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPhotoAndMessDetailVC.h"
#import "HeaderFile.h"
@interface EPPhotoAndMessDetailVC ()<UIScrollViewDelegate>

@end

@implementation EPPhotoAndMessDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:@"图文详情"];
    [self creatImageView];
    self.view.backgroundColor=[UIColor whiteColor];
}
- (void)creatImageView{
    UIImageView * img=[[UIImageView alloc]init];
    [self.view addSubview:img];
    img.x=0;
    img.y=64;
    UIImage * image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.img]]];
    CGSize s=image.size;
    [img sd_setImageWithURL:[NSURL URLWithString:self.img]];
    img.width=EPScreenW;
    img.height=EPScreenW*s.height/s.width;
    
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
