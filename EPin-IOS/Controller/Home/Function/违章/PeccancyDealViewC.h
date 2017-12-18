//
//  PeccancyDealViewC.h
//  eTaxi-iOS
//
//  Created by jeader on 16/2/16.
//  Copyright © 2016年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeccancyDealViewC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableVi;
@property (nonatomic, strong) NSString * IDStr;
- (instancetype)initWithDataArr:(NSMutableArray *)arr withMoneyStr:(NSString *)money withCode:(NSString *)codeStr;
@end
