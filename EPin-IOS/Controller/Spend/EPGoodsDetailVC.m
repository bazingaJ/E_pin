//
//  EPGoodsDetailVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/11/21.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPGoodsDetailVC.h"
#import "HeaderFile.h"
#import "EPDetailModel.h"
#import "LHClickImageView.h"
#import "EPShopVC.h"
#import "EPSubmitController.h"
#import "EPMoreCommentVC.h"
#import "EPPhotoAndMessDetailVC.h"
@interface EPGoodsDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tb;
@property(nonatomic,strong)EPDetailModel * model;
@property (nonatomic, assign) CGFloat cellHeigh;
@property(nonatomic,strong)NSMutableArray * commentArr;
@property (nonatomic, assign) CGFloat cell5Heigh;
@property (nonatomic, strong) UIButton *collect;
@property(nonatomic,assign)CGFloat cell3Height1;
@property(nonatomic,assign)CGFloat cell3Height2;
/**收藏*/
@property(nonatomic,strong)UILabel * lb;
/**取消收藏*/
@property(nonatomic,strong)UILabel * cancleLb;
@end

@implementation EPGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:@"商品详情"];
    [self addStarRightItemWithFrame:CGRectMake(EPScreenW-20-22,20,44,44) action:@selector(favor1:) name:@"收藏"];
    [self tb];
    [EPTool addMBProgressWithView:self.view style:0];
    [EPTool showMBWithTitle:@"加载中..."];
    self.tb.hidden=YES;
    [self getGoodsData];
    [self  tanchuView];
    self.view.backgroundColor=[UIColor whiteColor];
}
- (void)clickPayMoney{
    if (LOGINTIME==nil) {
        EPLoginViewController * vc=[[EPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        //跳转到支付页面
        float p=[_model.goodsCheapPrice floatValue]/[_model.goodsPrice floatValue]*10;
        EPSubmitController * submit=[[EPSubmitController alloc]init];
        submit.goodsName=_model.goodsName;
        submit.price=_model.goodsCheapPrice;
        submit.costScore=_model.costScore;
        submit.goodsId=self.goodsId;
        submit.zhekou=p;
        [self.navigationController pushViewController:submit animated:YES];
    }
}
- (void)addPaybtn{
    UIView * vc=[[UIView alloc]init];
    [self.view addSubview:vc];
    vc.frame=CGRectMake(0, EPScreenH-49, EPScreenW, 49);
    UILabel * price=[[UILabel alloc]init];
    [vc addSubview:price];
    price.x=0;
    price.y=0;
    price.height=49;
    price.width=WIDTH(150.0, 375);
    price.backgroundColor=RGBColor(22, 24, 29);
    price.textColor=[UIColor whiteColor];
    price.text=[NSString stringWithFormat:@"优惠价:¥%@",_model.goodsCheapPrice];
    price.textAlignment=NSTextAlignmentCenter;
    price.font=[UIFont systemFontOfSize:15];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [vc addSubview:btn];
    btn.frame=CGRectMake(CGRectGetMaxX(price.frame), 0, EPScreenW-price.width, 49);
    btn.backgroundColor=RGBColor(252, 42, 51);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickPayMoney) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LOGINTIME!=nil) {
        [self getCommentData];
    }
}
- (void)tanchuView{
    UILabel * favorLb=[[UILabel alloc]initWithFrame:CGRectMake((EPScreenW-240)/2, EPScreenH-120, 240,30)];
    favorLb.backgroundColor=[UIColor whiteColor];
    favorLb.text=@"收藏成功，可在我的收藏中查看";
    favorLb.font=[UIFont systemFontOfSize:14];
    favorLb.textAlignment=NSTextAlignmentCenter;
    favorLb.alpha=0.0;
    favorLb.hidden=YES;
    favorLb.layer.borderColor=[[UIColor grayColor] CGColor];
    favorLb.layer.borderWidth=1;
    favorLb.layer.cornerRadius=5;
    _lb=favorLb;
    [self.view addSubview:favorLb];
    
    
    UILabel * cancleLb=[[UILabel alloc]initWithFrame:CGRectMake((EPScreenW-120)/2, EPScreenH-120,120,30)];
    cancleLb.backgroundColor=[UIColor whiteColor];
    cancleLb.text=@"取消收藏成功";
    cancleLb.font=[UIFont systemFontOfSize:14];
    cancleLb.textAlignment=NSTextAlignmentCenter;
    cancleLb.alpha=0.0;
    cancleLb.hidden=YES;
    cancleLb.layer.borderColor=[[UIColor grayColor] CGColor];
    cancleLb.layer.borderWidth=1;
    cancleLb.layer.cornerRadius=5;
    _cancleLb=cancleLb;
    [self.view addSubview:cancleLb];
}
- (void)favor1:(UIButton *)btn{
    //未收藏
    if (PHONENO==nil) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您尚未登录,请先登录" count:1 doWhat:^{
            EPLoginViewController * login=[[EPLoginViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }];
        
    }else{
        btn.selected = !btn.selected;
        NSDictionary * inDic =[[NSDictionary alloc]init];
        if (btn.isSelected==YES) {
            //提交收藏
            NSDictionary * dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId",nil];
            inDic=dict1;
            NSLog(@"提交1");
        }else{
            [btn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            //取消收藏
            NSDictionary * dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId",nil];
            inDic=dict2;
            NSLog(@"取消1");
        }
        [self postFavorData:inDic];
    }
}
- (void)favor2:(UIButton *)btn{
    //登录上，显示收藏状态
    NSDictionary * inDic =[[NSDictionary alloc]init];
    if (btn.isSelected==NO) {
        //提交收藏
        NSDictionary * dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId",nil];
        inDic=dict1;
        NSLog(@"提交");
    }else{
        //取消收藏
        btn.selected=btn.selected;
        NSDictionary * dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId",nil];
        inDic=dict2;
        NSLog(@"取消");
    }
    [self postFavorData:inDic];
}
- (void)postFavorData:(NSDictionary *)dict{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getMyCollectionInfo.json",EPUrl];
    [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * typeValue=dict[@"type"];
        //提交收藏
        NSString * returnCode=[responseObject[@"returnCode"] stringValue];
        NSString * msg=responseObject[@"msg"];
        if ([returnCode intValue]==0) {
            if ([typeValue integerValue]==0) {
                [UIView animateWithDuration:1 animations:^{
                    _lb.alpha=1.0;
                    _lb.hidden=NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:20 animations:^{
                        _lb.alpha=0.0;
                        _lb.hidden=YES;
                    }];
                }];
            }else if ([typeValue integerValue]==2){
                //取消收藏
                [UIView animateWithDuration:1 animations:^{
                    _cancleLb.alpha=1.0;
                    _cancleLb.hidden=NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:20 animations:^{
                        _cancleLb.alpha=0.0;
                        _cancleLb.hidden=YES;
                    }];
                }];
            }
            
        }else if ([returnCode intValue]==1){
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
        }else if ([returnCode intValue]==2){
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [EPLoginViewController publicDeleteInfo];
                EPLoginViewController * login=[[EPLoginViewController alloc]init];
                [self presentViewController:login animated:YES completion:nil];
            }];
        }else{
            if ([typeValue intValue]==0) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络问题，添加收藏失败" count:0 doWhat:nil];
            }else if([typeValue intValue]==2){
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络问题，取消收藏失败" count:0 doWhat:nil];
            }
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//请求详情数据
- (void)getGoodsData{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=[NSString  stringWithFormat:@"%@/getGoodsDetailInfoData.json",EPUrl];
    NSDictionary * inDict=[[NSDictionary alloc]init];
    if (LOGINTIME==nil) {
        inDict=@{@"goodsId":self.goodsId};
    }else{
        inDict=@{@"goodsId":self.goodsId,@"phoneNo":PHONENO};
    }
    [manager GET:url parameters:inDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"详情数据---%@",responseObject);
        NSString * returnCode=responseObject[@"returnCode"];
        if ([returnCode intValue]==0) {
            self.tb.hidden=NO;
            [EPTool hiddenMBWithDelayTimeInterval:0];
            EPDetailModel * model=[EPDetailModel mj_objectWithKeyValues:responseObject];
            _model=model;
            if ([model.isCollection integerValue]==0) {
                self.collect.selected = NO;
            }else{
                self.collect.selected = YES;
          }
            [self addPaybtn];
            [self.tb reloadData];
        }else{
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败，请稍后重试" count:0 doWhat:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [EPTool hiddenMBWithDelayTimeInterval:0];
    }];
    
}
-(void)addStarRightItemWithFrame:(CGRect)frame action:(SEL)action name:(NSString *)name
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
    [self.view addSubview:button];
    if (action!=nil) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    self.collect = button;
    
}

