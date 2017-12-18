//
//  EPPointsController.m
//  EPin-IOS
//
//  Created by jeaderq on 16/6/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPointsController.h"
#import "HeaderFile.h"
#import "MJExtension.h"
#import "EPMainModel.h"
#import "EPPointsCell.h"
@interface EPPointsController ()<UITableViewDelegate,UITableViewDataSource>
//积分账户label
@property (weak, nonatomic) IBOutlet UILabel *headerFL;
@property (weak, nonatomic) IBOutlet UIView *headerBG;
@property (nonatomic, strong) NSArray *messageArr;
@end

@implementation EPPointsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar:0 title:@"我的积分"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadData];
        // Do any additional setup after loading the view from its nib.
}
-(void)loadData{
    [EPData getScoreInfoWithBeginDate:nil WithOverDate:nil withType:@"666" Completion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
        if ([returnCode intValue]==0) {
            NSLog(@"dic=====%@",dic);
            NSMutableArray *Integrals = dic[@"Integrals"];
            NSString *totalScore = dic[@"totalScore"];
            [self subViewsWithTotalScore:totalScore];

           self.messageArr = [EPMainModel mj_objectArrayWithKeyValuesArray:Integrals];
            [self.tableView reloadData];
        }
    }];

}
-(void)subViewsWithTotalScore:(NSString *)totalScore{
    UILabel *label = [[UILabel alloc]init];
        NSString *tex = totalScore;
    label.text = [NSString stringWithFormat:@"%@",tex];
    CGSize secondSize = [self sizeWithText:label.text font:[UIFont systemFontOfSize:48 weight:.1]];
    label.size = secondSize;
    label.y =CGRectGetMaxY(self.headerFL.frame);
    label.x = 20;
    label.font = [UIFont systemFontOfSize:48 weight:.1];
    label.textColor = RGBColor(0, 0, 0);
    [_headerBG addSubview:label];
    UILabel *fenL = [[UILabel alloc]init];
    fenL.width = 60;
    fenL.height = 40;
    fenL.x = CGRectGetMaxX(label.frame);
    fenL.y = CGRectGetMaxY(label.frame)-fenL.height;
    fenL.text = @"积分";
    fenL.textColor = RGBColor(0, 0, 0);
    fenL.font = [UIFont systemFontOfSize:18];
    [_headerBG addSubview:fenL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EPPointsCell";
    
    EPPointsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    EPMainModel *mode = self.messageArr[indexPath.row];
    
    if(cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"EPPointsCell" owner:nil options:nil][0];
    }
    cell.costNameL.text = mode.costName;
    if ([mode.cost intValue]>0) {
        cell.costL.text = [NSString stringWithFormat:@"+%@",mode.cost];
        cell.costL.textColor = RGBColor(42, 148, 44);

    }else{
        cell.costL.text = mode.cost;
        cell.costL.textColor = RGBColor(242, 63, 63);

    }
    NSArray *array = [mode.updateDate componentsSeparatedByString:@"."];
    cell.updateDateL.text = [array firstObject];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
