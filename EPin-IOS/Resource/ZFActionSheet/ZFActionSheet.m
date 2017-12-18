//
//  ZFActionSheet.m
//  YXJ
//
//  Created by 张锋 on 16/4/26.
//  Copyright © 2016年 成都寸芒网络科技有限公司. All rights reserved.
//

#import "ZFActionSheet.h"
#import "EPPeccCell.h"
#import "HeaderFile.h"
#define Height_44 80
#define Height_50 80
#define Height_60 80
#define lineHeight  0.5
#define LineSpacing 5

#define ZFSize_5  5
#define ZFSize_13 13
#define ZFSize_14 14
#define ZFSize_17 17
#define ZFSize_40 20

#define kScreenCenter self.window.center

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ZFActionSheet ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, strong) NSArray *confirms;
@property (nonatomic, strong) NSString *cancel;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) ZFActionSheetStyle style;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ZFActionSheet

+ (ZFActionSheet *)actionSheetWithTitle:(NSString *)title confirms:(NSArray *)confirms cancel:(NSString *)cancel style:(ZFActionSheetStyle)style
{
    return [[self alloc] initWithTitle:title confirms:confirms cancel:cancel style:style];
}
#pragma mark - 初始化控件
- (instancetype)initWithTitle:(NSString *)title confirms:(NSArray *)confirms cancel:(NSString *)cancel style:(ZFActionSheetStyle)style
{
    self = [super init];
    if (self) {
        self.title = title;
        self.confirms = confirms;
        self.cancel = cancel;
        self.style = style;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}
- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapAction)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}
- (void)createSubViews
{
    CGFloat titleHeight = 0;
    CGFloat confirmHeight = 0;
    CGFloat separatorHeight = 0;
    CGFloat cancelHeight = 0;
    

  
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    /** 提示信息 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:ZFSize_13];
    titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 29);
    titleLabel.text = self.title;
 
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGBColor(237, 237, 237);
  
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 31, SCREEN_WIDTH, bgView.frame.size.height-20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [bgView addSubview:titleLabel];
    [bgView addSubview:line];
    [bgView addSubview:self.tableView];
    [self addSubview:bgView];
    
    confirmHeight += SCREEN_HEIGHT/2;
    CGFloat ActionSheetHeight = titleHeight + confirmHeight + separatorHeight + cancelHeight;
    self.frame = CGRectMake(0, SCREEN_HEIGHT - ActionSheetHeight, SCREEN_WIDTH, ActionSheetHeight);
}

#pragma mark - 显示界面
- (void)showInView:(id)obj
{
    [obj addSubview:self.shadowView];
    [obj addSubview:self];
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(0);
    opacity.duration = 0.2;
    [self.shadowView.layer addAnimation:opacity forKey:nil];

    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenCenter.x, SCREEN_HEIGHT)];
    move.duration = 0.2;
    [self.layer addAnimation:move forKey:nil];
}

#pragma mark - 代理方法
- (void)button:(UIButton *)button clickAtIndex:(NSIndexPath *)index
{
    if ([self.delegate respondsToSelector:@selector(clickAction:atIndex:)]) {
        [self animationHideShadowView];
        [self animationHideActionSheet];
        
        NSInteger line = index.row;
        NSLog(@"line  ==%ld",line);
        [self.delegate clickAction:self atIndex:line];
    }
}

#pragma mark - 背景点击事件
- (void)tapAction
{
    [self animationHideShadowView];
    [self animationHideActionSheet];
}


#pragma mark - 隐藏动画
- (void)animationHideShadowView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:self];
    }];
}
- (void)animationHideActionSheet
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CGFloat) height
{
    return self.frame.size.height;
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell6";
    
    EPPeccCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EPPeccCell" owner:nil options:nil]objectAtIndex:4];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",(long)indexPath.row);
    [self button:nil clickAtIndex:indexPath];
    [self tapAction];
//    kTipAlert(@"<%ld> selected...", indexPath.row);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    if (offsetY<-10) {
        [self tapAction];
    }
}



@end
