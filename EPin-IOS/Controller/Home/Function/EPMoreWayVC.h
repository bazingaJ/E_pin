//
//  EPNotFindVC.h
//  EPin-IOS
//
//  Created by jeader on 16/4/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPMoreWayVC : UIViewController


@property (nonatomic, weak) IBOutlet UITableView * tableVi;
@property (nonatomic, strong) NSDictionary * getDic;
@property (nonatomic, strong) NSString * lostId;
@property (nonatomic, strong) NSString * lostDescribe;
@end
