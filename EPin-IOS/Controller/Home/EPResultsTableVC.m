//
//  EPResultsTableVC.m
//  EPin-IOS
//
//  Created by jeaderQ on 16/5/11.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPResultsTableVC.h"
#import "HeaderFile.h"
#import "EPMainModel.h"
#import "ZYTokenManager.h"
#import "EPShopVC.h"
@interface EPResultsTableVC ()

@end

@implementation EPResultsTableVC


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, EPScreenW, 30)];
    UILabel * titleLab =[[UILabel alloc] init];
    titleLab.frame=CGRectMake(20, 5, 100, 20);
    titleLab.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    titleLab.font=[UIFont systemFontOfSize:15];
    titleLab.text=@"搜索结果";
    [headerView addSubview:titleLab];
    self.tableView.tableHeaderView =headerView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (self.shopInfoArr.count==0) {
        return 1;
    }else{
    return self.shopInfoArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     NSLog(@"shopsArr ====%@",self.shopInfoArr);
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.shopInfoArr.count ==0) {
        cell.textLabel.text =@"没有找到您要找的商品";
        
    }else{
        EPMainModel *model = self.shopInfoArr[indexPath.row];
        cell.textLabel.text = model.shopsName;
        cell.imageView.image = [UIImage imageNamed:@"放大镜"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  

    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shopInfoArr.count==0) {
        return;
    }
    EPMainModel *model = self.shopInfoArr[indexPath.row];
    EPShopVC *shop = [[EPShopVC alloc]init];
    shop.shopId =model.shopsId;
    [ZYTokenManager SearchText:model.shopsName];//缓存搜索记录
    NSLog(@"shopId ======%@",shop.shopId);
    [self.navigationController pushViewController:shop animated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
