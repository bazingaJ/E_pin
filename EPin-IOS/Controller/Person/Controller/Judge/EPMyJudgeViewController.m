//
//  EPMyJudgeViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/4/8.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMyJudgeViewController.h"
#import "HeaderFile.h"
#import "EPDetailModel.h"
#import "EPMyOrderVC.h"
@interface EPMyJudgeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**数组*/
@property(nonatomic,strong)NSMutableArray * dataSource;

@property(nonatomic,assign)CGFloat cellHeight;

@end

@implementation EPMyJudgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource=[[NSMutableArray alloc]init];
    [self addNavigationBar:0 title:@"我的评论"];
    self.tableVi.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableVi.hidden=YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (LOGINTIME==nil) {
        [self noDissussView];
    }else{
        [self getData];
    }
}
- (void)noDissussView{
    self.tableVi.hidden=YES;
    self.view.backgroundColor=RGBColor(234, 234, 234);
    UIImageView * img=[[UIImageView alloc]init];
    img.width=120;
    img.height=120;
    img.y=180;
    img.x=EPScreenW/2-60;
    img.image=[UIImage imageNamed:@"no_discuss"];
    img.layer.masksToBounds=YES;
    img.layer.cornerRadius=60;
    [self.view addSubview:img];
    UILabel * lb=[[UILabel alloc]init];
    lb.x=0;
    lb.y=CGRectGetMaxY(img.frame)+16;
    lb.width=EPScreenW;
    lb.height=21;
    lb.font=[UIFont systemFontOfSize:12];
    lb.text=@"您还没有评论过任何商品";
    lb.textColor=RGBColor(162, 162, 162);
    lb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lb];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=RGBColor(0, 137, 242);
    btn.width=156;
    btn.height=49;
    btn.x=EPScreenW/2-78;
    btn.y=CGRectGetMaxY(lb.frame)+15;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5.0;
    [btn setTitle:@"去评论" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtnComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clickBtnComment{
    EPMyOrderVC * vc=[[EPMyOrderVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**请求数据*/
- (void)getData{
    [self.dataSource removeAllObjects];
    NSString * str =[NSString stringWithFormat:@"%@/getMyCommentInfo.json",EPUrl];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime", nil];
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager GET:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取所有商品评论======%@",responseObject);
        NSString * returnCode=responseObject[@"returnCode"];
        if ([returnCode integerValue]==0) {
            NSArray * recommentArr=responseObject[@"commentArr"];
            if (recommentArr.count==0) {
                [self noDissussView];
            }else{
                self.tableVi.hidden=NO;
                for (NSDictionary * dict in recommentArr) {
                    EPGetCommentModel * model=[EPGetCommentModel mj_objectWithKeyValues:dict];
                    [self.dataSource addObject:model];
                }
                [self.tableVi reloadData];
            }
        }else if ([returnCode integerValue]==2){
            NSString * msg=[responseObject objectForKey:@"msg"];
            [EPLoginViewController publicDeleteInfo];
            EPLoginViewController * vc=[[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [self presentViewController:vc animated:YES completion:nil];
            }];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，数据获取失败，请稍后重试" count:0 doWhat:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark- UITable View DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataSource.count>0) {
        EPGetCommentModel * model=[self.dataSource objectAtIndex:indexPath.row];
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.backgroundColor=[UIColor whiteColor];
        vc.width=EPScreenW;
        vc.x=0;
        vc.y=0;
        UIImageView * goodImg=[[UIImageView alloc]init];
        [vc addSubview:goodImg];
        goodImg.frame=CGRectMake(15,15, 80, 50);
        [goodImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];
        
        CGFloat leftX=CGRectGetMaxX(goodImg.frame)+15;
        UILabel * goodNameLb=[[UILabel alloc]init];
        [vc addSubview:goodNameLb];
        goodNameLb.x=leftX;
        goodNameLb.y=goodImg.y;
        goodNameLb.height=15;
        goodNameLb.width=EPScreenW-leftX-15;
        goodNameLb.font=[UIFont systemFontOfSize:15];
        goodNameLb.textColor=RGBColor(51, 51, 51);
        goodNameLb.text=model.goodsName;
        //星级
        CGSize starSize=[UIImage imageNamed:@"星星新"].size;
        for (int i=0; i<5; i++) {
            UIImageView * imgStar=[[UIImageView alloc]initWithFrame:CGRectMake(leftX+(starSize.width+5)*i, CGRectGetMaxY(goodNameLb.frame)+10, starSize.width, starSize.height)];
            if (i<[model.commentStar integerValue]) {
                imgStar.image=[UIImage imageNamed:@"星星新"];
            }else{
                imgStar.image=[UIImage imageNamed:@"空星新"];
            }
            [vc addSubview:imgStar];
        }
        UILabel * content=[[UILabel alloc]init];
        [vc addSubview:content];
        content.x=leftX;
        content.y=CGRectGetMaxY(goodImg.frame)+10;
        content.width=EPScreenW-leftX-15;
        content.text=model.commentContent;
        CGSize ss=[self sizeWithText:model.commentContent font:[UIFont systemFontOfSize:12]];
        content.height=ss.height;
        content.font=[UIFont systemFontOfSize:12];
        content.textColor=RGBColor(51, 51, 51);
        
        UILabel * time=[[UILabel alloc]init];
        [vc addSubview:time];
        time.width=150;
        time.x=EPScreenW-15-150;
        time.y=CGRectGetMaxY(goodImg.frame)-13;
        time.height=13;
        time.font=[UIFont systemFontOfSize:13];
        time.textColor=RGBColor(51, 51, 51);
        time.textAlignment=NSTextAlignmentRight;
        NSString * timeStr=[model.commentTime substringToIndex:10];
        time.text=timeStr;
        
        CGFloat maxYContent=CGRectGetMaxY(content.frame)+10;
        CGFloat imgWidth=60;
        CGFloat imgheight=60;
        UIImageView * img1=[[UIImageView alloc]init];
        img1.frame=CGRectMake(leftX, maxYContent, imgWidth, imgheight);
        img1.layer.masksToBounds=YES;
        img1.layer.cornerRadius=5;
        
        UIImageView * img2=[[UIImageView alloc]init];
        img2.frame=CGRectMake(leftX+10+imgWidth, maxYContent, imgWidth, imgheight);
        img2.layer.masksToBounds=YES;
        img2.layer.cornerRadius=5;
        
        UIImageView * img3=[[UIImageView alloc]init];
        img3.frame=CGRectMake(leftX+(10+imgWidth)*2, maxYContent, imgWidth, imgheight);
        img3.layer.masksToBounds=YES;
        img3.layer.cornerRadius=5;
        
        if (model.commentImgArr==nil) {
            vc.height=CGRectGetMaxY(content.frame)+5;
            self.cellHeight=vc.height+5;
        }else{
            if (model.commentImgArr.count>0) {
                NSDictionary * dict=[model.commentImgArr lastObject];
                NSString * commentImg1=dict[@"commentImg1"];
                NSString * commentImg2=dict[@"commentImg2"];
                NSString * commentImg3=dict[@"commentImg3"];
                if (commentImg2.length==0&&commentImg3.length==0) {
                    [vc addSubview:img1];
                    [img1 sd_setImageWithURL:[NSURL URLWithString:commentImg1]];
                }else if (commentImg3.length==0){
                    [vc addSubview:img1];
                    [img1 sd_setImageWithURL:[NSURL URLWithString:commentImg1]];
                    [vc addSubview:img2];
                    [img2 sd_setImageWithURL:[NSURL URLWithString:commentImg2]];
                }else{
                    [vc addSubview:img1];
                    [img1 sd_setImageWithURL:[NSURL URLWithString:commentImg1]];
                    [vc addSubview:img2];
                    [img2 sd_setImageWithURL:[NSURL URLWithString:commentImg2]];
                    [vc addSubview:img3];
                    [img3 sd_setImageWithURL:[NSURL URLWithString:commentImg3]];
                }
            }
            vc.height=CGRectGetMaxY(img1.frame)+15;
            self.cellHeight=vc.height+5;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
