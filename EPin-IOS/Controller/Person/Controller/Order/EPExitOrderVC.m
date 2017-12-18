//
//  EPExitOrderVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/6.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPExitOrderVC.h"
#import "HeaderFile.h"
#define btnTag 600
@interface EPExitOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;

@property(nonatomic,strong)UIView * vc;
/**退款理由*/
@property(nonatomic,strong)NSArray * resonArr;

@end

@implementation EPExitOrderVC
{
    NSMutableString * _codes;
    NSString * _reson;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"申请退单"];
    [self addSureBtn];
    [self tb];
    [self creatFoot];
    _codes=[[NSMutableString alloc]init];
}
- (void)exitBtnClick{
    //    NSLog(@"_codes====%@",_codes);
    //    NSLog(@"reson=====%@",_reson);
    if (_codes.length==0) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请选择商品兑换码" count:0 doWhat:nil];
    }else if(_reson.length>0){
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@""];
        EPData * data=[EPData new];
        [data getMyOrderInfoWithType:@"5" withGoodsId:nil withCount:nil withOrderId:nil withIp:nil withPayStyle:nil withCardId:nil withUseScore:nil withOrderNo:nil password:nil withCodes:_codes withRefundReson:_reson WithCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            if ([returnCode intValue]==0) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"申请退单成功,请耐心等待" count:0 doWhat:^{
                    [self.navigationController popViewControllerAnimated:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Orderexit" object:nil userInfo:nil];
                }];
                
            }else if ([returnCode intValue]==1){
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请选择商品兑换码" count:0 doWhat:nil];
            }else if ([returnCode intValue]==2){
                [EPLoginViewController publicDeleteInfo];
                EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络连接失败，请稍后重试" count:0 doWhat:nil];
            }
        }];
    }else{
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请选择退款理由" count:0 doWhat:nil];
    }
}
- (void)selectRensu:(UIButton *)btn{
    btn.selected=YES;
    UIButton * btn1=[_vc viewWithTag:btnTag];
    UIButton * btn2=[_vc viewWithTag:btnTag+1];
    UIButton * btn3=[_vc viewWithTag:btnTag+2];
    UIButton * btn4=[_vc viewWithTag:btnTag+3];
    UIButton * btn5=[_vc viewWithTag:btnTag+4];
    switch (btn.tag-btnTag) {
        case 0:
        {
            _reson=_resonArr[0];
            btn2.selected=NO;
            btn3.selected=NO;
            btn4.selected=NO;
            btn5.selected=NO;

        }
            break;
        case 1:{
            _reson=_resonArr[1];
            btn1.selected=NO;
            btn3.selected=NO;
            btn4.selected=NO;
            btn5.selected=NO;
        }
            break;
        case 2:{
            _reson=_resonArr[2];
            btn1.selected=NO;
            btn2.selected=NO;
            btn4.selected=NO;
            btn5.selected=NO;
        }
            break;
        case 3:{
            _reson=_resonArr[3];
            btn1.selected=NO;
            btn2.selected=NO;
            btn3.selected=NO;
            btn5.selected=NO;
        }
            break;
        case 4:{
            _reson=_resonArr[4];
            btn1.selected=NO;
            btn2.selected=NO;
            btn3.selected=NO;
            btn4.selected=NO;
        }
            break;
        default:
            break;
    }
    
}
- (void)creatFoot{
    UIView * vc=[[UIView alloc]init];
    vc.backgroundColor=[UIColor whiteColor];
    vc.frame=CGRectMake(0, 0, EPScreenW, 237);
    UIView * vc1=[[UIView alloc]init];
    vc1.frame=CGRectMake(0, 0, EPScreenW, 37);
    [vc addSubview:vc1];
    UILabel * lb=[[UILabel alloc]init];
    lb.frame=CGRectMake(15,0, 200, 37);
    lb.font=[UIFont systemFontOfSize:15];
    lb.textColor=RGBColor(51, 51, 51);
    lb.text=@"退款理由";
    [vc1 addSubview:lb];
    UIView * line=[[UIView alloc]init];
    [vc1 addSubview:line];
    line.frame=CGRectMake(15, 36, EPScreenW-30, 1);
    line.backgroundColor=RGBColor(153, 153, 153);
    for (int i=0; i<4; i++) {
        UIView * vcLiine=[[UIView alloc]init];
        vcLiine.backgroundColor=RGBColor(231, 231, 231);
        vcLiine.frame=CGRectMake(15, 37+40*(i+1), EPScreenW-40, 1);
        [vc addSubview:vcLiine];
    }
    NSArray * arr=@[@"买错/多了",@"没时间消费",@"有更好的选择",@"不想要了",@"其他原因"];
    _resonArr=arr;
    for (int i=0; i<5; i++) {
        UILabel * lb=[[UILabel alloc]init];
        lb.frame=CGRectMake(15,37+i*40, 150, 40);
        lb.font=[UIFont systemFontOfSize:14];
        lb.text=arr[i];
        [vc addSubview:lb];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(EPScreenW-60,37+i*40, 60, 40);
        btn.tag=btnTag+i;
        [btn setImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"组13"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectRensu:) forControlEvents:UIControlEventTouchUpInside];
        [vc addSubview:btn];
    }
    _vc=vc;
    self.tb.tableFooterView=vc;
}
/**确认退单*/
- (void)addSureBtn{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, EPScreenH-60, EPScreenW, 60);
    btn.backgroundColor=RGBColor(29, 32, 40);
    [btn setTitle:@"确认退单" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:18];
    [btn setTitleColor:RGBColor(218, 187, 132) forState:UIControlStateNormal];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.useListArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat leftX=15;
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        UIImageView * img=[[UIImageView alloc]init];
        [cell addSubview:img];
        img.frame=CGRectMake(leftX, 9, 75, 75);
        [img sd_setImageWithURL:[NSURL URLWithString:self.goodImg]];
        CGFloat imgMaxX=CGRectGetMaxX(img.frame)+10;
        UILabel * goodName=[[UILabel alloc]init];
        [cell.contentView addSubview:goodName];
        goodName.frame=CGRectMake(imgMaxX, 14, EPScreenW-imgMaxX-leftX, 15);
        goodName.font=[UIFont systemFontOfSize:14];
        goodName.textColor=RGBColor(51, 51, 51);
        goodName.text=self.goodName;
        UILabel * timeLb=[[UILabel alloc]init];
        [cell.contentView addSubview:timeLb];
        timeLb.frame=CGRectMake(imgMaxX, 93-14-11, goodName.width, 10);
        timeLb.font=[UIFont systemFontOfSize:10];
        timeLb.textColor=RGBColor(102, 102, 102);
        NSString * time=[self.time substringToIndex:16];
        timeLb.text=[NSString stringWithFormat:@"下单时间: %@",time];
        
        UILabel * priceLb=[[UILabel alloc]init];
        [cell.contentView addSubview:priceLb];
        priceLb.x=imgMaxX;
        priceLb.y=CGRectGetMaxY(goodName.frame)+17;
        priceLb.height=15;
        NSString * textPrice=[NSString stringWithFormat:@"￥%@",self.price];
        priceLb.width=goodName.width;
        priceLb.font=[UIFont boldSystemFontOfSize:14];
        priceLb.textColor=RGBColor(255, 0, 0);
        priceLb.text=textPrice;
    }
    if (indexPath.section==1) {
        UILabel * lb=[[UILabel alloc]init];
        [cell.contentView addSubview:lb];
        lb.frame=CGRectMake(leftX, 0, 250, 40);
        lb.font=[UIFont systemFontOfSize:14];
        lb.textColor=RGBColor(51, 51, 51);
        NSDictionary * dict=self.useListArr[indexPath.row];
        NSString * str=[NSString stringWithFormat:@"兑换码%ld: %@",indexPath.row+1,dict[@"code"]];
        lb.text=str;
        lb.tag=700+indexPath.row;
        if ([dict[@"statusName"] isEqualToString:@"未使用"]) {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:btn];
            btn.tag=800+indexPath.row;
            btn.frame=CGRectMake(EPScreenW-60, 0, 60, 40);
            [btn setImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"组12"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(selectCode:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            NSString *statusName=dict[@"statusName"];
            UILabel * lb2=[[UILabel alloc]init];
            [cell.contentView addSubview:lb2];
            lb2.x=EPScreenW-leftX-50;
            lb2.y=0;
            lb2.width=50;
            lb2.height=40;
            lb2.font=[UIFont systemFontOfSize:11];
            lb2.textColor=RGBColor(51, 51, 51);
            lb2.text=statusName;
            lb2.textAlignment=NSTextAlignmentRight;
        }

        if (indexPath.row<self.useListArr.count-1) {
            UIView * line=[[UIView alloc]init];
            [cell.contentView addSubview:line];
            line.frame=CGRectMake(leftX, 39, EPScreenW-2*leftX, 1);
            line.backgroundColor=RGBColor(238, 238, 238);
        }
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * vc=[[UIView alloc]init];
    vc.backgroundColor=[UIColor whiteColor];
    vc.frame=CGRectMake(0, 0, EPScreenW, 37);
    UILabel * lb=[[UILabel alloc]init];
    lb.frame=CGRectMake(15,0, 200, 37);
    lb.font=[UIFont boldSystemFontOfSize:15];
    lb.textColor=RGBColor(51, 51, 51);
    UIView * line=[[UIView alloc]init];
    [vc addSubview:line];
    line.frame=CGRectMake(15, 36, EPScreenW-30, 1);
    line.backgroundColor=RGBColor(153, 153, 153);
    if (section==0) {
        lb.text=@"退款商品";
    }else if(section==1){
        lb.text=@"选择商品兑换码";
    }
    [vc addSubview:lb];
    return vc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 93;
    }else {
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return 37;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (void)selectCode:(UIButton *)btn{
    btn.selected=!btn.selected;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.tag-800 inSection:1];
    UITableViewCell * cell=[self.tb cellForRowAtIndexPath:indexPath];
    UILabel * lb=[cell.contentView viewWithTag:700+(btn.tag-800)];
    NSString * str=[lb.text substringFromIndex:6];
    if (btn.selected) {
        [_codes appendFormat:@",%@",str];
    }else{
        if (_codes.length==0) {
            
        }else{
            NSRange strRange=[_codes rangeOfString:str];
            [_codes deleteCharactersInRange:strRange];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat sectionHeaderHeight = 37;

    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {

        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);

    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {

        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);

    }

}

#pragma -------懒加载--------
- (UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0,64,EPScreenW,EPScreenH-64-60) style:UITableViewStylePlain];
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
