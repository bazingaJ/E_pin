//
//  EPCommentVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/11/25.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCommentVC.h"
#import "HeaderFile.h"
#import "SSZipArchive.h"
#define starBtnTag 900
@interface EPCommentVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITableView * tb;

@property(nonatomic,strong)UIImage * selectImg;
@property(nonatomic,strong)UIImage * selectImg2;
@property(nonatomic,strong)UIImage * selectImg3;
@property(nonatomic,strong)UIView * backVC;
@property(nonatomic,strong)UILabel * hideLb;
//内容
@property(nonatomic,strong)UITextView * tvContent;

@end

@implementation EPCommentVC
{
    BOOL _isRefresh;
}
static int count=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:self.navTitle];
    [self tb];
    _isRefresh=NO;
    [self addTableFooter];
}
- (void)publishBtnClick{
    int starCount=0;
    for (NSInteger i = 900; i <=904; i++)
    {
        UIButton *starBtn = (UIButton *)[_backVC viewWithTag:i];
        if (starBtn.selected==YES) {
            starCount++;
        }
    }
    NSString * star=[NSString stringWithFormat:@"%d",starCount];
    switch (count) {
        case 0:
        {
            break;
        }
        case 1:{
             NSString * imagePath1 =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/comment1.png"];
             NSArray *inputPaths = [NSArray arrayWithObjects:
                                   imagePath1, nil];
             NSString * zipPath=[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/pic.zip"];
            [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:inputPaths];
            break;
        }
        case 2:{
            NSString * imagePath1 =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/comment1.png"];
            NSString * imagePath2 =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/comment2.png"];
            NSArray *inputPaths = [NSArray arrayWithObjects:
                                   imagePath1,
                                   imagePath2, nil];
             NSString * zipPath=[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/pic.zip"];
            [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:inputPaths];

            break;
        }
        case 3:{
            NSString * imagePath1 =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/comment1.png"];
            NSString * imagePath2 =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/comment2.png"];
            NSString * imagePath3 =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/comment3.png"];
            NSArray *inputPaths = [NSArray arrayWithObjects:
                                   imagePath1,
                                   imagePath2,imagePath3, nil];
            NSString * zipPath=[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/pic.zip"];
            [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:inputPaths];
            break;
        }
        default:
            break;
    }
    if (starCount==0||self.tvContent.text.length==0) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请对所有评价项进行评价" count:0 doWhat:nil];
    }else{
        [EPTool checkNetWorkWithCompltion:^(NSInteger statusCode) {
            if (statusCode==0) {
                [EPTool addMBProgressWithView:self.view style:0];
                [EPTool showMBWithTitle:@"当前网络不可用"];
                [EPTool hiddenMBWithDelayTimeInterval:1];
            }else{
                [self postCommentData:star withContent:self.tvContent.text];
            }
        }];
    }
}
- (void)postCommentData:(NSString *)starCount withContent:(NSString *)content{
    [EPTool addMBProgressWithView:self.view style:0];
    [EPTool showMBWithTitle:@"提交中..."];
    NSString * str =[NSString stringWithFormat:@"%@/getMyCommentInfo.json",EPUrl];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"type",PHONENO,@"phoneNo",LOGINTIME,@"loginTime",self.goodsId,@"goodsId",starCount,@"star",content,@"comtent",self.orderId,@"orderId",nil];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    manager.requestSerializer.timeoutInterval=10;
    [manager POST:str parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData * data =[[NSData alloc]initWithContentsOfFile:[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/pic.zip"]];
        /**
         *  1参将要上传的数据
         *  2参你上传的参数的名称
         *  3参定义你上传的文件的名称
         *  4参你上传的文件的类型
         */
        [formData appendPartWithFileData:data name:@"file" fileName:@"pic.zip" mimeType:@"application/octet-stream"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [EPTool hiddenMBWithDelayTimeInterval:0];
        NSLog(@"%@",responseObject);
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode integerValue]==0) {
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"评论提交成功" count:0 doWhat:^{
                 [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if ([returnCode integerValue]==1){
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
        }else if ([returnCode integerValue]==2){
            [EPLoginViewController publicDeleteInfo];
             EPLoginViewController * login=[[EPLoginViewController alloc]init];
            [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:^{
                [self presentViewController:login animated:YES completion:nil];
            }];
        }else{
            [EPTool addAlertViewInView:self title:@"温馨提示" message:@"网络连接失败，评论提交失败，请稍后重试" count:0 doWhat:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)addTableFooter{
    UIView * vc=[[UIView alloc]init];
    vc.frame=CGRectMake(0, 0, EPScreenW,125);
    self.tb.tableFooterView=vc;
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [vc addSubview:btn];
    btn.frame=CGRectMake(WIDTH(55.0, 337),95, EPScreenW-WIDTH(55.0, 337)*2, 30);
    btn.backgroundColor=RGBColor(29, 32, 40);
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    [btn setTitle:@"发  布" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:11];
    [btn setTitleColor:RGBColor(217, 186, 129) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addImgcommment{
    if (count>=3) {
         [EPTool addAlertViewInView:self title:@"温馨提示" message:@"最多只能添加3张图片奥" count:0 doWhat:nil];
    }else{
        UIAlertController * alertController =[UIAlertController alertControllerWithTitle:@"获取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * defaultAction =[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //相机
            UIImagePickerController * imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.delegate=self;
            imagePickerController.allowsEditing=YES;
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        [alertController addAction:defaultAction];
        UIAlertAction * photoaction =[UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //相机
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            // 打开相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            picker.delegate =self;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertController addAction:photoaction];
        UIAlertAction * cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           
                                       }];
        
        [alertController addAction:cancelAction];
        
        //弹出视图使用UIViewController的方法
        [self presentViewController:alertController animated:YES completion:nil];
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
- (void)selectPic:(UIImage *)img{
    count++;
    if (count==1) {
         self.selectImg=img;
        [self saveImage:img withName:@"comment1.png"];
    }
    if (count==2) {
        self.selectImg2=img;
        [self saveImage:img withName:@"comment2.png"];

    }
    if (count==3) {
        self.selectImg3=img;
        [self saveImage:img withName:@"comment3.png"];

    }
    _isRefresh=YES;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
//图片选择的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取照片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0];
    CGSize imageSize =image.size;
    imageSize.height=70;
    imageSize.width=70;
    //对图片大小进行压缩
    image=[self OriginImage:image scaleToSize:imageSize];
    //保存图片沙河
    [self saveImage:image withName:@"comment.png"];
   // [self postHeadData:@[image]];
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)addStar:(UIButton *)btn{
    for (NSInteger i = 900; i <=904; i++) {
        UIButton *starBtn = (UIButton *)[_backVC viewWithTag:i];
        if (i <= btn.tag) {
            starBtn.selected=YES;
        } else {
            starBtn.selected=NO;
        }
    }}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellId";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat leftX=15;
    if (indexPath.section==0) {
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        _backVC=vc;
        vc.frame=CGRectMake(0, 0,EPScreenW ,151);
        vc.backgroundColor=[UIColor whiteColor];
        UIView * line=[[UIView alloc]init];
        [vc addSubview:line];
        line.frame=CGRectMake(0, 150, EPScreenW, 1);
        line.backgroundColor=RGBColor(17, 17, 17);
        
        for (int i=0; i<2; i++) {
            UIView * line1=[[UIView alloc]init];
            [vc addSubview:line1];
            line1.frame=CGRectMake(leftX, (i+1)*39, EPScreenW-2*leftX, 1);
            line1.backgroundColor=RGBColor(206, 206, 206);
        }
        UILabel * goodName=[[UILabel alloc]init];
        [vc addSubview:goodName];
        goodName.frame=CGRectMake(leftX, 0, EPScreenW-2*leftX, 39);
        goodName.font=[UIFont systemFontOfSize:15];
        goodName.textColor=RGBColor(51, 51, 51);
        goodName.text=[NSString stringWithFormat:@"消费物品: %@",self.goodName];
        CGFloat maxY=39;
        UILabel * fenLb=[[UILabel alloc]init];
        [vc addSubview:fenLb];
        fenLb.frame=CGRectMake(leftX, maxY,70, 39);
        fenLb.font=[UIFont systemFontOfSize:15];
        fenLb.textColor=RGBColor(51, 51, 51);
        fenLb.text=@"打个分吧:";
        CGFloat maxX=CGRectGetMaxX(fenLb.frame);
        for (NSInteger i=0; i<5; i++) {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [vc addSubview:btn];
            btn.size=CGSizeMake(30, 30);
            btn.y=maxY+(39-30)/2;
            btn.x=maxX+(30+5)*i;
            btn.tag=starBtnTag+i;
            [btn setImage:[UIImage imageNamed:@"空心五角星"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"实心五角星"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(addStar:) forControlEvents:UIControlEventTouchUpInside];
           
        }
        UITextView * tf=[[UITextView alloc]init];
        [vc addSubview:tf];
        tf.frame=CGRectMake(leftX, maxY*2+5, EPScreenW-2*leftX, 67);
        tf.font=[UIFont systemFontOfSize:11];
        tf.textColor=RGBColor(51, 51, 51);
        tf.delegate=self;
        self.tvContent=tf;
        
        UILabel * lb=[[UILabel alloc]init];
        [tf addSubview:lb];
        lb.frame=CGRectMake(10, 0, EPScreenW-2*leftX-10, 20);
        lb.font=[UIFont systemFontOfSize:11];
        lb.textColor=RGBColor(144, 144, 144);
        lb.text=@"有了您的点评，我们会很高兴的哦! ~";
        lb.tag=800;
        }
    if (indexPath.section==1) {
//        NSLog(@"刷新后数量%d",count);
//        NSLog(@"选中后图片%@",self.selectImg);
        CGFloat width=(EPScreenW-50)/4;
        CGFloat space=10;
        UIView * vc=[[UIView alloc]init];
        [cell.contentView addSubview:vc];
        vc.width=EPScreenW;
        vc.height=space*2+width;;
        vc.x=0;
        vc.y=0;
        vc.backgroundColor=[UIColor whiteColor];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [vc addSubview:btn];
        btn.x=space;
        btn.y=space;
        btn.width=width;
        btn.height=width;
        [btn setImage:[UIImage imageNamed:@"加号按钮"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addImgcommment) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * img1=[[UIImageView alloc]init];
        img1.x=space;
        img1.width=width;
        img1.height=width;
        img1.y=space;
        img1.layer.masksToBounds=YES;
        img1.layer.cornerRadius=5;
        UIImageView * img2=[[UIImageView alloc]init];
        img2.x=2*space+width;
        img2.width=width;
        img2.height=width;
        img2.y=space;
        img2.layer.masksToBounds=YES;
        img2.layer.cornerRadius=5;
        UIImageView * img3=[[UIImageView alloc]init];
        img3.x=3*space+width*2;
        img3.width=width;
        img3.height=width;
        img3.y=space;
        img3.layer.masksToBounds=YES;
        img3.layer.cornerRadius=5;
        switch (count) {
            case 1:
            {
                img1.image=self.selectImg;
                [vc addSubview:img1];
                btn.x=(count+1)*space+width;
                break;
            }
            case 2:{
                img1.image=self.selectImg;
                [vc addSubview:img1];
                img2.image=self.selectImg2;
                [vc addSubview:img2];
                btn.x=(count+1)*space+count*width;
                break;
            }
            case 3:{
                img1.image=self.selectImg;
                [vc addSubview:img1];
                img2.image=self.selectImg2;
                [vc addSubview:img2];
                img3.image=self.selectImg3;
                [vc addSubview:img3];
                btn.x=(count+1)*space+count*width;
                break;
            }
            default:
                break;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 151;
    }else{
        return 10*2+(EPScreenW-50)/4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 8;
    }else{
        return 0;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    UILabel * lb=(UILabel *)[textView viewWithTag:800];
    lb.hidden=YES;
}
- (void)keyDown{
    [self.view endEditing:YES];
}
- (UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, EPScreenW, EPScreenH-64) style:UITableViewStylePlain];
        _tb.backgroundColor=RGBColor(238, 238, 238);
        _tb.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tb.dataSource=self;
        _tb.delegate=self;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyDown)];
        [_tb addGestureRecognizer:tap];
        _tb.userInteractionEnabled=YES;
        [self.view addSubview:_tb];
        
    }
    return _tb;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
