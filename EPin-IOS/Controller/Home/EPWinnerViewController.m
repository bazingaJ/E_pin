//
//  EPWinnerViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/7/17.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPWinnerViewController.h"
#import "HeaderFile.h"
#import "EPEpaiModel.h"
@interface EPWinnerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tb;

@property(nonatomic,strong)NSMutableArray * winnerArr;

@end

@implementation EPWinnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavigationBar:0 title:@"得主风采"];
    self.tb.delegate=self;
    self.tb.dataSource=self;
}
- (void)wuHiddenView{
    self.view.backgroundColor=RGBColor(234, 234, 234);
    UILabel * lb=[[UILabel alloc]init];
    lb.frame=CGRectMake(0, EPScreenH/2, EPScreenW, 20);
    lb.textAlignment=NSTextAlignmentCenter;
    lb.text=@"活动还在进行中，敬请期待";
    lb.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:lb];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.winnerArr removeAllObjects];
    EPData * data=[EPData new];
    [data getAuctionDataWithType:@"5" withGoodsId:nil withOrderId:nil Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        NSLog(@"得主风采----%@",dic);
        if ([returnCode intValue]==0) {
            NSArray * finishAucitionArr=dic[@"finishAucitionArr"];
            for (NSDictionary * dict in finishAucitionArr) {
                EPWinnerModel * model=[EPWinnerModel mj_objectWithKeyValues:dict];
                [self.winnerArr addObject:model];
            }
            if (self.winnerArr.count==0) {
                [self wuHiddenView];
            }else{
                [self.tb reloadData];
            }
        }
    }];
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attri  =[NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    CGSize maxSize =CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,2)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(2,needText.length-2)];
    
    return attrString;
}
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.winnerArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    EPWinnerModel * model=[self.winnerArr objectAtIndex:indexPath.section];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        CGFloat fw=EPScreenW-24;
        UIView * back=[[UIView alloc]init];
        back.frame=CGRectMake(12,0, fw,250);
        [cell.contentView addSubview:back];
        
        UIView * gray=[[UIView alloc]init];
        gray.frame=CGRectMake(0,0, fw,32);
        gray.backgroundColor=RGBColor(0, 0, 0);
        gray.alpha=0.5;
        [back addSubview:gray];
        
        UILabel * endTime=[[UILabel alloc]init];
        endTime.frame=CGRectMake(20, 0, fw-20, 32);
        endTime.font=[UIFont boldSystemFontOfSize:12];
        endTime.text=model.time;
        endTime.textColor=[UIColor whiteColor];
        [gray addSubview:endTime];
        
        UIImageView * img=[[UIImageView alloc]init];
        img.frame=CGRectMake(0,CGRectGetMaxY(gray.frame),fw, 148);
        [img sd_setImageWithURL:[NSURL URLWithString:model.winingImg]];
        [back addSubview:img];
        
        UIView * white=[[UIView alloc]init];
        white.frame=CGRectMake(0,CGRectGetMaxY(img.frame),fw,60);
        [back addSubview:white];
        
        UILabel * name=[[UILabel alloc]init];
        name.frame=CGRectMake(0,8,fw,16);
        name.font=[UIFont systemFontOfSize:15];
        name.text=model.goodsName;
        name.textColor=RGBColor(50, 50, 50);
        [white addSubview:name];
        
        UILabel * winner=[[UILabel alloc]init];
        winner.frame=CGRectMake(0,CGRectGetMaxY(name.frame)+8,fw,13);
        winner.font=[UIFont systemFontOfSize:12];
        winner.text=@"获奖人:201666666";
        winner.textColor=RGBColor(63,63,63);
        [white addSubview:winner];
        
        UILabel * time=[[UILabel alloc]init];
        time.font=[UIFont boldSystemFontOfSize:10];
        NSArray * tmArr=[model.time componentsSeparatedByString:@"-"];
        time.text=[NSString stringWithFormat:@"获奖时间:%@",tmArr[1]];
        time.textColor=RGBColor(147,147,147);
        CGSize ss=[self sizeWithText:time.text font:[UIFont boldSystemFontOfSize:10] maxW:300];
        time.width=ss.width+14;
        time.height=ss.height;
        time.y=CGRectGetMaxY(winner.frame)+8;
        time.x=(fw-time.width)/2;
        time.textAlignment=NSTextAlignmentCenter;
        [white addSubview:time];
        
        CGFloat y=CGRectGetMinY(time.frame)+time.height/2;
        UILabel * line1=[[UILabel alloc]init];
        line1.frame=CGRectMake(0,y, (fw-time.width)/2, 1);
        line1.backgroundColor=RGBColor(223, 223, 223);
        [white addSubview:line1];
        
        UILabel * line2=[[UILabel alloc]init];
        line2.frame=CGRectMake(CGRectGetMaxX(time.frame),y, (fw-time.width)/2, 1);
        line2.backgroundColor=RGBColor(223, 223, 223);
        [white addSubview:line2];
        
        UILabel * price=[[UILabel alloc]init];
        price.text=[NSString stringWithFormat:@"半价 %@",model.goodsClapPrice];
        price.textAlignment=NSTextAlignmentRight;
        price.textColor=RGBColor(235, 54, 42);
        CGSize s=[self sizeWithText:price.text font:[UIFont boldSystemFontOfSize:25]];
        price.x=fw-s.width;
        price.y=y-8-s.height;
        price.width=s.width;
        price.height=s.height;
        [price setAttributedText:[self changeLabelWithText:price.text]];
        [white addSubview:price];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 8;
    }else{
        return 24;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * white=[[UIView alloc]init];
    if (section==0) {
        white.frame=CGRectMake(0,0,EPScreenW,8);
    }else{
        white.frame=CGRectMake(0,0,EPScreenW,24);
    }
    white.backgroundColor=[UIColor whiteColor];
    return white;
}
- (NSMutableArray *)winnerArr{
    if (!_winnerArr) {
        _winnerArr=[[NSMutableArray alloc]init];
    }
    return _winnerArr;
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
