//
//  EPNewsDetailVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPNewsDetailVC.h"
#import "HeaderFile.h"
#import "JDPushData.h"
#import "JDPushDataTool.h"
@interface EPNewsDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tb;

@property (nonatomic, assign) CGFloat cellHeigh;

@end

@implementation EPNewsDetailVC
{
    NSString * _str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"消息详情"];
    self.tb.delegate=self;
    self.tb.dataSource=self;
    self.tb.backgroundColor=RGBColor(234, 234, 234);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArr.count==0) {
        [self showHaveNoMessage];
    }
    if ([self.news isEqualToString:@"易品"]) {
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:@"0" forKey:@"isUse"];
        [us synchronize];
    }else if ([self.news isEqualToString:@"召车消息"]){
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:@"0" forKey:@"isgetOn"];
        [us synchronize];
    }else{
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        [us setObject:@"0" forKey:@"isshopRest"];
        [us synchronize];
    }
}
- (void)showHaveNoMessage{
    self.view.backgroundColor=RGBColor(234, 234, 234);
    UILabel * lb=[[UILabel alloc]init];
    lb.frame=CGRectMake(0, EPScreenH/2, EPScreenW, 20);
    lb.text=@"您当前没有任何消息";
    lb.font=[UIFont systemFontOfSize:15];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.textColor=RGBColor(128, 128, 128);
    [self.view addSubview:lb];
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
#pragma mark-----UITableViewDelegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDPushData *data = self.dataArr[indexPath.section];
    static NSString * cellID=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=RGBColor(234, 234, 234);
        UIView * back=[[UIView alloc]init];
        back.layer.masksToBounds=YES;
        back.layer.cornerRadius=5;
        //back.frame=CGRectMake(20, 0, EPScreenW-40, 75);
        back.x=20;
        back.y=0;
        back.width=EPScreenW-40;
        
        back.backgroundColor=[UIColor whiteColor];
       
        UIView * l=[[UIView  alloc]init];
        l.frame=CGRectMake(0,25, EPScreenW-40, 1);
        l.backgroundColor=RGBColor(217, 217, 217);
        [back  addSubview:l];
        
        UILabel * time=[[UILabel alloc]init];
        time.frame=CGRectMake(10, 0, 200, 25);
        time.font=[UIFont systemFontOfSize:12];
        time.text=data.currentTime;
        time.textColor=RGBColor(128, 128, 128);
        [back addSubview:time];
        
        UILabel * content=[[UILabel alloc]init];
        content.font=[UIFont systemFontOfSize:14];
        content.text=data.content;
        CGSize labelSize = [self sizeWithText:data.content font:[UIFont systemFontOfSize:14] maxW:EPScreenW-40-20];
        content.x=10;
        content.y=CGRectGetMaxY(l.frame)+5;
        content.height=labelSize.height;
        content.width=EPScreenW-40-20;
        content.numberOfLines=0;
        
        back.height=CGRectGetMaxY(content.frame)+5;
        self.cellHeigh=CGRectGetMaxY(content.frame)+5;
        [back addSubview:content];
        [cell.contentView addSubview:back];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * vc=[[UIView alloc]init];
    vc.frame=CGRectMake(0, 0, EPScreenW, 15);
    vc.backgroundColor=RGBColor(234, 234, 234);
    return vc;
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
