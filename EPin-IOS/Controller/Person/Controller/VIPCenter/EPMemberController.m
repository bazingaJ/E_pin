//
//  EPMemberController.m
//  55555
//
//  Created by jeaderQ on 16/3/28.
//  Copyright © 2016年 jeaderQ. All rights reserved.
//

#import "EPMemberController.h"
#import "HeaderFile.h"
#import "EPMemberCell.h"
#import "EPLoginViewController.h"
@interface EPMemberController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerBg;
@property (weak, nonatomic) IBOutlet UIButton *integral;
@property (weak, nonatomic) IBOutlet UILabel *names;
@property (weak, nonatomic) IBOutlet UILabel *VIPLever;
@property (nonatomic, strong) UIImageView *bigMember;
@end

@implementation EPMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle =  UITableViewCellSelectionStyleNone;
    self.tableView.bounces=NO;
    [self setupNavView];
    //设置tableView的背景
    UIView *bgView = [[UIView alloc]initWithFrame:self.tableView.frame];
    bgView.backgroundColor = [UIColor colorWithRed:19/255.0 green:39/255.0 blue:82/255.0 alpha:1.0];
    self.tableView.backgroundView = bgView;
    [self addNavigationBar:NavigationBarStyleVipCenter title:@"会员中心"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!LOGINTIME) {
        [self.bigMember removeFromSuperview];
        self.bigMember  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请登录"]];
        self.bigMember.centerX = EPScreenW/2;
        self.bigMember.y = 80;
        [self.view addSubview:_bigMember];

        NSString *num = [NSString stringWithFormat:@"0位"];
        UIButton *loading = [UIButton buttonWithType:UIButtonTypeCustom];
        [loading setFrame:_bigMember.frame];
        [loading addTarget:self action:@selector(isLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loading];
        [self.integral setTitle:num forState:UIControlStateNormal];
        self.names.text = @"";
        self.VIPLever.text =@"";
    }
}

-(void)setupNavView
{
    UIView *headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, HEIGHT(0.7, 667))];
    headerLine.backgroundColor = RGBColor(88, 79, 64);
    [self.headerBg addSubview:headerLine];
    if (LOGINTIME) {
        NSString *num = [NSString stringWithFormat:@" %@位",self.num];
        [self.integral setTitle:num forState:UIControlStateNormal];
        self.names.text = self.name;
        
        if ([self.memLevel intValue] == 1) {
            _bigMember = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"普通会员图标"]];
            _bigMember.centerX = EPScreenW/2;
            _bigMember.y = 80;
            [self.view addSubview:_bigMember];
            self.VIPLever.text =@"普通会员";
            
        }else if ([self.memLevel intValue] == 2){
            _bigMember = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"白金会员图标"]];
            _bigMember.centerX = EPScreenW/2;
            _bigMember.y = 80;
            [self.view addSubview:_bigMember];
            self.VIPLever.text =@"白金会员";
        }else if ([self.memLevel intValue] == 3){
            _bigMember = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"钻石会员图标"]];
            _bigMember.centerX = EPScreenW/2;
            _bigMember.y = 80;
            [self.view addSubview:_bigMember];
            self.VIPLever.text =@"钻石会员";
        }

    }else{
//        _bigMember = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"请登录"]];
//        _bigMember.centerX = EPScreenW/2;
//        _bigMember.y = 84;
//        [self.view addSubview:_bigMember];
//        NSString *num = [NSString stringWithFormat:@"0位"];
//        UIButton *loading = [UIButton buttonWithType:UIButtonTypeCustom];
//        [loading setFrame:_bigMember.frame];
//        [loading addTarget:self action:@selector(isLogin) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:loading];
//        [self.integral setTitle:num forState:UIControlStateNormal];
//        self.names.text = @"";
//        self.VIPLever.text =@"";

    }
}
-(void)isLogin{
    EPLoginViewController *login = [[EPLoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];

}

//返回会员特权 或者会员规则
-(UIView *)setHeaderSectionViewWithImageName:(NSString *)imageName sectionText:(NSString *)text{

    //设置tableView的头视图
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, HEIGHT(80.0, 667))];

    headerView.backgroundColor = RGBColor(19, 39, 82);

    NSString *iconImage = [NSString stringWithFormat:@"%@",imageName];
    UIImageView *memberIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(23.0, 375), HEIGHT(7.0, 667), WIDTH(14.0, 375), HEIGHT(17.0, 667))];
    memberIcon.image = [UIImage imageNamed:iconImage];
    [headerView addSubview:memberIcon];
    
    UILabel *memberText = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(42.0, 375), HEIGHT(5.0, 667), WIDTH(100.0, 375), HEIGHT(20.0, 667))];
    memberText.backgroundColor = [UIColor clearColor];
    memberText.text = text;
    memberText.textColor = [UIColor colorWithRed:216/255.0 green:186/255.0 blue:131/255.0 alpha:1.0];
    memberText.font =[UIFont systemFontOfSize:15];
    [headerView addSubview:memberText];

    return headerView;
}

#pragma mark - table view dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"111";
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //根据图文 选择创建 header
    
    if (section == 0) {
        return [self setHeaderSectionViewWithImageName:@"会员特权" sectionText:@"会员特权"];
    }
    
    return [self setHeaderSectionViewWithImageName:@"会员规则" sectionText:@"会员规则"];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row ==0) {
            return HEIGHT(92.0, 667);
        }else if (indexPath.row==1){
            return HEIGHT(105.0, 667);
        }else if (indexPath.row==2){
            return HEIGHT(137.0, 667);
        }
    }
    return HEIGHT(147.0, 667);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
     EPMemberCell *cell = [[NSBundle mainBundle] loadNibNamed:@"EPMemberCell" owner:nil options:nil][0];

    if(cell == nil) {
        cell = [[EPMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section==0) {
    if (indexPath.row ==0) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20.0, 375), HEIGHT(5.0, 667), EPScreenW-40, HEIGHT(82.0, 667))];
            image.image = [UIImage imageNamed:@"普通会员"];
        [cell.contentView addSubview:image];
        }else if (indexPath.row==1){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20.0, 375), HEIGHT(5.0, 667), EPScreenW-40, HEIGHT(95.0, 667))];
            image.image = [UIImage imageNamed:@"白金会员"];
            [cell.contentView addSubview:image];
        }else if(indexPath.row ==2){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20.0, 375), HEIGHT(5.0, 667), EPScreenW-40, HEIGHT(120.0, 667))];
            image.image = [UIImage imageNamed:@"钻石会员"];
            [cell.contentView addSubview:image];
        }
    }else if (indexPath.section==1){
        if (indexPath.row ==0) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20.0, 375), HEIGHT(5.0, 667), EPScreenW-40, HEIGHT(137.0, 667))];
            image.image = [UIImage imageNamed:@"Q1"];
            [cell.contentView addSubview:image];
        }else if (indexPath.row ==1){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(20.0, 375), HEIGHT(5.0, 667), EPScreenW-40, HEIGHT(137.0, 667))];
            image.image = [UIImage imageNamed:@"Q2"];
            [cell.contentView addSubview:image];
        }
    }


    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    kTipAlert(@"<%ld> selected...", indexPath.row);
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
