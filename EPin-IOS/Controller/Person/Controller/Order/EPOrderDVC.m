//
//  EPOrderDVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/12/2.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPOrderDVC.h"
#import "HeaderFile.h"
#import "QRCodeGenerator.h"
#import "EPExitOrderVC.h"
@interface EPOrderDVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;

@end

@implementation EPOrderDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:2 title:@"订单详情"];
    [self tb];
    [self addLeftItemWithFrame:CGRectZero textOrImage:0 action:@selector(backActionClick) name:@"返回"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backActionClick) name:@"Orderexit" object:nil];
}
- (void)backActionClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBtnClick{
    [self ScreenShot];
}
-(void)ScreenShot{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    CGRect rect = self.view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"保存成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.statusName rangeOfString:@"未使用"].location !=NSNotFound) {
        return 4;
    }else{
        return 3;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return self.useCodeList.count+1;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat leftX=15;
    if (indexPath.section==0) {
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.frame=CGRectMake(0, 0,EPScreenW , 110);
        vc.backgroundColor=[UIColor whiteColor];
        UIImageView * goodImg=[[UIImageView alloc]init];
        [vc addSubview:goodImg];
        goodImg.frame=CGRectMake(leftX, leftX, 75, 75);
        [goodImg sd_setImageWithURL:[NSURL URLWithString:self.goodsImg]];
        CGFloat maxImg=CGRectGetMaxX(goodImg.frame)+15;
        UILabel * goodName=[[UILabel alloc]init];
        [vc addSubview:goodName];
        goodName.frame=CGRectMake(maxImg, 20, EPScreenW-maxImg-leftX, 16);
        goodName.font=[UIFont boldSystemFontOfSize:16];
        goodName.textColor=RGBColor(51, 51, 51);
        goodName.text=self.goodsName;
        
        UILabel * priceLb=[[UILabel alloc]init];
        [vc addSubview:priceLb];
        priceLb.x=maxImg;
        priceLb.y=CGRectGetMaxY(goodName.frame)+14;
        priceLb.height=15;
        NSString * textPrice=[NSString stringWithFormat:@"￥%@",self.price];
        CGSize s1=[self sizeWithText:textPrice font:[UIFont systemFontOfSize:15]];
        priceLb.width=s1.width;
        priceLb.font=[UIFont systemFontOfSize:15];
        priceLb.textColor=RGBColor(255, 38, 0);
        priceLb.text=textPrice;
        
        UILabel * countLb=[[UILabel alloc]init];
        [vc addSubview:countLb];
        countLb.frame=CGRectMake(CGRectGetMaxX(priceLb.frame)+10, priceLb.y, 150, 15);
        countLb.font=[UIFont systemFontOfSize:12];
        countLb.textColor=RGBColor(102, 102, 102);
        countLb.text=[NSString stringWithFormat:@"数量: %@",self.goodsCount];
        
        UILabel * timeLb=[[UILabel alloc]init];
        [vc addSubview:timeLb];
        timeLb.frame=CGRectMake(maxImg, CGRectGetMaxY(priceLb.frame)+14, goodName.width, 12);
        timeLb.font=[UIFont systemFontOfSize:12];
        timeLb.textColor=RGBColor(102, 102, 102);
        NSString * time=[self.commitTime substringToIndex:16];
        timeLb.text=[NSString stringWithFormat:@"下单时间: %@",time];
        
    }
    if (indexPath.section==1) {
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.frame=CGRectMake(0, 0, EPScreenW, 114);
        vc.backgroundColor=[UIColor whiteColor];
        for (int i=0; i<2; i++) {
            UIView * line=[[UIView alloc]init];
            [vc addSubview:line];
            line.frame=CGRectMake(leftX, (i+1)*38, EPScreenW-2*leftX, 1);
            line.backgroundColor=RGBColor(238, 238, 238);
        }
        for (int i=0; i<3; i++) {
            UILabel * lb=[[UILabel alloc]init];
            [vc addSubview:lb];
            lb.frame=CGRectMake(leftX, i*38, EPScreenW-2*leftX, 38);
            lb.font=[UIFont systemFontOfSize:14];
            lb.textColor=RGBColor(51, 51, 51);
            if (i==0) {
                lb.text=[NSString stringWithFormat:@"商家详情: %@",self.shopName];
            }else if (i==1){
                lb.text=[NSString stringWithFormat:@"商家地址: %@",self.shopAddress];
            }else{
                lb.text=[NSString stringWithFormat:@"商家电话: %@",self.shopPhone];
            }
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row<self.useCodeList.count) {
            NSString * code=self.useCodeList[indexPath.row][@"code"];
            NSString * statusName=self.useCodeList[indexPath.row][@"statusName"];
            UILabel * lb1=[[UILabel alloc]init];
            [cell.contentView addSubview:lb1];
            lb1.x=leftX;
            lb1.y=0;
            lb1.height=38;
            NSString * str=[NSString stringWithFormat:@"兑换码%ld: %@",indexPath.row+1,code];
            lb1.font=[UIFont systemFontOfSize:14];
            lb1.textColor=RGBColor(51, 51, 51);
            lb1.text=str;
            CGSize ss=[self sizeWithText:str font:[UIFont systemFontOfSize:14]];
            lb1.width=ss.width;
            
            UILabel * lb2=[[UILabel alloc]init];
            [cell.contentView addSubview:lb2];
            lb2.x=CGRectGetMaxX(lb1.frame)+20;
            lb2.y=0;
            lb2.width=150;
            lb2.height=lb1.height;
            lb2.font=[UIFont systemFontOfSize:11];
            lb2.textColor=RGBColor(51, 51, 51);
            lb2.text=statusName;
            UIView * vc=[[UIView alloc]init];
            [cell.contentView addSubview:vc];
            vc.backgroundColor=RGBColor(238, 238, 238);
            vc.frame=CGRectMake(leftX, 37, EPScreenW-2*leftX, 1);
        }else{
            UILabel * lb=[[UILabel alloc]init];
            [cell.contentView addSubview:lb];
            lb.frame=CGRectMake(leftX, leftX, 150, 15);
            lb.font=[UIFont systemFontOfSize:14];
            lb.textColor=RGBColor(51, 51, 51);
            lb.text=@"二维码";
            UIImageView * codeImg=[[UIImageView alloc]init];
            [cell.contentView addSubview:codeImg];
            codeImg.width=110;
            codeImg.height=110;
            codeImg.centerX=self.view.centerX;
            codeImg.y=CGRectGetMaxY(lb.frame)+13;
            codeImg.layer.borderColor=RGBColor(51, 51, 51).CGColor;
            codeImg.layer.borderWidth=1;
            UIImage * image=[QRCodeGenerator qrImageForString:self.exchangeCode imageSize:codeImg.bounds.size.width];
            codeImg.image=image;
            
            UIImageView * head=[[UIImageView alloc]init];
            [codeImg addSubview:head];
            head.width=15;
            head.height=15;
            head.centerX=codeImg.width/2;;
            head.centerY=codeImg.height/2;
            head.layer.borderColor=[UIColor whiteColor].CGColor;
            head.layer.borderWidth=1;
            [head sd_setImageWithURL:[NSURL URLWithString:self.goodsImg]];
            
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:btn];
            btn.width=80;
            btn.height=25;
            btn.centerX=self.view.centerX;
            btn.y=CGRectGetMaxY(codeImg.frame)+10;
            btn.layer.masksToBounds=YES;
            btn.layer.cornerRadius=5;
            btn.backgroundColor=RGBColor(50, 50, 50);
            [btn setTitle:@"保存到相册" forState:UIControlStateNormal];
            [btn setTitleColor:RGBColor(252, 215, 149) forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:12];
             [btn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (indexPath.section==3) {
        UILabel * lb=[[UILabel alloc]init];
        [cell.contentView addSubview:lb];
        lb.frame=CGRectMake(leftX, 0, 200, 45);
        lb.font=[UIFont systemFontOfSize:14];
        lb.textColor=RGBColor(51, 51, 51);
        lb.text=@"申请退单";
        //arrow_right
        UIImage * img=[UIImage imageNamed:@"arrow_right"];
        CGSize ss=img.size;
        UIImageView * btn=[[UIImageView alloc]init];
        [cell.contentView addSubview:btn];
        btn.size=ss;
        btn.x=EPScreenW-leftX-ss.width;
        btn.y=(45-ss.height)/2;
        btn.image=img;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 110;
    }else if (indexPath.section==1){
        return 114;
    }else if (indexPath.section==2){
        if (indexPath.row<self.useCodeList.count) {
            return 38;
        }else{
            return 203;
        }
    }else{
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        EPExitOrderVC * vc=[[EPExitOrderVC alloc]init];
        vc.goodName=self.goodsName;
        vc.price=self.price;
        vc.time=self.commitTime;
        vc.useListArr=self.useCodeList;
        vc.goodImg=self.goodsImg;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)tb{
    if (_tb==nil) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0,64,EPScreenW,EPScreenH-49-20) style:UITableViewStylePlain];
        _tb.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tb.delegate=self;
        _tb.dataSource=self;
        _tb.backgroundColor=RGBColor(238, 238, 238);
        _tb.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_tb];
    }
    return _tb;
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
