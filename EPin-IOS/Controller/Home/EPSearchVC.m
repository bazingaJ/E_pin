//
//  EPSearchViewController.m
//  EPin-IOS
//  搜索
//  Created by jeader on 16/3/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPSearchVC.h"
#import "HeaderFile.h"
#import "EPSearchCell.h"
#import "EPShopVC.h"
#import "EPMainModel.h"
#import "MJExtension.h"
#import "ZYTokenManager.h"
#import "EPResultsTableVC.h"
@interface EPSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UISearchResultsUpdating>
//热门搜索中的商家提供的选项
@property (nonatomic, strong) NSArray * choiceArr;
//搜索历史中的历史列表
@property (nonatomic, strong) NSMutableArray * hisArr;
//声明一个搜索框
@property (nonatomic, strong) UISearchController * searchController;
//接收数据源结果
@property(nonatomic,retain)NSMutableArray * searchResults;

//声明一个搜索框
@property (nonatomic, strong) UISearchBar * searchBar;


@property (nonatomic, strong) EPResultsTableVC *results;
@property (nonatomic, strong) NSArray *seachHistory;
@end

@implementation EPSearchVC

- (void)viewWillAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
    [self readNSUserDefaults];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0];
    [self addRightItemWithFrame:CGRectZero textOrImage:0 action:@selector(rightBtnClick) name:@"清除历史信息"];
    [self prepareForData];
    [self setUpSearchView];

    
    _results = [[EPResultsTableVC alloc]init];
    _results.view.frame = CGRectMake(0, 64, self.view.width, self.view.height);
    _results.view.hidden = YES;
    [self.view addSubview:_results.view];
    [self addChildViewController:_results];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.searchBar.isFirstResponder)
    {
        [self.searchBar resignFirstResponder];
    }
    else
    {
        //如果不是第一相应就是什么事情都不做
        NSLog(@"不是第一响应");
    }
}
-(void)rightBtnClick{
    [ZYTokenManager removeAllArray];
    _seachHistory = nil;
    [self.tableVi_ reloadData];
}
- (void)setUpSearchView
{
//    self.tableVi_.allowsSelection=NO;
    //定义搜索框
//    _searchController= [[UISearchController alloc] initWithSearchResultsController:nil];
//    _searchController.searchBar.frame=CGRectMake(60, 30, EPScreenW-120, 30);
//    _searchController.searchBar.placeholder=@"输入商家、商品名称";
//    _searchController.searchBar.showsCancelButton=NO;
//    _searchController.searchBar.barTintColor=[UIColor colorWithRed:27/255.0 green:29/255.0 blue:35/255.0 alpha:1.0];
//    for(UIView *view in  [[[_searchController.searchBar subviews] objectAtIndex:0] subviews])
//    {
//        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"" forState:UIControlStateNormal];
//        }
//    }
//    _searchController.hidesNavigationBarDuringPresentation = NO;
//    _searchController.searchResultsUpdater=self;
    
    self.searchBar =[[UISearchBar alloc] initWithFrame:CGRectMake(60, 25, EPScreenW-120, 30)];
    self.searchBar.placeholder=@"输入商家、商品名称";
    self.searchBar.barTintColor=[UIColor colorWithRed:27/255.0 green:29/255.0 blue:35/255.0 alpha:1.0];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton=NO;
     [self.view addSubview:self.searchBar];
    
    
    self.tableVi_.bounces=NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    [self getDataWitnStr:searchText];
}
-(void)readNSUserDefaults{//取出缓存的数据
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray = [userDefaultes arrayForKey:@"myArray"];
    self.seachHistory = myArray;
    [self.tableVi_ reloadData];
  
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""] || searchBar.text == nil)
    {//clear
        self.tableVi_.hidden = NO;
        return;
    }
    NSString *searchTerm = searchBar.text;
    
    [self getDataWitnStr:searchTerm];
    
}
-(void)getDataWitnStr:(NSString *)string{
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    paramer[@"condition"]=string;
    paramer[@"type"]=@"0";
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
     NSString * str=[NSString stringWithFormat:@"%@/homeSearchInfo.json",EPUrl];
    NSLog(@"%@?condition=%@",str,string);
    [manager POST:str parameters:paramer success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject===========%@",responseObject);
        
        NSMutableArray *shopInfoArr = responseObject[@"shopInfoArr"];
        self.results.shopInfoArr = [EPMainModel mj_objectArrayWithKeyValuesArray:shopInfoArr];
        if (string.length>0) {
          
            self.results.view.hidden = NO;
            [self.results.tableView reloadData];
        }else{
            self.results.view.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s   %@",__func__,error);
    }];
}


- (void)prepareForData
{
    _choiceArr =[NSArray arrayWithObjects:@"KFC",@"McDownload",@"Pizza",@"JavaCoffee",@"RedBull",@"chanel",@"Nike",@"Adidas", nil];
    _hisArr =[NSMutableArray arrayWithObjects:@"Pizza And More",@"Fast breakfast", nil];
}

//导航右边按钮事件
- (void)sweepBtnClick
{
    [_hisArr removeAllObjects];
    [self.tableVi_ reloadData];
}

#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//    if (section==0)
//    {
//        return 1;
//    }
//    else
//    {
        return self.seachHistory.count;
