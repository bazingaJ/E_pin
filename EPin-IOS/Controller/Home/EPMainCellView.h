//
//  BookListCellView.h
//  LabLibrary
//
//  Created by Cloudox on 16/4/23.
//  Copyright © 2016年 Cloudox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPMainCellView : UITableViewCell
- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)data shopsName:(NSString *)shopsName;

- (CGFloat)getHeight;

@end
