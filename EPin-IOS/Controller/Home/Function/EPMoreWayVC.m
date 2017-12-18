//
//  EPNotFindVC.m
//  EPin-IOS
//
//  Created by jeader on 16/4/29.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPMoreWayVC.h"
#import "HeaderFile.h"
#import "EPRouteInfo.h"
#import "EPLoginViewController.h"
#import "NSString+PlaceholderString.h"
#import "UIImageView+photoBrowser.h"

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

static NSString * const LostString = @"失物描述:";
static NSString * const LostDescribe = @"你可以把发票以照片的方式提交给我们,我们会尽快和司机师傅联系。";
static NSString * const LostDescribeDown = @"将丢失物品所在计程车的交易信息提供给我们,我们会及时和司机师傅联系。";

@class EPTool;

@interface EPMoreWayVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIImageView * imgView;
    
    //区头数组
    NSArray * titleArray;
    
    BOOL flag[2];
    //行程选择的label
    UILabel * _timeLab;
    NSMutableDictionary * infoDic;
}
@property (nonatomic, strong) UIView * tableViewHeaderView;
@property (nonatomic, strong) UIButton * picBtn;
@property BOOL isImg;

@end

@implementation EPMoreWayVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareForNav];
    self.tableVi.tableHeaderView = self.tableViewHeaderView;
    flag[0]=YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
//    [self.tableVi reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSection:) name:@"road" object:nil];
}
- (void)refreshSection:(NSNotification *)noti
{
    infoDic=[NSMutableDictionary dictionaryWithDictionary:noti.userInfo];
    //刷新第一组
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableVi reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)prepareForNav
{
    [self addNavigationBar:0 title:@"更多寻找方式"];
    
    self.tableVi.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableVi.separatorColor=[UIColor clearColor];
    titleArray=@[@"方式一: 我有计程车发票",@"方式二: 没有发票? 用易品APP支付车资"];
}

#pragma mark - 懒加载 表头
- (UIView *)tableViewHeaderView
{
    if (!_tableViewHeaderView)
    {
        //计算表头的动态高度
        NSString * describeString = [NSString stringByRealString:self.lostDescribe WithReplaceString:@"暂无描述"];
        CGFloat strHeight = [self heightWithString:describeString With:[UIFont boldSystemFontOfSize:14]];
        
        self.tableViewHeaderView = [[UIView alloc] init];
        self.tableViewHeaderView.frame = CGRectMake(0, 0, EPScreenW, strHeight+50);
        self.tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel= [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(15, 15, 100, 20);
        titleLabel.text = LostString;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = RGBColor(51, 51, 51);
        [self.tableViewHeaderView addSubview:titleLabel];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, CGRectGetMaxY(self.tableViewHeaderView.frame)-8, EPScreenW, 8);
        lineView.backgroundColor = RGBColor(238, 238, 238);
        [self.tableViewHeaderView addSubview:lineView];
        
        //设置Label富文本
        
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:describeString];
        
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
        
        style.firstLineHeadIndent = 30;
        
        style.alignment=0;
        
        //需要设置的范围
        NSRange range =NSMakeRange(0,describeString.length);
        
        [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
        
        UILabel * describeLab = [[UILabel alloc] init];
        describeLab.frame = CGRectMake(15, 38, EPScreenW - 30, strHeight);
        describeLab.text = describeString;
        describeLab.textColor = RGBColor(102, 102, 102);
        describeLab.font = [UIFont systemFontOfSize:14];
        describeLab.attributedText= text;
        describeLab.numberOfLines= 0;
        [self.tableViewHeaderView addSubview:describeLab];
        
    }
    return _tableViewHeaderView;
}

