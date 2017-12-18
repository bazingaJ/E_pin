//
//  EPMoreController.m
//  EPin-IOS
//
//  Created by jeaderQ on 16/5/19.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMoreController.h"
#import "EPMoreCell.h"
#import "HeaderFile.h"
#import "EPMainModel.h"
#import "EPGoods.h"
#import "EPGoodsDetailVC.h"
@interface EPMoreController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EPMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBar:0 title:_titles];
    // Do any additional setup after loading the view from its nib.
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
    return self.moreArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    EPMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([self.moreArr[indexPath.row] isKindOfClass:[EPMainModel class]]) {
    EPMainModel *model = self.moreArr[indexPath.row];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EPMoreCell" owner:nil options:nil]objectAtIndex:0];
        if (model.goodsSaleImg)
        {
            [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg]];
            cell.shopsName.text = model.goodsName;
            cell.goodsCountsL.text = model.goodsCounts;
            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.goodsPrice];
        }
//        }else if(model.likeImg){
//             [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.likeImg]];
//            cell.shopsName.text = model.likeName;
//            cell.goodsCountsL.text = model.goodsCounts;
//            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.likePrice];
//        }else if(model.hotImg){
//            [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.hotImg]];
//            cell.shopsName.text = model.hotName;
//            cell.goodsCountsL.text = model.goodsCounts;
//            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.hotPrice];
//        }
        else if(model.thirdImg)
        {
            [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.thirdImg]];
            cell.shopsName.text = model.thirdName;
            cell.goodsCountsL.text = model.goodsCounts;
            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.thirdPrice];
        }
        else if(model.secondImg)
        {
            [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.secondImg]];
            cell.shopsName.text = model.secondName;
            cell.goodsCountsL.text = model.goodsCounts;
            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.secondPrice];
        }else if (model.goodsImg){
            [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];
            cell.shopsName.text = model.goodsName;
            cell.goodsCountsL.text = model.goodsCounts;
            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.goodsPrice];
        }
        if (model.goodsStar)
        {
            for (int i = 0; i < [model.goodsStar intValue]; i++)
            {
         
                CGFloat imgY =CGRectGetMaxY(cell.shopsName.frame)+10;
                UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"实心星星"]];
                CGFloat imgX = CGRectGetMinX(cell.shopsName.frame) +i*imageV.width+i*5;
                    imageV.x = imgX;
                    imageV.y = imgY;
                [cell.contentView addSubview:imageV];
            }
        }
    }
    }
    else
    {
        NSLog(@"走这里啦%s",__func__);
        EPGoods *model = self.moreArr[indexPath.row];
        if(cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EPMoreCell" owner:nil options:nil]objectAtIndex:0];
            [cell.shopsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsSaleImg]];
            cell.shopsName.text = model.goodsName;
            cell.goodsCountsL.text = model.goodsCounts;
            cell.goodsPriceL.text = [NSString stringWithFormat:@"售价 ￥ %@",model.goodsPrice];
            if (model.goodsStar) {
                for (int i = 0; i < [model.goodsStar intValue]; i++) {
                    
                    CGFloat imgY =CGRectGetMaxY(cell.shopsName.frame)+10;
                    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"实心星星"]];
                    CGFloat imgX = CGRectGetMinX(cell.shopsName.frame) +i*imageV.width+i*5;
                    imageV.x = imgX;
                    imageV.y = imgY;
                    [cell.contentView addSubview:imageV];
                }
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}
#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EPGoodsDetailVC *detail = [[EPGoodsDetailVC alloc]init];
    if ([self.moreArr[indexPath.row] isKindOfClass:[EPMainModel class]]) {
        EPMainModel *model = self.moreArr[indexPath.row];
        detail.goodsId = model.goodsId;
    }else{
        EPGoods *model = self.moreArr[indexPath.row];
        detail.goodsId = model.goodsId;

    }
    
    [self.navigationController pushViewController:detail animated:YES];

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