//        return (!self.searchController.active) ? self.items.count : self.searchResults.count;
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * cellIdentifier1 =@"cell1";
    static NSString * cellIdentifier2 =@"cell2";
    EPSearchCell * cell = nil;

    if (indexPath.section==0)
    {
//        if (!cell)
//        {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"EPSearchCell" owner:nil options:nil]objectAtIndex:0];
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        }
//        [self prepareForBtnWithView:cell];
//    }
//    else
//    {
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"EPSearchCell" owner:nil options:nil]objectAtIndex:1];
        }
        if (_hisArr.count != 0)
        {
            cell.historyLab.text=self.seachHistory[indexPath.row];
        }
    }
    return cell;
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section != 0)
//    {
        EPMainModel *model = self.results.shopInfoArr[indexPath.row];
        EPShopVC *shop = [[EPShopVC alloc]init];
        shop.shopId =model.shopsId;
        NSLog(@"shopId ======%@",shop.shopId);
        [self.navigationController pushViewController:shop animated:YES];
//    }
}
#pragma mark- UITable View View For Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0)
    {
        UIView * headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 30)];
        UILabel * titleLab =[[UILabel alloc] init];
        titleLab.frame=CGRectMake(20, 5, 100, 25);
        titleLab.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
        titleLab.font=[UIFont systemFontOfSize:15];
        titleLab.text=@"搜索历史";
        [headerView addSubview:titleLab];
        
        return headerView;
    }
    else if (section==1)
    {
        UIView * headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 35)];
        UILabel * titleLab =[[UILabel alloc] init];
        titleLab.frame=CGRectMake(20, 5, 100, 25);
        titleLab.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
        titleLab.font=[UIFont systemFontOfSize:15];
        titleLab.text=@"搜索历史";
        [headerView addSubview:titleLab];
        
        return headerView;
    }
    else
    {
        UIView * headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 30)];
        return headerView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 29;
    }
    else
    {
        return 29;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section==0) {
        return 40;
//    }else{
//       return 40;
//    }
}
//布局按钮
- (void)prepareForBtnWithView:(UIView *)view_
{
    //上边四个按钮的布局
    float count = 0;
    for (int i = 0; i<4; i++)
    {
        float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
        count=count+btnW;
    }
    float distence =(EPScreenW-count)/5;
    for (int i = 0; i<4; i++)
    {
        switch (i)
        {
            case 0:
                {
                    float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                    [view_ addSubview:[self btnSelfLocationWithLocationX:distence withLength:btnW withNum:i]];
                }
                break;
            case 1:
                {
                    float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                    float btnW1 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-1]]+20;
                    float btnX =distence*2+btnW1;
                    [view_ addSubview:[self btnSelfLocationWithLocationX:btnX withLength:btnW withNum:i]];
                }
                break;
            case 2:
                {
                    float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                    float btnW1 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-1]]+20;
                    float btnW2 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-2]]+20;
                    float btnX =distence*3+btnW1+btnW2;
                    [view_ addSubview:[self btnSelfLocationWithLocationX:btnX withLength:btnW withNum:i]];
                }
                break;
            case 3:
                {
                    float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                    float btnW1 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-1]]+20;
                    float btnW2 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-2]]+20;
                    float btnW3 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-3]]+20;
                    float btnX =distence*4+btnW1+btnW2+btnW3;
                    [view_ addSubview:[self btnSelfLocationWithLocationX:btnX withLength:btnW withNum:i]];
                }
                break;
                
            default:
                break;
        }
    }
    float count1 = 4;
    for (int i = 4; i<8; i++)
    {
        float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
        count1=count1+btnW;
    }
    float distence1 =(EPScreenW-count1)/5;
    for (int i = 4; i<8; i++)
    {
        switch (i)
        {
            case 4:
            {
                float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                [view_ addSubview:[self btnSelfLocationWithLocationX:distence1 withLength:btnW withNum:i]];
            }
                break;
            case 5:
            {
                float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                float btnW1 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-1]]+20;
                float btnX =distence1*2+btnW1;
                [view_ addSubview:[self btnSelfLocationWithLocationX:btnX withLength:btnW withNum:i]];
            }
                break;
            case 6:
            {
                float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                float btnW1 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-1]]+20;
                float btnW2 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-2]]+20;
                float btnX =distence1*3+btnW1+btnW2;
                [view_ addSubview:[self btnSelfLocationWithLocationX:btnX withLength:btnW withNum:i]];
            }
                break;
            case 7:
            {
                float btnW =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i]]+20;
                float btnW1 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-1]]+20;
                float btnW2 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-2]]+20;
                float btnW3 =[self getWidthWithstrirng:[_choiceArr objectAtIndex:i-3]]+20;
                float btnX =distence1*4+btnW1+btnW2+btnW3;
                [view_ addSubview:[self btnSelfLocationWithLocationX:btnX withLength:btnW withNum:i]];
            }
                break;
                
            default:
                break;
        }
    }
}
//创建button
- (UIView *)btnSelfLocationWithLocationX:(float)btnX withLength:(float)btnW withNum:(int)i
{
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(btnX, 10+(i/4)*31, btnW, 21);
    btn.clipsToBounds=YES;
    btn.layer.cornerRadius=10;
    btn.layer.borderWidth=1;
    btn.layer.borderColor=[[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]CGColor];
    [btn setTitle:[_choiceArr objectAtIndex:i] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=i;
    return btn;
    
}

#pragma mark - Search Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    NSLog(@"代理方法被调用了吗");
//    [self.searchResults removeAllObjects];
    //NSPredicate 谓词
//    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@self contains[cd] %@,searchController.searchBar.text];
//    self.searchResults = [[self.items filteredArrayUsingPredicate:searchPredicate]mutableCopy];
    //刷新表格
//    [self.tableVi_ reloadData];
}

//获得按钮的自适应宽度
- (CGFloat)getWidthWithstrirng:(NSString *)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    CGFloat width = ceilf(rect.size.width);
    return width;
}

- (void)titleBtnClick
{
    EPShopVC * vc = [[EPShopVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
