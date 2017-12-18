//
//  PeccancyDealViewC.m
//  eTaxi-iOS
//
//  Created by jeader on 16/2/16.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "PeccancyDealViewC.h"
#import "PeccCell.h"
#import "MBProgressHUD.h"
#import "EPTool.h"
#import "HeaderFile.h"
#import "EPData.h"
#import "HeaderFile.h"
#import "JDPeccancyViewController.h"
#import "EPLoginViewController.h"
@interface PeccancyDealViewC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic, strong) NSMutableArray * getArr;
@property (nonatomic, strong) NSString * fineMoney;
@property (nonatomic, strong) NSString * codeStr;
@property (nonatomic, strong) NSMutableArray * idArr;
@property (nonatomic, strong) NSMutableArray * endArr;
@end

@implementation PeccancyDealViewC

- (instancetype)initWithDataArr:(NSMutableArray *)arr withMoneyStr:(NSString *)money withCode:(NSString *)codeStr;
{
    if (self=[super init])
    {
        self.getArr=arr;
        self.codeStr=codeStr;
        self.fineMoney=money;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableVi.scrollEnabled=NO;
    [self addNavigationBar:0 title:@"违章处理"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID1 =@"cell1";
    static NSString * cellID2 =@"cell6";
    PeccCell * cell =nil;
    if (indexPath.row == 0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"PeccCell" owner:nil options:nil]objectAtIndex:5];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.pointLab.tag=10086;
        if (TOTALSCORE)
        {
            cell.pointLab.font=[UIFont systemFontOfSize:50];
            NSString * trans =[NSString stringWithFormat:@"%@",TOTALSCORE];
            NSString * pointStr =[NSString stringWithFormat:@"%@积分",trans];
            NSMutableAttributedString * noteStr =[[NSMutableAttributedString alloc]initWithString:pointStr];
            NSRange fontRange =NSMakeRange([[noteStr string]rangeOfString:@"积分"].location, [[noteStr string]rangeOfString:@"积分"].length);
            NSDictionary * attributeDic =[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
            [noteStr addAttributes:attributeDic range:fontRange];
            [cell.pointLab setAttributedText:noteStr];
        }
        else
        {
            cell.pointLab.text=@"0";
        }
        return cell;
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"PeccCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==1)
        {
            cell.dateLab.text=@"罚款金额";
            NSString * fineStr =[NSString stringWithFormat:@"%@元",self.fineMoney];
            cell.whoLab.text=fineStr;
        }
        else
        {
            cell.dateLab.text=@"积分抵扣";
            NSString * pointStr =[NSString stringWithFormat:@"%d积分",[self.fineMoney intValue]*10];
            cell.whoLab.text=pointStr;
            cell.whoLab.textColor=[UIColor colorWithRed:209/255.0 green:10/255.0 blue:22/255.0 alpha:1.0];
        }
        return cell;
    }
    
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableVi respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableVi setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableVi respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableVi setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 104;
    }
    else
    {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row==0)
//    {
//        JDMyPointViewController * vc =[[JDMyPointViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc addNavigationBar:@"我的积分"];
//    }
}
- (IBAction)dealBtnClick:(id)sender
{
    //我的所剩积分
    int left = [TOTALSCORE intValue];
    //罚款金额
    int fine = [self.fineMoney intValue]*10;
    
    //r如果是积分不够的情况
    if (left <fine)
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您的剩余积分不足" count:0 doWhat:^{
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }];
    }
    //如果是积分足够
    else
    {
        NSString * money =[NSString stringWithFormat:@"%d",fine];
        NSMutableString * violations=[NSMutableString stringWithString:@""];
        if (self.getArr.count==0)
        {
            NSString * str =[NSString stringWithFormat:@"%@",self.IDStr];
            NSLog(@"aaaaaaaaaa%@",self.IDStr);
            [violations appendString:str];
        }
        else
        {
            for (NSNumber * num in self.getArr)
            {
                NSString * str =[NSString stringWithFormat:@"%@,",num];
                [violations appendString:str];
            }
        }
        
        
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@"处理提交中"];
        
        EPData *data = [EPData new];
        [data getSubmitePeccInfoWithSpendPoint:money withViolations:violations withCompletionBlock:^(NSString *returnCode, NSString *msg) {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            if ([returnCode intValue]==0)
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"违章处理已受理,请您在七个工作日内查询结果" count:1 doWhat:^{
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }];
            }
            else if ([returnCode intValue]==1)
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
                    
                    
                }];
            }
            else if ([returnCode intValue]==2)
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
                    [EPLoginViewController publicDeleteInfo];
                }];
            }
            else
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络链接失败,请重试" count:1 doWhat:^{
                    
                }];
            }
        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
