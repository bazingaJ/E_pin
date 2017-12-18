//
//  BookListCellView.m
//  LabLibrary
//
//  Created by Cloudox on 16/4/23.
//  Copyright © 2016年 Cloudox. All rights reserved.
//

#import "EPMainCellView.h"
#import "HeaderFile.h"
//设备的宽高
#define SCREENWIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT      [UIScreen mainScreen].bounds.size.height

@interface EPMainCellView ()

@property (nonatomic, strong) UILabel *bookName;

@end

@implementation EPMainCellView

- (instancetype)initWithFrame:(CGRect)frame andData:(NSString *)data shopsName:(NSString *)shopsName{
    self = [super initWithFrame:frame];
    if (self) {
        // 书籍图片
        UIImageView *bookImg = [[UIImageView alloc] initWithFrame:frame];
        [bookImg sd_setImageWithURL:[NSURL URLWithString:data]];
//        bookImg.layer.cornerRadius = 4.0;
        bookImg.layer.masksToBounds = YES;
        bookImg.backgroundColor = [UIColor  whiteColor];
        UILabel *shopNameL = [[UILabel alloc]init];
        shopNameL.width = bookImg.width;
        shopNameL.height = 44;
        shopNameL.y = bookImg.height-44;
        shopNameL.x = 0;
        shopNameL.text = shopsName;
        shopNameL.font = [UIFont systemFontOfSize:15];
        shopNameL.textColor = RGBColor(255, 255, 255);
        shopNameL.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        shopNameL.textAlignment = NSTextAlignmentCenter;
        [bookImg addSubview:shopNameL];
        [self addSubview:bookImg];
        
//        // 书籍名字
//        _bookName = [[UILabel alloc] initWithFrame:CGRectMake(87, 15, SCREENWIDTH - 99, 120)];
//        _bookName.text = [data objectAtIndex:0];
//        _bookName.textAlignment = NSTextAlignmentLeft;
//        _bookName.font = [UIFont systemFontOfSize:18];
//        // 自动换行
//        _bookName.numberOfLines = 0;
//        _bookName.lineBreakMode = NSLineBreakByWordWrapping;
//        CGSize nameSize = [_bookName sizeThatFits:CGSizeMake(SCREENWIDTH - 99, MAXFLOAT)];
//        _bookName.frame = CGRectMake(87, 15, SCREENWIDTH - 99, nameSize.height);
//        
//        [self addSubview:_bookName];
//        
//        // 书籍ISBN
//        UILabel *isbnLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, _bookName.frame.origin.y + _bookName.frame.size.height + 10, SCREENWIDTH - 99, 20)];
//        isbnLabel.text = [NSString stringWithFormat:@"ISBN：%@", [data objectAtIndex:1]];
//        isbnLabel.textAlignment = NSTextAlignmentLeft;
//        isbnLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:isbnLabel];
//        
    }
    return self;
}

-(CGFloat)getHeight{
//    return _bookName.frame.origin.y + _bookName.frame.size.height + 30 + 15 > 90 ? _bookName.frame.origin.y + _bookName.frame.size.height + 30 + 15 : 90;
    return HEIGHT(176.0, 667);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
