//
//  EPPerViewController.m
//  EPin-IOS
//
//  Created by jeaderL on 16/3/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPPerViewController.h"
#import "EPPerTableViewCell.h"
#import "EPNameTableViewCell.h"
#import "HeaderFile.h"
#import "EPPassViewController.h"
#import "EPMNameViewController.h"
#import "EPCustomAlertView.h"
#import "EPPhoneChangeVC.h"
@interface EPPerViewController ()<UITableViewDelegate,UITableViewDataSource,EPCustomAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView * tb;

//声明改变昵称界面
@property(nonatomic,strong)EPMNameViewController * mNameVc;

/**提示框*/
@property(nonatomic,strong)UIView * alertView;
/**背景图层*/
@property(nonatomic,strong)UIView * backView;

@property(nonatomic,strong)EPPerTableViewCell * cell1;

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * nPassword;
@property(nonatomic,strong)EPLoginViewController * loginVC;


@end

@implementation EPPerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏
    [self addNavigationBar:0 title:@"个人中心"];
    [self tb];
    _mNameVc=[[EPMNameViewController alloc]init];
    _loginVC=[[EPLoginViewController alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(namePop) name:@"passSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(namePop) name:@"phoneSuccess" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tb reloadData];
}
- (void)namePop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)postHeadData:(NSArray *)images
{
    NSDictionary * dict=@{@"type":@"0",@"phoneNo":PHONENO,@"loginTime":LOGINTIME};
    NSString * url=[NSString  stringWithFormat:@"%@/changePersonalInfo.json",EPUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/xml",nil]];
    
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (images==nil) {
            return ;
        }
        for (UIImage *image in images) {
            NSData *imageData = UIImagePNGRepresentation(image);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:imageData name:@"newIcon" fileName:fileName mimeType:@"image/png"];
            
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        NSInteger returnCode=[responseObject[@"returnCode"] integerValue];
        if (returnCode==0) {
            //NSLog(@"上传头像成功");
        }else{
            if (returnCode==1) {
                //NSLog(@"上传头像失败");
            }else{
                if (returnCode==2) {
                    [EPLoginViewController publicDeleteInfo];
                    NSString * msg=responseObject[@"msg"];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                        [self presentViewController:_loginVC animated:YES completion:nil];
                    }];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
    
    
}
//实现回调昵称方法
- (void)returnText:(ReturnTextBlock)block
{
    self.returnTextBlock = block;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID=@"cellID";
    UITableViewCell * cell3=[tableView dequeueReusableCellWithIdentifier:cellID];
    cell3=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                self.cell1=[tableView dequeueReusableCellWithIdentifier:@"EPPerTableViewCell"];
                self.cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.cell1.selectionStyle=UITableViewCellSelectionStyleNone;
                self.cell1.headImg.image=self.hImg;
                return self.cell1;
                break;
            }
            case 1:
            {
                EPNameTableViewCell * cell2=[tableView dequeueReusableCellWithIdentifier:@"EPNameTableViewCell"];
                cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell2.nameLb.text=self.cellName;
                cell2.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell2;
            }
                
            default:
                break;
        }
    }
    if (indexPath.section==0||indexPath.row==2)
    {
        cell3.textLabel.text=@"手机号";
        //cell3.detailTextLabel.text=PHONENO;
        NSString * str1=[PHONENO substringToIndex:3];
        NSString * str2=[PHONENO substringFromIndex:7];
        cell3.detailTextLabel.text=[NSString stringWithFormat:@"%@****%@",str1,str2];
        
    }
    if (indexPath.section==1)
    {
            cell3.textLabel.text=@"修改登录密码";
    }
    return cell3;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            return  75;
        }
        else
        {
            return 50;
        }
    }
    else
    {
      return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                //更换头像
                // UIView动画
                [UIView animateWithDuration:0.1 animations:^{
                    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    [self.view addSubview:self.backView];
                    [self.view addSubview:self.alertView];
                    self.backView.alpha=0.6;
                    self.backView.hidden=NO;
                    self.alertView.alpha = 1;
                    self.alertView.hidden = NO;
                    
                }];
                
                break;
            }
            case 1:
            {
                //回调传值昵称
                [_mNameVc returnText:^(NSString *showText) {
                    self.cellName = showText;
                    //回调修改昵称
                    if (self.returnTextBlock != nil)
                    {
                        self.returnTextBlock(showText);
                    }
                    
                }];
                
                [self.navigationController pushViewController:_mNameVc animated:YES];
                break;
            }
            case 2:
            {
                EPPhoneChangeVC * phoneVc=[[EPPhoneChangeVC alloc]init];
                [self.navigationController pushViewController:phoneVc animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
    if (indexPath.section==1)
    {
        EPPassViewController  * pass=[[EPPassViewController alloc]init];
        [self.navigationController pushViewController:pass animated:YES];
    }
}
//获取图片显示保存
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取照片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0];
    CGSize imageSize =image.size;
    imageSize.height=110;
    imageSize.width=110;
    //对图片大小进行压缩
    image=[self OriginImage:image scaleToSize:imageSize];
    //保存图片沙河
    [self saveImage:image withName:@"head.png"];
    [self postHeadData:@[image]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    CGSize newSize;
    newSize.width = size.height / image.size.height * image.size.width;
    newSize.height = size.width / image.size.width * image.size.height;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context  568x375
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData * imageData =UIImagePNGRepresentation(currentImage);
    //获取沙盒目录
    NSString * fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
    //将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
}
//选中图片
- (void)selectPic:(UIImage *)image
{
    
    self.cell1.headImg.image=image;
    self.hImg=image;
    //通知修改头像
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getHead" object:self.hImg];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableView *)tb
{
    if (!_tb)
    {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0,64, EPScreenW, CGRectGetHeight(self.view.frame)-49) style:UITableViewStyleGrouped];
        _tb.separatorInset=UIEdgeInsetsMake(46, 20, 1, 20);
        _tb.separatorColor=RGBColor(238,238, 238);
        _tb.delegate=self;
        _tb.dataSource=self;
        [_tb registerNib:[UINib nibWithNibName:@"EPPerTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPPerTableViewCell"];
        [_tb registerNib:[UINib nibWithNibName:@"EPNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPNameTableViewCell"];
        [self.view addSubview:_tb];
    }
    return _tb;
}

/**提示框懒加载*/
- (UIView *)alertView
{
    if (!_alertView)
    {
        // 赋值
        _alertView = [[EPCustomAlertView singleClass]quickAlertViewWithArray:@[@"更换头像",@"拍照",@"从相册选择"]
                      ];
        _alertView.frame=CGRectMake(56, 154+64, EPScreenW-112, 153);
        // 切圆角
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 10;
        // 初始状态为隐藏,透明度为0
        _alertView.hidden = YES;
        _alertView.alpha = 0.0;
        
        // 设置代理
        [EPCustomAlertView singleClass].delegate = self;
        
    }
    return _alertView;
}

//背景
- (UIView *)backView
{
    if (_backView==nil)
    {
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, CGRectGetHeight(self.view.frame))];
        _backView.backgroundColor=[UIColor blackColor];
        _backView.alpha=0;
        _backView.hidden=YES;
        //添加一个点击手势，点击时使alertView消失
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)]];
        //打开交互
        _backView.userInteractionEnabled=YES;
    }
    return _backView;
}
//实现手势点击方法
- (void)viewClick:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0 animations:^{
        self.alertView.alpha = 0;
        self.backView.alpha=0;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    } completion:^(BOOL finished) {
        //动画结束之后进行隐藏
        self.alertView.hidden = YES;
        self.backView.hidden=YES;
    }];
}
// 代理方法传值
- (void)didSelectAlertButton:(NSString *)title
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alertView.alpha = 0;
        self.backView.alpha=0;
    } completion:^(BOOL finished) {
        //动画结束之后进行隐藏
        self.alertView.hidden = YES;
        self.backView.hidden=YES;
    }];
    if ([title isEqualToString:@"拍照"])
    {
        //进入拍照
        [self takePicture];
    }
    if ([title isEqualToString:@"从相册选择"])
    {
        //进入相册
        [self openPictureLibrary];
    }
}
//打开相册
- (void)openPictureLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary ])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        // 打开相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        picker.delegate =self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}
//进入相机拍照界面
- (void)takePicture
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"模拟器没有摄像头" count:0 doWhat:nil];
    }
    
}

@end
