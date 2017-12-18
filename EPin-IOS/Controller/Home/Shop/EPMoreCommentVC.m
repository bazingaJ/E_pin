//
//  EPMoreCommentVC.m
//  EPin-IOS
//
//  Created by jeaderL on 16/5/9.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMoreCommentVC.h"
#import "HeaderFile.h"
#import "EPDetailModel.h"
@interface EPMoreCommentVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tb;

@property(nonatomic,assign)CGFloat cell5Heigh;

@end

@implementation EPMoreCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString * title=[NSString stringWithFormat:@"评价(%lu)",(long)self.count];
    [self addNavigationBar:0 title:title];
    self.tb.dataSource=self;
    self.tb.delegate=self;
    self.tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tb.backgroundColor=RGBColor(238, 238, 238);
    
}
- (void)getCommentData{
    [self.commentArr removeAllObjects];
    NSString * str =[NSString stringWithFormat:@"%@/getMyCommentInfo.json",EPUrl];
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId" ,nil];
    [manager GET:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"更多评论======%@",responseObject);
        NSString * returncode=responseObject[@"returnCode"];
        if ([returncode integerValue]==0) {
            NSArray * commentArr=responseObject[@"commentArr"];
            for (NSDictionary * dict in commentArr) {
                EPGetCommentModel * model=[EPGetCommentModel mj_objectWithKeyValues:dict];
                [self.commentArr addObject:model];
            }
             [self.tb reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        self.tb.hidden=YES;
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCommentData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat leftX=15;
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
        line.frame=CGRectMake(leftX,CGRectGetMaxY(content.frame)+5, EPScreenW-leftX, 1);
        line.backgroundColor=RGBColor(234, 234, 234);
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
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cell5Heigh;
}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}
- (NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr=[[NSMutableArray alloc]init];
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
