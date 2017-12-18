//
//  EPScanViewController.m
//  EPin-IOS
//  扫码
//  Created by jeader on 16/3/23.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPScanVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+SDExtension.h"
#import "EPTabbarViewController.h"
#import "HeaderFile.h"
#import "EPScanResultVC.h"

static const CGFloat kBorderW = 100;
static const CGFloat kMargin = 30;

#define  BOUNDS [UIScreen mainScreen].bounds
#define  SCREEN [UIScreen mainScreen].bounds.size

@interface EPScanVC ()<UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, weak)   UIView * maskView;
@property (nonatomic, strong) UIView * scanWindow;
@property (nonatomic, strong) UIImageView * scanNetImageView;
@end

@implementation EPScanVC

//界面出现的时候让导航栏消失
- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden=YES;
    
//    self.tabBar.tabBarBg.hidden=YES;
    [self resumeAnimation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //这个属性必须打开否则返回的时候会出现黑边
    self.view.clipsToBounds=YES;
    //1.遮罩
    [self setupMaskView];
    //2.下边栏
    [self setupBottomBar];
    //3.提示文本
    [self setupTipTitleView];
    //4.顶部导航
//    [self setupNavView];
    [self addNavigationBar:0 title:@"扫一扫"];
    //5.扫描区域
    [self setupScanWindowView];
    //6.开始动画
    [self beginScanning];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];
    
}
- (void)setupMaskView
{
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7].CGColor;
    //设置宽度为100的边框
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, SCREEN.width + kBorderW + kMargin , SCREEN.width + kBorderW + kMargin);
    mask.center = CGPointMake(SCREEN.width * 0.5, SCREEN.height * 0.5);
    mask.sd_y = 0;
    
    [self.view addSubview:mask];
}
- (void)setupBottomBar
{
    //1.下边栏
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, EPScreenH * 0.9+4, EPScreenW, EPScreenH * 0.1)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    
    [self.view addSubview:bottomBar];
    
}
-(void)setupTipTitleView
{
    //1.补充遮罩
    
    UIView*mask=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.sd_y+_maskView.sd_height, SCREEN.width, kBorderW)];
    mask.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    [self.view addSubview:mask];
    
    //2.操作提示
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN.height*0.8, SCREEN.width, kBorderW)];
    tipLabel.text = @"将取景框对准二维码，即可自动扫描";
    tipLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255
                          /255.0 alpha:1.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:17];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
}
-(void)setupNavView
{
    //定义左边导航按钮
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(disMiss)];
    self.navigationItem.leftBarButtonItem = searchButtonItem;
    //更改导航栏背景图片
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:29/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0,EPScreenW -108,self.navigationController.navigationBar.frame.size.height)];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"扫一扫";
    titleLab.textColor=[UIColor colorWithRed:216/255.0 green:186/255.0 blue:131/255.0 alpha:1.0];
    titleLab.font=[UIFont fontWithName:@"ShiShangZhongHeiJianTi" size:20];
    self.navigationItem.titleView=titleLab;
}
- (void)setupScanWindowView
{
    CGFloat scanWindowH = EPScreenW - kMargin * 2;
    CGFloat scanWindowW = EPScreenW - kMargin * 2;
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW-4, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];
    
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.sd_x, bottomLeft.sd_y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
}
- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error)
    {
        //防止模拟器崩溃
        NSLog(@"没有摄像头设备");
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop=[self getScanCrop:_scanWindow.bounds readerViewBounds:BOUNDS];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=BOUNDS;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}
//获得的数据再次方法中
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_session stopRunning];
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject =metadataObjects[0];
        NSString * string =metadataObject.stringValue;
        
        
        EPScanResultVC * vc =[[EPScanResultVC alloc] initWithResultStr:string];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim)
    {
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }
    else
    {
        
        CGFloat scanNetImageViewH = 241;
        CGFloat scanWindowH = SCREEN.width - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.sd_width-8;
        
        _scanNetImageView.frame = CGRectMake(4, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.5;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
    
    
    
}
#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}
#pragma mark-> 返回
- (void)disMiss
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