#pragma mark- UITable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag[section])
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier1 =@"cell1";
    static NSString * identifier2 =@"cell2";
    UITableViewCell * cell =nil;
    UITableViewCell * cell1 =nil;
    if (indexPath.section==0)
    {
        if (!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor=[UIColor whiteColor];
        
        //设置Label富文本
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:LostDescribe];
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
        style.firstLineHeadIndent = 25;
        style.alignment=0;
        //需要设置的范围
        NSRange range =NSMakeRange(0,LostDescribe.length);
        [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(20, 5, EPScreenW-40, 35);
        titleLab.text = LostDescribe;
        titleLab.textColor = RGBColor(51, 51, 51);
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.attributedText= text;
        titleLab.numberOfLines= 0;
        [cell.contentView addSubview:titleLab];
        
        _picBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _picBtn.frame=CGRectMake((EPScreenW-139)/2, 42, 139, 139);
        _picBtn.backgroundColor=RGBColor(142, 142, 142);
        [_picBtn setTitle:@"上传发票照片" forState:UIControlStateNormal];
        [_picBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0] forState:UIControlStateNormal];
        _picBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _picBtn.layer.masksToBounds=YES;
        _picBtn.layer.cornerRadius=5;
        [_picBtn addTarget:self action:@selector(uploadBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_picBtn];
        
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _picBtn.width, _picBtn.height)];
        [imgView showBiggerPhotoInview:self.view];
        imgView.hidden=YES;
        [_picBtn addSubview:imgView];
        
        UILabel * lab =[[UILabel alloc] initWithFrame:CGRectMake((EPScreenW-100)/2, CGRectGetMaxY(_picBtn.frame), 100, 20)];
        lab.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        lab.text=@"点击可预览";
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lab];
        
        UIButton * commitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.frame=CGRectMake(15, CGRectGetMaxY(lab.frame)+3, EPScreenW - 30, 40);
        commitBtn.backgroundColor=RGBColor(29, 32, 40);
        [commitBtn setTitle:@"提交照片" forState:UIControlStateNormal];
        [commitBtn setTitleColor:RGBColor(216, 187, 132) forState:UIControlStateNormal];
        commitBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        commitBtn.layer.masksToBounds=YES;
        commitBtn.layer.cornerRadius=5;
        commitBtn.tag=111;
        [commitBtn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:commitBtn];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, CGRectGetMaxY(commitBtn.frame)+5, EPScreenW, 8);
        lineView.backgroundColor = RGBColor(238, 238, 238);
        [cell.contentView  addSubview:lineView];
        
        return cell;
    }
    else
    {
        if (!cell1)
        {
            cell1=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell1.backgroundColor=[UIColor whiteColor];
        
        
        //设置Label富文本
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:LostDescribeDown];
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
        style.firstLineHeadIndent = 25;
        style.alignment=0;
        //需要设置的范围
        NSRange range =NSMakeRange(0,LostDescribeDown.length);
        [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(20, 5, EPScreenW-40, 35);
        titleLab.text = LostDescribeDown;
        titleLab.textColor = RGBColor(51, 51, 51);
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.attributedText= text;
        titleLab.numberOfLines= 0;
        [cell1.contentView addSubview:titleLab];
        
        _timeLab =[[UILabel alloc] initWithFrame:CGRectMake((EPScreenW-250)/2, CGRectGetMaxY(titleLab.frame)+15, 250, 60)];
        _timeLab.textColor=RGBColor(225, 18, 23);
        _timeLab.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelRecognizer:)];
        [_timeLab addGestureRecognizer:tap];
        
        NSString * lostStr =[infoDic objectForKey:@"lostInfo"];
        if (lostStr.length==0)
        {
            _timeLab.numberOfLines=0;
            _timeLab.textAlignment=NSTextAlignmentCenter;
            _timeLab.font=[UIFont systemFontOfSize:16];
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请点击选择行程"]];
            NSRange contentRange = {0,content.length};
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            _timeLab.attributedText = content;
        }
        else
        {
            _timeLab.numberOfLines=0;
            _timeLab.textAlignment=NSTextAlignmentCenter;
            _timeLab.font=[UIFont systemFontOfSize:16];
            _timeLab.text=lostStr;
            lostStr=@"";
        }
        [cell1.contentView addSubview:_timeLab];
        
        UIButton * choiceBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame=CGRectMake(15, CGRectGetMaxY(_timeLab.frame)+35, EPScreenW - 30, 40);
        choiceBtn.backgroundColor=RGBColor(29, 32, 40);
        [choiceBtn setTitle:@"提交照片" forState:UIControlStateNormal];
        [choiceBtn setTitleColor:RGBColor(216, 187, 132) forState:UIControlStateNormal];
        choiceBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        choiceBtn.layer.masksToBounds=YES;
        choiceBtn.layer.cornerRadius=5;
        choiceBtn.tag=222;
        [choiceBtn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.contentView addSubview:choiceBtn];
        
        return cell1;
    }
    
}
#pragma mark - 自定义区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //添加表头视图
    UIView * headerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, EPScreenW, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * wordLab =[[UILabel alloc] initWithFrame:CGRectMake(15, 8, EPScreenW-40, 20)];
    wordLab.text=[titleArray objectAtIndex:section];
    wordLab.textColor=RGBColor(51, 51, 15);
    wordLab.textAlignment=NSTextAlignmentLeft;
    [headerView addSubview:wordLab];
    
    //创建按钮
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    openBtn.frame =headerView.frame;
    openBtn.tag =section +10;
    [openBtn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:openBtn];
    
    //创建箭头
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.bounds=CGRectMake(0, 0, 8, 14);
    imageView.center=CGPointMake(EPScreenW-20, headerView.centerY);
    imageView.image = [UIImage imageNamed:@"失物_白箭头"];
    
    if (section == 0)
    {
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(15, CGRectGetMaxY(headerView.frame)-1, EPScreenW-30, 1);
        lineView.backgroundColor = RGBColor(153, 153, 153);
        [headerView addSubview:lineView];

    }
    
    //旋转方法 yes 展开
    if (flag[section])
    {
        imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else
    {
        imageView.transform =CGAffineTransformIdentity;
    }
    [headerView addSubview:imageView];
    
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (flag[indexPath.section])
    {
        if (indexPath.section==0)
        {
            return 258;
        }
        else
        {
            return 205;
        }
    }
    else
    {
        return 0;
    }
}
- (void)openOrClose:(UIButton *)button
{
    int section =(int)button.tag -10;
    int anotherSection =1-((int)button.tag-10);
    flag[section] = !flag[section];
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableVi reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    flag[anotherSection]= !flag[anotherSection];
    NSIndexSet * indexSet1 = [NSIndexSet indexSetWithIndex:anotherSection];
    [self.tableVi reloadSections:indexSet1 withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (void)uploadBtn:(UIButton *)btn
{
    if (IOS8)
    {
        UIAlertController * alertController =[UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //判断是否支持相机. 注:模拟器没有相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertAction * defaultAction =[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //相机
                UIImagePickerController * imagePickerController =[[UIImagePickerController alloc]init];
                imagePickerController.delegate=self;
                imagePickerController.allowsEditing=YES;
                imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            [alertController addAction:defaultAction];
        }
        else
        {
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        UIAlertAction * cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            
        }];
        
        [alertController addAction:cancelAction];
        
        //弹出视图使用UIViewController的方法
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIActionSheet * sheet;
        //判断是否支持相机. 注:模拟器没有相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet=[[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册获取", nil];
        }
        else
        {
            sheet =[[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册获取", nil];
        }
        [sheet showInView:self.view];
    }
    
}

#pragma mark - 调用UIActionSheet IOS7 调用
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    //判断是否支持相机 注:模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 1: // 相机
                sourceType=UIImagePickerControllerSourceTypeCamera;
                break;
            case 2: // 相册
                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;;
                break;
            default:
                break;
        }
    }
    else
    {
        if (buttonIndex== 1)
        {
            sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    //跳转到相机或者相册界面
    UIImagePickerController * imagePickerController =[[UIImagePickerController alloc] init];
    imagePickerController.delegate=self;
    imagePickerController.allowsEditing=YES;
    imagePickerController.sourceType=sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

//图片选择的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    imgView.hidden=NO;
    imgView.image=image;
    //保存在相册
    [self saveImageToPhotos:image];
    
//    设置image的尺寸
    CGSize imageSize =image.size;
    imageSize.height=160;
    imageSize.width=240;
////    对图片大小进行压缩
    image=[self OriginImage:image scaleToSize:imageSize];
    // 保存图片值本地 上传图片到服务器需要使用
    [self saveImage:image withName:@"bill.png"];
    [_picBtn setTitle:@"" forState:UIControlStateNormal];
    
}
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
        NSLog(@"%@",msg);
    }
    else
    {
        msg = @"保存图片成功" ;
        NSLog(@"%@",msg);
    }
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
- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    CGSize newSize;
    if (image.size.height / image.size.width > 1)
    {
        newSize.height = size.height;
        newSize.width = size.height / image.size.height * image.size.width;
    }
    else if(image.size.height / image.size.width < 1)
    {
        newSize.height = size.width / image.size.width * image.size.height;
        newSize.width = size.width;
    }
    else
    {
        newSize = size;
    }
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
////点击取消 然后让图片选择下降
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [_picBtn setTitle:@"上传发票照片" forState:UIControlStateNormal];
//}
- (void)choiceBtnClick:(UIButton *)button
{
    if (button.tag==111)
    {
        if (imgView.image)
        {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"lostID"] isEqualToString:self.lostId])
            {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"您已经上传照片,是否确认要覆盖?" count:1 doWhat:^{
                    [EPTool addMBProgressWithView:self.view style:0];
                    [EPTool showMBWithTitle:@"上传中\n..."];
                    EPData * data =[EPData new];
                    [data getTravelInfoWithlostId:self.lostId withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                        if ([returnCode intValue]==0)
                        {
                            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                            [us setObject:self.lostId forKey:@"lostID"];
                            [us synchronize];
                            
                            [EPTool hiddenMBWithDelayTimeInterval:0];
                            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"提交照片成功" count:0 doWhat:nil];
                            [self.tableVi reloadData];
                        }
                        else if ([returnCode intValue]==1)
                        {
                            [EPTool hiddenMBWithDelayTimeInterval:0];
                            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                        }
                        else if ([returnCode intValue]==2)
                        {
                            [EPTool hiddenMBWithDelayTimeInterval:0];
                            //已在别处登录
                            [EPLoginViewController publicDeleteInfo];
                            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
                                EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                                [self presentViewController:vc animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [EPTool hiddenMBWithDelayTimeInterval:0];
                            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，提交失败,请稍后重试" count:0 doWhat:nil];
                        }
                    }];
                }];
            }
            else
            {
                [EPTool addMBProgressWithView:self.view style:0];
                [EPTool showMBWithTitle:@"上传中\n..."];
                EPData * data =[EPData new];
                [data getTravelInfoWithlostId:self.lostId withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                    if ([returnCode intValue]==0)
                    {
                        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
                        [us setObject:self.lostId forKey:@"lostID"];
                        [us synchronize];
                        
                        [infoDic removeAllObjects];
                        
                        [EPTool hiddenMBWithDelayTimeInterval:0];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"提交照片成功" count:0 doWhat:nil];
                        [self.tableVi reloadData];
                    }
                    else if ([returnCode intValue]==1)
                    {
                        [EPTool hiddenMBWithDelayTimeInterval:0];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                    }
                    else if ([returnCode intValue]==2)
                    {
                        [EPTool hiddenMBWithDelayTimeInterval:0];
                        //已在别处登录
                        [EPLoginViewController publicDeleteInfo];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:1 doWhat:^{
                            EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                            [self presentViewController:vc animated:YES completion:nil];
                        }];
                    }
                    else
                    {
                        [EPTool hiddenMBWithDelayTimeInterval:0];
                        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"由于网络问题，提交失败,请稍后重试" count:0 doWhat:nil];
                    }
                }];
            }
        }
        else
        {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [EPTool addAlertViewInView:self title:@"错误" message:@"未获取到照片,请重新拍照" count:0 doWhat:nil];
        }
    }                         
    else
    {
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@"正在提交..."];
        
        if (![_timeLab.text isEqualToString:@"请点击选择行程"])
        {
            EPData * data =[EPData new];
            NSString * lostNumber =[infoDic objectForKey:@"lostNum"];
            [data getTravelInfoWithNumber:lostNumber withLostId:self.lostId withType:@"1" withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
                
                if ([returnCode intValue]==0)
                {
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                    [self.tableVi reloadData];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:@"提交成功!\n您的提交我们已经受理,我们将尽快处理并向您发送消息通知" count:0 doWhat:^{
                        _timeLab.textAlignment=NSTextAlignmentCenter;
                        _timeLab.font=[UIFont systemFontOfSize:16];
                        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请点击选择行程"]];
                        NSRange contentRange = {0,content.length};
                        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                        _timeLab.attributedText = content;
                        
                        NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
                        [us setObject:@"" forKey:@""];
                        [us synchronize];
                        
                    }];
                }
                else if ([returnCode intValue]==1)
                {
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
                }
                else if ([returnCode intValue]==2)
                {
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                    [EPLoginViewController publicDeleteInfo];
                    [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                        EPLoginViewController * vc =[[EPLoginViewController alloc] init];
                        [self presentViewController:vc animated:YES completion:nil];
                    }];
                }
                else
                {
                    [EPTool hiddenMBWithDelayTimeInterval:0];
                    [EPTool addAlertViewInView:self title:@"" message:@"网络似乎有些问题请重试" count:0 doWhat:nil];
                }
                
            }];
        }
        else
        {
            [EPTool hiddenMBWithDelayTimeInterval:0];
            [EPTool addAlertViewInView:self title:@"错误" message:@"您还没有选择行程" count:0 doWhat:^{
                
        }];
        }
    }
}
- (void)labelRecognizer:(UITapGestureRecognizer *)tap
{
    EPRouteInfo * vc =[[EPRouteInfo alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)heightWithString:(NSString *)str With:(UIFont *)wordFont
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(EPScreenW - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : wordFont} context:nil];
    CGFloat stringHeight = rect.size.height;
    
    return stringHeight;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
