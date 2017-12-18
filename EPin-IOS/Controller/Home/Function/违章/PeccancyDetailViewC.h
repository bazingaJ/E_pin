//
//  PeccancyDetailViewC.h
//  E+TAXI
//
//  Created by jeader on 15/12/29.
//  Copyright © 2015年 jeader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeccancyDetailViewC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *detailTable;


@property (strong, nonatomic) NSMutableArray * array;
@property (strong, nonatomic) NSString * codeStr;
@property (nonatomic, strong) NSString * moneyStr;
@property (nonatomic, weak) IBOutlet UIButton * pointBtn;

- (instancetype)initWithArr:(NSMutableArray *)arr WithCode:(NSInteger)code withAddress:(NSString *)address;
@end