- (void)getCommentData{
    [self.commentArr removeAllObjects];
    NSString * str =[NSString stringWithFormat:@"%@/getMyCommentInfo.json",EPUrl];
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId" ,nil];
    [manager GET:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
     NSLog(@"获取某商品所有评论======%@",responseObject);
        NSString * returncode=responseObject[@"returnCode"];
        if ([returncode integerValue]==0) {
            NSArray * commentArr=responseObject[@"commentArr"];
            for (NSDictionary * dict in commentArr) {
                EPGetCommentModel * model=[EPGetCommentModel mj_objectWithKeyValues:dict];
                [self.commentArr addObject:model];
            }
            if (self.commentArr.count>2) {
                [self addTableFooter];
            }
        }
        [self.tb reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        self.tb.hidden=YES;
    }];
}
//分享
- (void)btnShareClick{
     [JDGoodsTools shareUMInVc:self];
}
- (void)clickPhoneShopGoods{
    if (_model.phone1.length==0) {
        [self addPhone:_model.phone2];
    }else if (_model.phone2.length==0){
        [self addPhone:_model.phone1];
    }else{
        [self addSelectPhone:_model.phone1 withPhone2:_model.phone2];
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
- (void)clickToShopDetail{
    EPShopVC * vc=[[EPShopVC alloc]init];
    vc.shopId=_model.shopId;
    [self.navigationController pushViewController:vc animated:YES];
}
//跳转图文详情
- (void)clickLbPhoneAnsmessage{
    EPPhotoAndMessDetailVC * vc=[[EPPhotoAndMessDetailVC alloc]init];
    vc.img=_model.describeImg;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (LOGINTIME==nil) {
        return 5;
    }else{
        if (self.commentArr.count==0) {
            return 5;
        }else{
            return 6;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0||section==1||section==2) {
        return 1;
    }else if(section==3){
        if (_model.describeImg.length>0) {
            return _model.detailsRecord.count+_model.addRecord.count+1;
        }else{
            return _model.detailsRecord.count+_model.addRecord.count;

        }
        
    }else if(section==4){
        return _model.record.count;
    }else{
        if (LOGINTIME!=nil) {
            if (self.commentArr.count>2) {
                return 2;
            }else{
                return self.commentArr.count;
            }
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat leftX=15;
    if (indexPath.section==0) {
        LHClickImageView * img=[[LHClickImageView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, HEIGHT(153.0, 667))];
        [img sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg]];
        [cell.contentView addSubview:img];
    }
    if (indexPath.section==1) {
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.frame=CGRectMake(0, 0, EPScreenW, 115);
        vc.backgroundColor=[UIColor whiteColor];
        UIView * line=[[UIView alloc]init];
        [vc addSubview:line];
        line.frame=CGRectMake(leftX, 79, EPScreenW-2*leftX, 1);
        line.backgroundColor=RGBColor(238, 238, 238);
        UILabel * goodName=[[UILabel alloc]init];
        [vc addSubview:goodName];
        goodName.frame=CGRectMake(leftX, 20, EPScreenW-2*leftX-50, 18);
        goodName.font=[UIFont boldSystemFontOfSize:17];
        goodName.textColor=RGBColor(0, 0, 0);
        goodName.text=_model.goodsName;
        //分享按钮
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [vc addSubview:btn];
        btn.frame=CGRectMake(EPScreenW-50, 0, 50, 45);
        [btn setImage:[UIImage imageNamed:@"分享新"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnShareClick) forControlEvents:UIControlEventTouchUpInside];
        CGFloat maxY=CGRectGetMaxY(line.frame);
        CGFloat miny=CGRectGetMinY(line.frame);
        UILabel * oriPrice=[[UILabel alloc]init];
        [vc addSubview:oriPrice];
        NSString * oriPriceText=[NSString stringWithFormat:@"¥%@",_model.goodsPrice];
        oriPrice.y=maxY+8;
        oriPrice.height=15;
        CGSize oriSize=[self sizeWithText:oriPriceText font:[UIFont boldSystemFontOfSize:13]];
        oriPrice.width=oriSize.width;
        oriPrice.x=EPScreenW-leftX-oriPrice.width;
        oriPrice.textColor=RGBColor(51, 51, 51);
        oriPrice.font=[UIFont boldSystemFontOfSize:13];
        oriPrice.text=oriPriceText;
        UIView * geline=[[UIView alloc]init];
        [oriPrice addSubview:geline];
        geline.frame=CGRectMake(0, oriSize.height/2, oriSize.width, 1);
        geline.backgroundColor=RGBColor(51, 51, 51);
        //星级
        CGSize starSize=[UIImage imageNamed:@"星星新"].size;
        for (int i=0; i<5; i++) {
            UIImageView * imgStar=[[UIImageView alloc]initWithFrame:CGRectMake(leftX+(starSize.width+5)*i, miny-10-starSize.height, starSize.width, starSize.height)];
            if (i<[_model.goodsStar intValue]) {
                imgStar.image=[UIImage imageNamed:@"星星新"];
            }else{
                imgStar.image=[UIImage imageNamed:@"空星新"];
            }
            [vc addSubview:imgStar];
        }
        UILabel * soldLb=[[UILabel alloc]init];
        [vc addSubview:soldLb];
        soldLb.x=leftX+(5+starSize.width)*4+starSize.width+15;
        soldLb.y=miny-7-13;
        soldLb.height=13;
        soldLb.width=150;
        soldLb.font=[UIFont boldSystemFontOfSize:12];
        soldLb.text=[NSString stringWithFormat:@"月售%@份",_model.soldNumber];
        soldLb.textColor=RGBColor(51, 51, 51);
        //价格
        UILabel * price=[[UILabel alloc]init];
        [vc addSubview:price];
        UIFont * font=[UIFont boldSystemFontOfSize:15];
        NSString * priceText=[NSString stringWithFormat:@"¥%@",_model.goodsCheapPrice];
        CGSize priceSize=[self sizeWithText:priceText font:font];
        price.y=miny-7-16;
        price.x=EPScreenW-leftX-priceSize.width;
        price.width=priceSize.width;
        price.height=16;
        price.text=priceText;
        price.textColor=RGBColor(255, 0, 0);
        price.font=[UIFont boldSystemFontOfSize:15];
        //随时退和过期退
        CGSize tuiSize=[UIImage imageNamed:@"选项"].size;
        UIFont * lbFont=[UIFont boldSystemFontOfSize:12];
        CGSize lbSize=[self sizeWithText:@"随时退" font:lbFont];
        UIImageView * img1=[[UIImageView alloc]init];
        img1.size=tuiSize;
        img1.x=25;
        img1.y=maxY+5;
        img1.image=[UIImage imageNamed:@"选项"];
        UILabel * lb=[[UILabel alloc]init];
        lb.font=lbFont;
        lb.textColor=RGBColor(255, 0, 0);
        lb.width=lbSize.width;
        lb.height=tuiSize.height;
        lb.x=CGRectGetMaxX(img1.frame)+10;
        lb.y=maxY+5;
        
        UIImageView * img2=[[UIImageView alloc]init];
        img2.size=tuiSize;
        img2.x=CGRectGetMaxX(lb.frame)+20;
        img2.y=maxY+5;
        img2.image=[UIImage imageNamed:@"选项"];
        UILabel * lb2=[[UILabel alloc]init];
        lb2.font=lbFont;
        lb2.textColor=RGBColor(255, 0, 0);
        lb2.width=lbSize.width;
        lb2.height=tuiSize.height;
        lb2.x=CGRectGetMaxX(img2.frame)+10;
        lb2.y=maxY+5;
        NSInteger anyTime=[_model.anyTime integerValue];
        NSInteger overTime=[_model.overTime integerValue];
        if (anyTime==1&&overTime==1) {
            [vc addSubview:img1];
            [vc addSubview:img2];
            lb.text=@"随时退";
            lb2.text=@"过期退";
            [vc addSubview:lb];
            [vc addSubview:lb2];
        }else if (anyTime==0&&overTime==1){
            [vc addSubview:img1];
             lb.text=@"过期退";
            [vc addSubview:lb];
        }else if (anyTime==1&&overTime==0){
            [vc addSubview:img1];
            lb.text=@"随时退";
            [vc addSubview:lb];
        }
    }
    if (indexPath.section==2) {
        UIView * line=[[UIView alloc]init];
        [cell.contentView addSubview:line];
        line.frame=CGRectMake(leftX, 34, EPScreenW-2*leftX, 1);
        line.backgroundColor=RGBColor(238, 238, 238);
        UILabel * shopName=[[UILabel alloc]init];
        [cell.contentView addSubview:shopName];
        shopName.frame=CGRectMake(leftX, 0, EPScreenW-2*leftX, 34);
        shopName.font=[UIFont boldSystemFontOfSize:15];
        shopName.textColor=RGBColor(0, 0, 0);
        shopName.text=_model.shopName;
        
        UIImage * imgAdd=[UIImage imageNamed:@"定位新"];
        CGSize addsize=imgAdd.size;
        UIImageView * imgAddress=[[UIImageView alloc]init];
        [cell.contentView addSubview:imgAddress];
        imgAddress.size=addsize;
        imgAddress.x=leftX;
        imgAddress.y=CGRectGetMaxY(line.frame)+(40-addsize.height)/2;
        imgAddress.image=imgAdd;
        
        UIButton * btnPhone=[UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:btnPhone];
        btnPhone.width=60;
        btnPhone.height=40;
        btnPhone.x=EPScreenW-60;
        btnPhone.y= CGRectGetMaxY(line.frame);
        [btnPhone setImage:[UIImage imageNamed:@"电话新"] forState:UIControlStateNormal];
        [btnPhone addTarget:self action:@selector(clickPhoneShopGoods) forControlEvents:UIControlEventTouchUpInside];
        UIView * verline=[[UIView alloc]init];
        [cell.contentView addSubview:verline];
        verline.backgroundColor=RGBColor(153, 153, 153);
        verline.frame=CGRectMake(btnPhone.x-1, CGRectGetMaxY(line.frame)+(40-25)/2, 1, 25);
        
        UILabel * addLb=[[UILabel alloc]init];
        [cell.contentView addSubview:addLb];
        addLb.width=EPScreenW-100;
        addLb.height=40;
        addLb.x=CGRectGetMaxX(imgAddress.frame)+9;
        addLb.y=CGRectGetMaxY(line.frame);
        addLb.font=[UIFont boldSystemFontOfSize:13];
        addLb.textColor=RGBColor(51, 51, 51);
        addLb.text=_model.address;
        addLb.numberOfLines=2;
    }
    if (indexPath.section==3) {
        if (_model.detailsRecord.count>0) {
            UILabel * lb1=[[UILabel alloc]init];
            [cell.contentView addSubview:lb1];
            lb1.x=leftX;
            lb1.y=8;
            lb1.font=[UIFont systemFontOfSize:14];
            lb1.textColor=RGBColor(51, 51, 51);
            lb1.numberOfLines=0;
            
            UILabel * lb2=[[UILabel alloc]init];
            [cell.contentView addSubview:lb2];
            lb2.y=8;
            lb2.height=15;
            lb2.font=[UIFont systemFontOfSize:14];
            lb2.textColor=RGBColor(51, 51, 51);
            lb2.textAlignment=NSTextAlignmentRight;
            
            if (indexPath.row<_model.detailsRecord.count) {
                NSDictionary * dict=_model.detailsRecord[indexPath.row];
                lb2.text=dict[@"value"];
                lb2.x=EPScreenW-leftX-40;
                lb2.width=40;
                lb1.width=EPScreenW-leftX-50;
                CGSize ss=[self sizeWithText:dict[@"label"] font:[UIFont systemFontOfSize:14] maxW:EPScreenW-leftX-50];
                lb1.height=ss.height;
                lb1.text=dict[@"label"];
                if (_model.detailsRecord.count==1) {
                    self.cell3Height1=CGRectGetMaxY(lb1.frame)+8;
                }else{
                    self.cell3Height1=CGRectGetMaxY(lb1.frame);
                }
            }else if(indexPath.row<_model.detailsRecord.count+_model.addRecord.count){
                NSDictionary * dict=_model.addRecord[indexPath.row-_model.detailsRecord.count];
                lb2.text=dict[@"value"];
                CGSize ss=[self sizeWithText:dict[@"label"] font:[UIFont systemFontOfSize:14]];
                lb1.height=ss.height;
                lb2.x=EPScreenW-leftX-100;
                lb2.width=100;
                lb1.width=EPScreenW-leftX-110;
                self.cell3Height2=CGRectGetMaxY(lb1.frame)+2;
                lb1.text=dict[@"label"];
            }else{
                UILabel * lb=[[UILabel alloc]init];
                [cell.contentView addSubview:lb];
                lb.frame=CGRectMake(leftX, 0, 250, 30);
                lb.text=@"更多图文详情";
                lb.font=[UIFont systemFontOfSize:15];
                lb.textColor=RGBColor(255, 0, 0);
                lb.userInteractionEnabled=YES;
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLbPhoneAnsmessage)];
                [lb addGestureRecognizer:tap];
            }
        }
    }
    if (indexPath.section==4) {
        //购买须知
        if (_model.record>0) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UILabel * lb1=[[UILabel alloc]init];
            [cell.contentView addSubview:lb1];
            lb1.font=[UIFont boldSystemFontOfSize:14];
            lb1.x=leftX;
            lb1.y=5;
            lb1.height=15;
            lb1.width=150;
            lb1.textColor=RGBColor(209, 176, 123);
            lb1.text=_model.record[indexPath.row][@"label"];
            
            UILabel * lb2=[[UILabel alloc]init];
            [cell.contentView addSubview:lb2];
            NSString * values=_model.record[indexPath.row][@"value"];
            lb2.attributedText = [self getAttributedStringWithString:values lineSpace:5];
            CGSize labelSize = [self sizeWithText:values font:[UIFont systemFontOfSize:14] maxW:EPScreenW-40];
            lb2.font=[UIFont systemFontOfSize:14];
            lb2.x=leftX;
            lb2.y=CGRectGetMaxY(lb1.frame)+5;
            if (labelSize.height>20) {
                lb2.height=labelSize.height+20;
            }else{
                lb2.height=labelSize.height+5;
            }
           // lb2.height=labelSize.height+5;
            lb2.width=EPScreenW-40;
            //lb2.text=[NSString stringWithFormat:@"%@",values];
            lb2.textColor=RGBColor(51, 51, 51);
            lb2.numberOfLines=0;
            if (indexPath.row==_model.record.count-1) {
                self.cellHeigh=CGRectGetMaxY(lb2.frame)+5;
            }else{
                self.cellHeigh = CGRectGetMaxY(lb2.frame);
            }
        }
    }
    if (indexPath.section==5) {
        if (self.commentArr.count>0) {
            EPGetCommentModel * model=[self.commentArr objectAtIndex:indexPath.row];
            UIImageView * head=[[UIImageView alloc]init];
            [cell.contentView addSubview:head];
            head.frame=CGRectMake(leftX, 20, 40, 40);
            head.layer.masksToBounds=YES;
            head.layer.cornerRadius=20;
            [head sd_setImageWithURL:[NSURL URLWithString:model.headImgAddress]];
            //
            UILabel * name=[[UILabel alloc]init];
            [cell.contentView addSubview:name];
            UIFont * font=[UIFont boldSystemFontOfSize:14];
            CGSize nameSize=[self sizeWithText:model.passengerName font:font];
            name.frame=CGRectMake(CGRectGetMaxX(head.frame)+10, 20, nameSize.width, 14);
            name.font=font;
            name.textColor=RGBColor(63, 41, 34);
            name.text=model.passengerName;
            CGSize starSize=[UIImage imageNamed:@"星星新"].size;
            for (int i=0; i<5; i++) {
                UIImageView * imgStar=[[UIImageView alloc]initWithFrame:CGRectMake(name.x+(starSize.width+5)*i, CGRectGetMaxY(name.frame)+7, starSize.width, starSize.height)];
                if (i<[model.commentStar intValue]) {
                    imgStar.image=[UIImage imageNamed:@"星星新"];
                }else{
                    imgStar.image=[UIImage imageNamed:@"空星新"];
                }
                [cell.contentView addSubview:imgStar];
            }
            UILabel * content=[[UILabel alloc]init];
            [cell.contentView addSubview:content];
            content.x=name.x;
            content.y=CGRectGetMaxY(head.frame)+3;
            content.width=EPScreenW-2*leftX-50;
            CGSize labelSize = [self sizeWithText:model.commentContent font:[UIFont systemFontOfSize:13] maxW:EPScreenW-2*leftX-50];
            content.attributedText = [self getAttributedStringWithString:model.commentContent lineSpace:5];
            if (labelSize.height>20) {
                content.height=labelSize.height+15;
            }else{
                content.height=labelSize.height+5;
            }
            content.font=[UIFont systemFontOfSize:13];
            content.text=model.commentContent;
            content.numberOfLines=0;
            
            UIView * line=[[UIView alloc]init];
            [cell.contentView addSubview:line];
            line.x=leftX;
            line.width=EPScreenW-leftX;
            line.height=1;
            line.backgroundColor=RGBColor(238, 238, 238);
            
            CGFloat maxYContent=CGRectGetMaxY(content.frame)+10;
            CGFloat imgWidth=60;
            CGFloat imgheight=60;
            UIImageView * img1=[[UIImageView alloc]init];
            img1.frame=CGRectMake(name.x, maxYContent, imgWidth, imgheight);
            
            UIImageView * img2=[[UIImageView alloc]init];
            img2.frame=CGRectMake(name.x+15+imgWidth, maxYContent, imgWidth, imgheight);
            
            UIImageView * img3=[[UIImageView alloc]init];
            img3.frame=CGRectMake(name.x+(15+imgWidth)*2, maxYContent, imgWidth, imgheight);
            
            if (model.commentImgArr==nil) {
                line.y=CGRectGetMaxY(content.frame)+5;
            }else{
                if (model.commentImgArr.count>0) {
                    NSDictionary * dict=[model.commentImgArr lastObject];
                    NSString * commentImg1=dict[@"commentImg1"];
                    NSString * commentImg2=dict[@"commentImg2"];
                    NSString * commentImg3=dict[@"commentImg3"];
                    if (commentImg2.length==0&&commentImg3.length==0) {
                        [cell.contentView addSubview:img1];
                        [img1 sd_setImageWithURL:[NSURL URLWithString:commentImg1]];
                    }else if (commentImg3.length==0){
                        [cell.contentView addSubview:img1];
                        [img1 sd_setImageWithURL:[NSURL URLWithString:commentImg1]];
                        [cell.contentView addSubview:img2];
                        [img2 sd_setImageWithURL:[NSURL URLWithString:commentImg2]];
                    }else{
                        [cell.contentView addSubview:img1];
                        [img1 sd_setImageWithURL:[NSURL URLWithString:commentImg1]];
                        [cell.contentView addSubview:img2];
                        [img2 sd_setImageWithURL:[NSURL URLWithString:commentImg2]];
                        [cell.contentView addSubview:img3];
                        [img3 sd_setImageWithURL:[NSURL URLWithString:commentImg3]];
                    }
                }
                line.y=CGRectGetMaxY(img1.frame)+15;
            }
            self.cell5Heigh=CGRectGetMaxY(line.frame);
            
            
            
            UILabel * time=[[UILabel alloc]init];
            [cell.contentView addSubview:time];
            time.font=[UIFont boldSystemFontOfSize:13];
            NSString * timeStr=[model.commentTime substringToIndex:16];
            CGSize timeSize=[self sizeWithText:timeStr font:time.font];
            time.size=timeSize;
            time.x=EPScreenW-leftX-timeSize.width;
            time.y=25;
            time.textColor=RGBColor(51, 51, 51);
            time.text=timeStr;
            
            
        }
    }
    return cell;
}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * vc=[[UIView alloc]init];
    vc.backgroundColor=[UIColor whiteColor];
    vc.frame=CGRectMake(0, 0, EPScreenW, 36);
    UIView * line=[[UIView alloc]init];
    line.frame=CGRectMake(15, 35, EPScreenW-30, 1);
    line.backgroundColor=RGBColor(153, 153, 153);
    [vc addSubview:line];
    UILabel * lb=[[UILabel alloc]init];
    [vc addSubview:lb];
    lb.frame=CGRectMake(15,15,70, 15);
    lb.font=[UIFont boldSystemFontOfSize:15];
    lb.textColor=RGBColor(51, 51, 51);
    UIView * verLine=[[UIView alloc]init];
    [vc addSubview:verLine];
    verLine.frame=CGRectMake(CGRectGetMaxX(lb.frame)+7, 15, 1, 15);
    verLine.backgroundColor=RGBColor(51, 51, 51);
    UILabel * engLb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verLine.frame)+7, 15, 300, 15)];
    [vc addSubview:engLb];
    engLb.font=[UIFont systemFontOfSize:13];
    engLb.textColor=RGBColor(51, 51, 51);
    if (section==2) {
        lb.text=@"商家详情";
        engLb.text=@"Business details";
        CGSize moreSize=[UIImage imageNamed:@"更多"].size;
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [vc addSubview:btn];
        btn.frame=CGRectMake(EPScreenW-30-moreSize.width,7, 30+moreSize.width, 30);
        [btn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [btn  addTarget:self action:@selector(clickToShopDetail) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (section==3) {
        lb.text=@"套餐详情";
        engLb.text=@"Package details";
    }
    if (section==4) {
        lb.text=@"购买须知";
        engLb.text=@"Purchase information";
    }
    if (section==5) {
        lb.text=@"用户评价";
        engLb.text=@"The user evaluation";
    }
    return vc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return HEIGHT(153.0, 667);
    }
    if (indexPath.section==1) {
        return 115;
    }
    if (indexPath.section==2) {
        return 74;
    }
    if (indexPath.section==3) {
//        if(indexPath.row>=_model.detailsRecord.count+_model.addRecord.count){
//            return 30;
//        }else{
//            return self.cell3Height;
//        }
        if (indexPath.row<_model.detailsRecord.count) {
            return self.cell3Height1;
        }else if(indexPath.row<_model.detailsRecord.count+_model.addRecord.count){
            return self.cell3Height2;
        }else{
            return 30;
        }
    }
    if (indexPath.section==4) {
        return self.cellHeigh;
    }
    return self.cell5Heigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 36;
    }
    if (section==3) {
        if (_model.detailsRecord.count>0) {
            return 36;
        }else{
            return 0;
        }
    }
    if (section==4) {
        if (_model.record.count>0) {
            return 36;
        }else{
            return 0;
        }
    }
    if (section==5) {
        if (self.commentArr.count>0) {
            return 36;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    if (section==1) {
        return 8;
    }
    if (section==2) {
        if (_model.detailsRecord.count==0) {
            return 0;
        }else{
            return 8;
        }
    }
    if (section==3) {
        if (_model.record.count==0) {
            return 0;
        }else{
            return 8;
        }
    }
    if (section==4) {
        if (self.commentArr.count==0) {
            return 0;
        }else{
            return 8;
        }
    }else{
        return 0;
    }
}
- (void)addTableFooter{
    UIView * vc=[[UIView alloc]init];
    vc.userInteractionEnabled=YES;
    vc.frame=CGRectMake(0, 0, EPScreenW, 40);
    vc.backgroundColor=[UIColor whiteColor];
    UILabel * lb=[[UILabel alloc]init];
    [vc addSubview:lb];
    lb.frame=CGRectMake(15, 0, EPScreenW-30,40 );
    lb.font=[UIFont boldSystemFontOfSize:14];
    lb.textColor=RGBColor(0, 0, 0);
    lb.text=@"查看全部网友点评>";
    lb.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtnMorecomments)];
    [lb addGestureRecognizer:tap];
    self.tb.tableFooterView=vc;
}
- (void)clickBtnMorecomments{
    EPMoreCommentVC * vc=[[EPMoreCommentVC alloc]init];
    vc.count=self.commentArr.count;
    vc.goodsId=self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat sectionHeaderHeight = 30;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}
- (UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, EPScreenW, EPScreenH-64-49) style:UITableViewStylePlain];
        _tb.backgroundColor=RGBColor(238, 238, 238);
        _tb.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tb.bounces=YES;
        _tb.delegate=self;
        _tb.dataSource=self;
        [self.view addSubview:_tb];
    }
    return _tb;
}
- (NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [[NSMutableArray alloc] init];
    }
    return _commentArr;
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
