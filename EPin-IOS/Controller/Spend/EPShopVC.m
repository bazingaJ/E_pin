//
//  EPShopVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/11/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPShopVC.h"
#import "HeaderFile.h"
#import "LHClickImageView.h"
#import "EPDetailModel.h"
#import "EPGoodsDetailVC.h"
@interface EPShopVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;
@property(nonatomic,strong)EPShopModel * model;
@property(nonatomic,strong)NSMutableArray * discountArr;
@end

@implementation EPShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:@"商家详情"];
    [self addTwoRightItemWithFrame:CGRectMake(EPScreenW-20-30,20,50,44) action:@selector(share) name:@"分享"];
    [self tb];
    [EPTool addMBProgressWithView:self.view style:0];
    [EPTool showMBWithTitle:@"加载中..."];
    [self getShopData];
    self.tb.hidden=YES;
}
- (void)share{
    
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
- (void)getShopData{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getShopsDetailInfoData.json",EPUrl];
    NSDictionary * dict=@{@"shopId":self.shopId};
    [manager GET:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"商家------%@",responseObject);
        NSString * returnCode=responseObject[@"returnCode"];
        if ([returnCode integerValue]==0) {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            self.tb.hidden=NO;
            [self getDataWithDic:responseObject];
            [self.tb reloadData];
        }else{
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败，请稍后重试" count:0 doWhat:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [EPTool hiddenMBWithDelayTimeInterval:0];
        NSLog(@"%@",error);
    }];
}
- (void)getDataWithDic:(id)responseObject{
    [self.discountArr removeAllObjects];
    EPShopModel * model=[EPShopModel mj_objectWithKeyValues:responseObject];;
    _model=model;
    //优惠方案数组
    for (NSDictionary * dict in _model.discounArr) {
        EPDiscountModel * mo=[EPDiscountModel mj_objectWithKeyValues:dict];
        [self.discountArr addObject:mo];
    }
}
- (void)clickPhoneShop{
    if (_model.shopPhone.length==0) {
        [self addPhone:_model.shopPhones];
    }else if (_model.shopPhones.length==0){
        [self addPhone:_model.shopPhone];
    }else{
        [self addSelectPhone:_model.shopPhone withPhone2:_model.shopPhones];
    }
}
- (void)addPhone:(NSString *)phone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)addSelectPhone:(NSString *)phone1 withPhone2:(NSString *)phone2
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:@"请选择商家电话" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * phones1 =[UIAlertAction actionWithTitle:phone1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didSelectPhone:phone1];
    }];
    [alert addAction:phones1];
    UIAlertAction * phones2 =[UIAlertAction actionWithTitle:phone2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didSelectPhone:phone2];
    }];
    [alert addAction:phones2];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didSelectPhone:(NSString *)phone{
    NSString * ph=[NSString stringWithFormat:@"tel://%@",phone];
    NSURL *url = [NSURL URLWithString:ph];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0||section==1) {
        return 1;
    }else{
        return _model.discounArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat leftX=15;
    static NSString * cellId=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        LHClickImageView * img=[[LHClickImageView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, HEIGHT(153.0, 667))];
        [img sd_setImageWithURL:[NSURL URLWithString:_model.shopImg]];
        [cell.contentView addSubview:img];
    }
    if (indexPath.section==1) {
        UIView * vc=[[UIView alloc] init];
        [cell.contentView addSubview:vc];
        vc.frame=CGRectMake(0, 0, EPScreenW,135 );
        vc.backgroundColor=[UIColor whiteColor];
        UIView * line=[[UIView alloc]init];
        [vc addSubview:line];
        line.frame=CGRectMake(leftX, 95, EPScreenW-leftX*2, 1);
        line.backgroundColor=RGBColor(238, 238, 238);
        UILabel * goodNameLb=[[UILabel alloc]init];
        [vc addSubview:goodNameLb];
        goodNameLb.width=EPScreenW-leftX*2;
        goodNameLb.x=leftX;
        goodNameLb.y=10;
        goodNameLb.height=18;
        goodNameLb.text=_model.shopName;
        goodNameLb.font=[UIFont boldSystemFontOfSize:17];
        goodNameLb.textColor=RGBColor(0, 0, 0);
        
        UIImage * imgAdd=[UIImage imageNamed:@"定位新"];
        CGSize addsize=imgAdd.size;
        UIImageView * imgAddress=[[UIImageView alloc]init];
        [vc addSubview:imgAddress];
        imgAddress.size=addsize;
        imgAddress.x=leftX;
        imgAddress.y=CGRectGetMaxY(line.frame)+15;
        imgAddress.image=imgAdd;
        
        UIButton * btnPhone=[UIButton buttonWithType:UIButtonTypeCustom];
        [vc addSubview:btnPhone];
        btnPhone.width=60;
        btnPhone.height=40;
        btnPhone.x=EPScreenW-60;
        btnPhone.y= CGRectGetMaxY(line.frame);
        [btnPhone setImage:[UIImage imageNamed:@"电话新"] forState:UIControlStateNormal];
        [btnPhone addTarget:self action:@selector(clickPhoneShop) forControlEvents:UIControlEventTouchUpInside];
        UIView * verline=[[UIView alloc]init];
        [vc addSubview:verline];
        verline.backgroundColor=RGBColor(153, 153, 153);
        verline.frame=CGRectMake(btnPhone.x-1, CGRectGetMaxY(line.frame)+5, 1, 25);
        
        UILabel * addLb=[[UILabel alloc]init];
        [vc addSubview:addLb];
        addLb.width=EPScreenW-100;
        addLb.height=40;
        addLb.x=CGRectGetMaxX(imgAddress.frame)+10;
        addLb.y=CGRectGetMaxY(line.frame);
        addLb.font=[UIFont boldSystemFontOfSize:13];
        addLb.textColor=RGBColor(51, 51, 51);
        addLb.text=_model.shopAddress;
        addLb.numberOfLines=2;
        
        //消费次数
        UIImage * xin=[UIImage imageNamed:@"心"];
        CGSize xinSize=xin.size;
        UIImageView * xinImg=[[UIImageView alloc]init];
        [vc addSubview:xinImg];
        xinImg.x=leftX;
        xinImg.size=xinSize;
        xinImg.y=CGRectGetMinY(line.frame)-10-10;
        xinImg.image=xin;
        UILabel * soldlb=[[UILabel alloc]init];
        [vc addSubview:soldlb];
        soldlb.x=CGRectGetMaxX(xinImg.frame)+10;
        soldlb.y=CGRectGetMinY(line.frame)-10-11;
        soldlb.height=11;
        soldlb.width=200;
        soldlb.font=[UIFont boldSystemFontOfSize:11];
        soldlb.text=_model.soldNumber;
        soldlb.textColor=RGBColor(0, 0, 0);
        
        CGSize starSize=[UIImage imageNamed:@"星星新"].size;
        for (int i=0; i<5; i++) {
            UIImageView * imgStar=[[UIImageView alloc]initWithFrame:CGRectMake(leftX+(starSize.width+5)*i, CGRectGetMinY(soldlb.frame)-14-starSize.height, starSize.width, starSize.height)];
            if (i<[_model.shopStar intValue]) {
                imgStar.image=[UIImage imageNamed:@"星星新"];
            }else{
                imgStar.image=[UIImage imageNamed:@"空星新"];
            }
            [vc addSubview:imgStar];
        }
        if ([_model.shopStar intValue]>0) {
            UILabel * starFen=[[UILabel alloc]init];
            [vc addSubview:starFen];
            starFen.x=leftX+(5+starSize.width)*4+starSize.width+8;
            starFen.y=CGRectGetMinY(soldlb.frame)-14-starSize.height;
            starFen.height=starSize.height;
            starFen.width=100;
            starFen.font=[UIFont boldSystemFontOfSize:11];
            starFen.text=[NSString stringWithFormat:@"%d分",[_model.shopStar intValue]];
            starFen.textColor=RGBColor(255, 0, 0);
        }
        
    }
    if (indexPath.section==2) {
        if (self.discountArr.count>0) {
            EPDiscountModel * model=[self.discountArr objectAtIndex:indexPath.row];
            UIImageView * img=[[UIImageView alloc]init];
            [cell.contentView addSubview:img];
            img.y=8;
            img.height=65-16;
            img.width=75;
            img.x=leftX;
            [img sd_setImageWithURL:[NSURL URLWithString:model.discountImg]];
            UILabel * discountLb=[[UILabel alloc]init];
            [cell.contentView addSubview:discountLb];
            discountLb.x=CGRectGetMaxX(img.frame)+8;
            discountLb.y=8;
            discountLb.width=EPScreenW-113;
            discountLb.height=16;
            discountLb.font=[UIFont boldSystemFontOfSize:13];
            discountLb.textColor=RGBColor(51, 51, 51);
            discountLb.text=model.discountName;
            
            UILabel * currentPLb=[[UILabel alloc]init];
            [cell.contentView addSubview:currentPLb];
            currentPLb.frame=CGRectMake(CGRectGetMaxX(img.frame)+8, CGRectGetMaxY(discountLb.frame)+15, 200, 14);
            currentPLb.font=[UIFont boldSystemFontOfSize:12];
            currentPLb.text=[NSString stringWithFormat:@"¥%@",model.discountSubPrice];
            currentPLb.textColor=RGBColor(255, 0, 0);
            CGSize priceSize=[self sizeWithText:currentPLb.text font:[UIFont boldSystemFontOfSize:12]];
            currentPLb.width=priceSize.width;
            UILabel * oriPLb=[[UILabel alloc]init];
            [cell.contentView addSubview:oriPLb];
            oriPLb.frame=CGRectMake(CGRectGetMaxX(currentPLb.frame)+13, CGRectGetMaxY(discountLb.frame)+15, 150, 14);
            oriPLb.font=[UIFont boldSystemFontOfSize:11];
            oriPLb.text=[NSString stringWithFormat:@"¥%@",model.discountPrice];
            oriPLb.textColor=RGBColor(51, 51, 51);
            CGSize orisize=[self sizeWithText:oriPLb.text font:[UIFont boldSystemFontOfSize:12]];
            UIView * geLine=[[UIView alloc]init];
            [oriPLb addSubview:geLine];
            geLine.x=0;
            geLine.width=orisize.width;
            geLine.height=1;
            geLine.y=orisize.height/2;
            geLine.backgroundColor=RGBColor(51, 51, 51);
            UIView * line=[[UIView alloc]init];
            line.frame=CGRectMake(15, 64, EPScreenW-30, 1);
            line.backgroundColor=RGBColor(238, 238, 238);
            [cell.contentView addSubview:line];
        }
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * vc=[[UIView alloc]init];
    vc.backgroundColor=[UIColor whiteColor];
    vc.frame=CGRectMake(0, 0, EPScreenW, 36);
    UIView * line=[[UIView alloc]init];
    line.frame=CGRectMake(15, 35, EPScreenW-30, 1);
    line.backgroundColor=RGBColor(153, 153, 153);
    [vc addSubview:line];
    if (section==2) {
        UILabel * lb=[[UILabel alloc]init];
        [vc addSubview:lb];
        lb.frame=CGRectMake(15,15,65, 15);
        lb.text=@"其它优惠";
        lb.font=[UIFont boldSystemFontOfSize:15];
        lb.textColor=RGBColor(51, 51, 51);
        UIView * verLine=[[UIView alloc]init];
        [vc addSubview:verLine];
        verLine.frame=CGRectMake(CGRectGetMaxX(lb.frame)+7, 15, 1, 15);
        verLine.backgroundColor=RGBColor(51, 51, 51);
        UILabel * engLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verLine.frame)+7, 15, 300, 16)];
        [vc addSubview:engLb];
        engLb.text=@"Other preferential";
        engLb.font=[UIFont systemFontOfSize:11];
        engLb.textColor=RGBColor(51, 51, 51);
    }
    return vc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        if (_model.discounArr.count>0) {
            return 36;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0||section==2) {
        return 0;
    }else{
        if (_model.discounArr.count>0) {
            return 8;
        }else{
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return HEIGHT(153.0, 667);
    }else if (indexPath.section==1){
        return 135;
    }else{
        return 65;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        EPDiscountModel * model=[self.discountArr objectAtIndex:indexPath.row];
        EPGoodsDetailVC * vc=[[EPGoodsDetailVC alloc]init];
        vc.goodsId=model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, EPScreenW, EPScreenH-64) style:UITableViewStylePlain];
        _tb.backgroundColor=RGBColor(234, 234, 234);
        _tb.delegate=self;
        _tb.dataSource=self;
        _tb.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tb];
    }
    return _tb;
}
- (NSMutableArray *)discountArr{
    if (!_discountArr) {
        _discountArr=[[NSMutableArray alloc]init];
    }
    return _discountArr;
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
