//
//  JDPeccancyViewController.m
//  eTaxi-iOS
//
//  Created by jeader on 16/5/19.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import "JDPeccancyViewController.h"

#import "HeaderFile.h"
#import "JDPeccancyShowCell.h"

#import "JDPeccancyHttpTool.h"
#import "JDPeccancyData.h"  
#import "CYFMDBuse.h"
#import "EPData.h"
#import "PeccancyDealViewC.h"
#import "PeccancyDetailViewC.h"
#import "MHActionSheet.h"
#import "JDNoMessageView.h"
#import "EPAddInfoVC.h"
#import "EPTool.h"
#import "JDPeccancyTopView.h"
@interface JDPeccancyViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  接收模的型数组
 */
@property (nonatomic, strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  放 要处理的违章信息id的数组
 */
@property (nonatomic, strong) NSMutableArray *idArr;
/**
 *  存放已经选中过的按钮，
 */
@property (nonatomic, strong) NSMutableArray *btnArr;
/**
 *  选中的违章的总金额
 */
@property (nonatomic, assign) CGFloat moneys;
//车牌号
@property (weak, nonatomic) IBOutlet UILabel *licensePlate;
/**
 *  没有消息的界面
 */
@property (nonatomic, strong) JDNoMessageView *nomessV;
@property (weak, nonatomic) IBOutlet UILabel *gengHuanCar;
@property (weak, nonatomic) IBOutlet UILabel *line;

//车牌号数组
@property (nonatomic, strong) NSArray *plateArr;
@property (nonatomic, strong) NSMutableArray *engineArr;
@property (weak, nonatomic) IBOutlet UILabel *bindL;

@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@property (weak, nonatomic) IBOutlet UIButton *redBtn;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *selectSource;
@end

@implementation JDPeccancyViewController

-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
-(NSMutableArray *)idArr
{
    if (_idArr == nil) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

-(NSMutableArray *)modelArr
{
    if (_modelArr==nil) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}
// 显示table view 还是显示 no message view
-(void)chooseTableViewOrNoMessView:(NSInteger)count
{
    if (count==0) {
        self.tableView.hidden = YES;
        self.nomessV.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        self.nomessV.hidden = YES;
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _moneys = 0;
    [self addNavigationBar:0 title:@"违章查询"];
    
    if (!PHONENO) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        JDPeccancyTopView *topView = [self.view viewWithTag:1321];
        [topView selectBtnIndex:0];
        
        [self getCarData];
    }
    

    [self setUpTopView];
}
-(void)getDateWithlicenseNo:(NSString *)licenseNo engineNo:(NSString *)engineNo{
    
    [JDPeccancyHttpTool peccancyGetDataInVc:self licenseNo:licenseNo engineNo:engineNo Success:^{
        
        [self.modelArr removeAllObjects];
        
        NSArray *modelArr = [JDPeccancyHttpTool peccancyDataType:JDPeccancyDataTypeTotal];
        
        [self.modelArr addObjectsFromArray:modelArr];
        
        [self.tableView reloadData];
        [self chooseTableViewOrNoMessView:self.modelArr.count];
        
    } failure:^(NSError *error) {
        
    }];

}
//没有绑定车辆时点击绑定按钮的跳转
- (IBAction)bindCar:(UIButton *)sender {
    EPAddInfoVC *addIn = [EPAddInfoVC new];
    [self.navigationController pushViewController:addIn animated:YES];
}
//点击更换车辆
- (IBAction)ReplacementCar:(UIButton *)sender {
    EPData *data = [EPData new];
    [data bindCarMessageWithType:@"1" withPlateNo:nil withEnineNo:nil withCarNo:nil withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==1) {
            
        }else if ([returnCode intValue]==0){
            MHActionSheet *actionSheet = [[MHActionSheet alloc] initSheetWithTitle:@"车辆选择" style:MHSheetStyleWeiChat itemTitles:self.plateArr];
            actionSheet.cancleTitle = @"取消";
            [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
                self.licensePlate.text = [NSString stringWithFormat:@"当前车辆    %@",title];
                [self getDateWithlicenseNo:title engineNo:self.engineArr[index]];
                NSString *text = [NSString stringWithFormat:@"第%ld行,%@",index, title];
            }];
        }
    }];
}
//头视图
-(void)setUpTopView
{
    JDPeccancyTopView *topView = [[JDPeccancyTopView alloc] initWithFrame:CGRectMake(0, 0, EPScreenSize.width, 60)];
    topView.nameArr = @[@"全部违章",@"正在处理",@"处理完成"];
    [topView selectBtnIndex:0];
    topView.tag = 1321;
    [topView peccancyBtnClick:^(NSInteger index) {
      
        // 移除原数组的所有模型
        [self.modelArr removeAllObjects];
        
        if (index == 0) { // 全部的违章
            [self.modelArr addObjectsFromArray:[JDPeccancyHttpTool peccancyDataType:JDPeccancyDataTypeTotal]];
            
            
        }else if (index == 1) { // 正在处理中的违章
            [self.modelArr addObjectsFromArray:[JDPeccancyHttpTool peccancyDataType:JDPeccancyDataTypeProcessing]];
        }else { // 处理完成的违章
            [self.modelArr addObjectsFromArray:[JDPeccancyHttpTool peccancyDataType:JDPeccancyDataTypeComplete]];
        }
        if ([self.licensePlate.text isEqualToString:@"暂无车辆"]) {
            [self.modelArr removeAllObjects];
        }
        [self chooseTableViewOrNoMessView:self.modelArr.count];
    }];
    [_topView addSubview:topView];
    [self getCarData];
}
-(void)getCarData{
    //获取当前车辆数据
    EPData *data = [EPData new];
    [data bindCarMessageWithType:@"1" withPlateNo:nil withEnineNo:nil withCarNo:nil withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0) {
            NSMutableArray * carArr =dic[@"PassengerCarArr"];
            NSMutableArray *plateArr = [NSMutableArray array];
            NSMutableArray *engineNoArr = [NSMutableArray array];
            for (NSDictionary *plateNo in carArr) {
                [plateArr addObject:plateNo[@"plateNo"]];
                [engineNoArr addObject:plateNo[@"engineNo"]];
            }
            _plateArr = plateArr;
            _engineArr = engineNoArr;
            if (plateArr.count>0) {
                self.bindL.hidden = YES;
                self.bindBtn.hidden = YES;
                self.licensePlate.text = [NSString stringWithFormat:@"当前车辆    %@",plateArr[0]];
                [self getDateWithlicenseNo:plateArr[0] engineNo:engineNoArr[0]];
                if (plateArr.count ==1) {
                    self.gengHuanCar.hidden=YES;
                    self.line.hidden = YES;
                    self.redBtn.hidden = NO;
                }else{
                    self.gengHuanCar.hidden=NO;
                    self.line.hidden = NO;
                    self.redBtn.hidden = NO;
                }
            }else{
                self.bindL.hidden = NO;
                self.bindBtn.hidden = NO;
            }
        }else if ([returnCode intValue]==1){
            
            self.licensePlate.text = [NSString stringWithFormat:@"暂无车辆"];
            self.gengHuanCar.hidden = YES;
            self.line.hidden = YES;
            
            [self chooseTableViewOrNoMessView:self.modelArr.count];
            self.redBtn.hidden = YES;
        }else if([returnCode intValue]==2){
            self.licensePlate.text= @"暂无信息";
            self.gengHuanCar.hidden= YES;
            self.line.hidden = YES;
            self.redBtn.hidden = YES;
            [EPTool addAlertViewInView:self title:@"温馨提示" message:[NSString stringWithFormat:@"%@",msg] count:0 doWhat:^{
                [EPLoginViewController publicDeleteInfo];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];

}
// 点击处理
- (IBAction)clickDealwith:(id)sender {
    
    
    if (!self.idArr.count) { // 未选择违章
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您还没有选择任何违章记录" count:0 doWhat:nil];
    }else{
        
        PeccancyDealViewC *dealVc = [[PeccancyDealViewC alloc] initWithDataArr:self.idArr withMoneyStr:[NSString stringWithFormat:@"%f",_moneys] withCode:nil];
        
        [self.navigationController pushViewController:dealVc animated:YES];
        
    }
    
    
}

#pragma mark - table view datasource & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JDPeccancyData *peccData = self.modelArr[indexPath.row];
    
    JDPeccancyShowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"JDPeccancyShowCell" owner:nil options:nil][0];
        cell.selectionStyle = 0;
        cell.peccName.text = peccData.info;
        cell.peccMoney.text = peccData.money;
        cell.peccScore.text = [NSString stringWithFormat:@"扣%@分",peccData.fen];
        cell.peccTime.text = peccData.occur_date;
    
    if ([peccData.fen intValue]) { // 有扣分
        
        [self setBtn:cell.peccStatus AndImageV:cell.peccImage titleColor:RGBColor(128, 128, 128) hidden:YES edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) title:@"已扣分" imageName:nil];
        
    }else{
        NSLog(@"11111%@",peccData.result);
        if ([peccData.result isEqualToString:@"未处理"]) { // 未处理的记录
            
            [self setBtn:cell.peccStatus AndImageV:cell.peccImage titleColor:RGBColor(255, 65, 65) hidden:NO edgeInsets:UIEdgeInsetsMake(0, 0, 20, 0) title:@"未处理" imageName:@"wzcx_未选中1"];
            cell.peccStatus.tag = indexPath.row;
            cell.peccStatus.selected = NO;
            [cell.peccStatus addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            // 遍历数组取出按钮，
            for (NSNumber *num in self.btnArr) {
                
                if (indexPath.row == [num integerValue]) {
                    
                    cell.peccImage.image = [UIImage imageNamed:@"wzcx_选中2"];
                    cell.peccStatus.selected = YES;
                    
                }
            }
        }else if ([peccData.result isEqualToString:@"处理中"]) { // 处理中
            
            [self setBtn:cell.peccStatus AndImageV:cell.peccImage titleColor:RGBColor(37, 129, 233) hidden:YES edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) title:@"处理中" imageName:nil];
            
        }else { // 已完成
            
            [self setBtn:cell.peccStatus AndImageV:cell.peccImage titleColor:RGBColor(178, 178, 178) hidden:YES edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) title:@"已完成" imageName:nil];
            
        }
    }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDPeccancyData *data =self.modelArr[indexPath.row];
    NSString *area=data.occur_area;
    
    PeccancyDetailViewC * vc_ =[[PeccancyDetailViewC alloc]initWithArr:self.modelArr WithCode:indexPath.row withAddress:area];
    if ([data.fen intValue]==0)
    {
        vc_.moneyStr=data.money;
        
    }
    else
    {
        vc_.moneyStr=@"0";
    }
    [self.navigationController pushViewController:vc_ animated:YES];
    [vc_ addNavigationBar:0 title:@"违章详情"];
}

#pragma mark - 处理状态按钮点击事件
-(void)clickSelectBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    JDPeccancyShowCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    JDPeccancyData *data = self.modelArr[sender.tag];
    NSNumber *num = [NSNumber numberWithInteger:indexPath.row];
    
    if (sender.selected) { // 选中的状态
        
        cell.peccImage.image = [UIImage imageNamed:@"wzcx_选中2"];
        
        [self.idArr addObject:data.id];
        [self.btnArr addObject:num];
        
        _moneys += [data.money floatValue];
        
    }else{ // 未选中的状态
        
        cell.peccImage.image = [UIImage imageNamed:@"wzcx_未选中1"];
        
        [self.idArr removeObject:data.id];
        [self.btnArr removeObject:num];
        
        _moneys -= [data.money floatValue];
        
    }
    
}

-(void)setBtn:(UIButton *)btn AndImageV:(UIImageView *)imageV titleColor:(UIColor *)color hidden:(BOOL)isHidden edgeInsets:(UIEdgeInsets)insets title:(NSString *)title imageName:(NSString *)imageName
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.contentEdgeInsets = insets;
    
    imageV.hidden = isHidden;
    imageV.image = [UIImage imageNamed:imageName];
}


@end
