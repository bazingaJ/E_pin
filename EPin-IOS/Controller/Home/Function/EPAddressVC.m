//
//  EPAddressVC.m
//  EPin-IOS
//
//  Created by jeader on 16/6/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPAddressVC.h"
#import "HeaderFile.h"
#import "EPCallCarVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "EPNowTableVC.h"
#import "EPOrderTableVC.h"


@interface EPAddressVC ()<UISearchBarDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AMapSearchAPI *_search;
    AMapPOISearchBaseRequest * _poiRequest;
    NSMutableArray * saveArr;
}
@property (nonatomic, strong) UISearchBar * searchBar;

@end

@implementation EPAddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationBar:0 title:@""];
    [self prepareForSearch];
    [self.searchBar becomeFirstResponder];
}
- (void)prepareForSearch
{
    self.searchBar =[[UISearchBar alloc] initWithFrame:CGRectMake(60, 25, EPScreenW-120, 30)];
    self.searchBar.placeholder=@"请输入地址";
    self.searchBar.barTintColor=[UIColor colorWithRed:27/255.0 green:29/255.0 blue:35/255.0 alpha:1.0];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton=NO;
    [self.view addSubview:self.searchBar];
    saveArr=[NSMutableArray array];
    self.tableVi.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;//设置成NO表示当前控件响应
    [self.tableVi addGestureRecognizer:tapGestureRecognizer];
}
//搜索框的代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (searchBar.text.length==0)
    {
        [saveArr removeAllObjects];
        [self.tableVi reloadData];
    }
    else
    {
        [self initPOIObjectWithKeyWord:searchBar.text];
    }
}
- (void)initPOIObjectWithKeyWord:(NSString *)keyWord
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapInputTipsSearchRequest对象，设置请求参数
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = keyWord;
    tipsRequest.city = @"南京";
    
    //发起输入提示搜索
    [_search AMapInputTipsSearch:tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    for (AMapTip *p in response.tips)
    {
        NSMutableDictionary * Dic =[NSMutableDictionary dictionary];
        Dic[@"big"]=p.name;
        Dic[@"small"]=p.district;
        Dic[@"location"]=p.location;
        [saveArr addObject:Dic];
    }
    [self.tableVi reloadData];
}
#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return saveArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier1 =@"cell1";
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:3 reuseIdentifier:cellIdentifier1];
    }
    cell.imageView.image = [UIImage imageNamed:@"放大镜"];
    cell.textLabel.text=saveArr[indexPath.row][@"big"];
    cell.detailTextLabel.text=saveArr[indexPath.row][@"small"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * locationStr =saveArr[indexPath.row][@"big"];
//    NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
    if (self.isUp)//起点
    {
        if (self.isOrder)//预约
        {
            [self.orderViewCon.nowLocationBtn setTitle:locationStr forState:UIControlStateNormal];
//            [us setObject:locationStr forKey:@"orderLocation"];
        }
        else
        {
            [self.nowViewCon.nowLocation setTitle:locationStr forState:UIControlStateNormal];
//            [us setObject:locationStr forKey:@"upCarLocation"];
        }
    }
    else
    {
        if (self.isOrder)
        {
            [self.orderViewCon.destinationBtn setTitle:locationStr forState:UIControlStateNormal];
//            [us setObject:locationStr forKey:@"orderDestination"];
        }
        else
        {
            [self.nowViewCon.destination setTitle:locationStr forState:UIControlStateNormal];
//            [us setObject:locationStr forKey:@"destinationLocation"];
        }
    }
//    [us synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
-(void)hideKeyBoard
{
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
