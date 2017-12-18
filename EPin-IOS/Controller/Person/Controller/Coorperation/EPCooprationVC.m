//
//  EPCooprationVC.m
//  EPin-IOS
//
//  Created by jeaderL on 2016/11/21.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPCooprationVC.h"
#import "HeaderFile.h"

@interface EPCooprationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView * tb;
@property(nonatomic,strong)UITextField * tfName;
@property(nonatomic,strong)UITextField * tfAdd;
@property(nonatomic,strong)UILabel * lbType;
@property(nonatomic,strong)UILabel * lbRange;
@property(nonatomic,strong)UITextField * tfphone;
@property(nonatomic,strong)UITextField * tfWechat;
@property(nonatomic,strong)UITextField * tfQQ;

@end

@implementation EPCooprationVC
{
    BOOL _isOpen1;
    BOOL _isOpen2;
    BOOL _quan1;
    BOOL _quan2;
    BOOL _quan3;
    BOOL _quan4;
    BOOL _quan5;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar:0 title:@"填写资料"];
    [self setTableViewHeader];
    [self tb];
    [self creatSubBtn];
    _isOpen1=NO;
    _isOpen2=NO;
    _quan1=NO;
    _quan2=NO;
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘显示
- (void)keyBoardWillShow:(NSNotification *)no{
    
    NSDictionary * info=[no userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //获取键盘的大小
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = CGRectMake(0,64, EPScreenW, EPScreenH-49-50-20);
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y-50-20;
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tb.frame=newTextViewFrame;
    
    [UIView commitAnimations];
    
}
//键盘隐藏
- (void)keyBoardWillHide:(NSNotification *)no{
    
    NSDictionary* userInfo = [no userInfo];
    //获取键盘隐藏时变化的值
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.tb.frame=CGRectMake(0,64, EPScreenW, EPScreenH-50-20-49);
    //提交动画
    [UIView commitAnimations];
    
}
- (void)submitMessage{
    if (_tfName.text.length==0) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"商户名称不能为空" count:0 doWhat:nil];
    }else if (_tfAdd.text.length==0){
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"商户地址不能为空" count:0 doWhat:nil];
    }else if (_lbType.text.length==0){
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请选择商户类型" count:0 doWhat:nil];
    }else if (_lbRange.text.length==0){
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请选择经营范围" count:0 doWhat:nil];
    }else if (_tfphone.text.length==0){
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"手机号码不能为空" count:0 doWhat:nil];
    }else if (_tfWechat.text.length==0&&_tfQQ.text.length==0){
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请至少输入微信和QQ中的一项" count:0 doWhat:nil];
    }else{
        [self postCooprationData];
    }
}
- (void)postCooprationData{
    if (![EPTool validatePhone:_tfphone.text]) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"请输入正确的手机号" count:0 doWhat:nil];
    }else{
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@"提交中..."];
        NSString * str =[NSString stringWithFormat:@"%@/getCooprationData.json",EPUrl];
        NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:PHONENO,@"phoneNo",LOGINTIME,@"loginTime",_tfName.text,@"shopName",_tfAdd.text,@"shopAddress",_lbType.text,@"shopType",_lbRange.text,@"shopRange",_tfphone.text,@"phone",_tfWechat.text,@"wechat",_tfQQ.text,@"qq", nil];
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        [manager POST:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            int returnCode=[responseObject[@"returnCode"] intValue];
            NSString * msg=responseObject[@"msg"];
            [EPTool hiddenMBWithDelayTimeInterval:0];
            if (returnCode==0) {
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"提交资料成功" count:0 doWhat:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else if (returnCode==1){
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }else if (returnCode==2){
                [EPLoginViewController publicDeleteInfo];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0  doWhat:^{
                    
                    EPLoginViewController * vc=[[EPLoginViewController alloc]init];
                    [self presentViewController:vc animated:YES completion:nil];
                }];
            }else{
                [EPTool addAlertViewInView:self title:@"温馨提示" message:@"资料提交失败，请稍后重试" count:1 doWhat:^{
                    [self postCooprationData];
                }];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];

    }
}

- (void)creatSubBtn{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame=CGRectMake(0, EPScreenH-49, EPScreenW, 49);
    btn.backgroundColor=RGBColor(22, 24, 30);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(250, 207, 131) forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:18];
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(submitMessage) forControlEvents:UIControlEventTouchUpInside];
}
- (void)keyDown{
    [self.view endEditing:YES];
}
/**设置tableviewHeader*/
- (void)setTableViewHeader{
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,EPScreenW,HEIGHT(152.0, 667))];
    img.image=[UIImage imageNamed:@"banner新"];
    img.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyDown)];
    [img addGestureRecognizer:tap];
    self.tb.tableHeaderView=img;
    UIView * foot=[[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor=RGBColor(238, 238, 238);
    self.tb.tableFooterView=foot;
}
- (void)clickTypeOpen{
    if (_isOpen1==YES) {
        _isOpen1=NO;
    }else{
        _isOpen1=YES;
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)clickRangeOpen{
    if (_isOpen2==YES) {
        _isOpen2=NO;
    }else{
        _isOpen2=YES;
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.tb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        if (_isOpen1==YES) {
            return 2;
        }else{
            return 0;
        }
    }else if (section==3){
        if (_isOpen2==YES) {
            return 3;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellID";
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (indexPath.section==2) {
        UIView * line=[[UIView alloc]init];
        line.frame=CGRectMake(15, 0, EPScreenW-30, 1);
        line.backgroundColor=RGBColor(238, 238, 238);
        [cell.contentView addSubview:line];
        UILabel * lb=[[UILabel alloc]init];
        [cell.contentView addSubview:lb];
        lb.frame=CGRectMake(15, 0, 40,25);
        lb.textColor=RGBColor(51, 51, 51);
        lb.font=[UIFont systemFontOfSize:12];
        UIImageView * img=[[UIImageView alloc]init];
        CGSize ss=[UIImage imageNamed:@"空心选择圆"].size;
        [cell.contentView addSubview:img];
        img.size=ss;
        img.y=(25-ss.height)/2;
        img.x=EPScreenW-15-ss.width;
        
        if (indexPath.row==0) {
            if (_quan1==NO) {
                img.image=[UIImage imageNamed:@"空心选择圆"];
            }else{
                img.image=[UIImage imageNamed:@"实心选择圆"];
            }
            lb.text=@"个体";
        }else{
            if (_quan2==NO) {
                img.image=[UIImage imageNamed:@"空心选择圆"];
            }else{
                img.image=[UIImage imageNamed:@"实心选择圆"];
            }
            
            lb.text=@"企业";
        }
    }
    if (indexPath.section==3) {
        UIView * line=[[UIView alloc]init];
        line.frame=CGRectMake(15, 0, EPScreenW-30, 1);
        line.backgroundColor=RGBColor(238, 238, 238);
        [cell.contentView addSubview:line];
        UILabel * lb=[[UILabel alloc]init];
        [cell.contentView addSubview:lb];
        lb.frame=CGRectMake(15, 0, 40,25);
        lb.textColor=RGBColor(51, 51, 51);
        lb.font=[UIFont systemFontOfSize:12];
        UIImageView * img=[[UIImageView alloc]init];
        CGSize ss=[UIImage imageNamed:@"空心选择圆"].size;
        [cell.contentView addSubview:img];
        img.size=ss;
        img.y=(25-ss.height)/2;
        img.x=EPScreenW-15-ss.width;
        img.image=[UIImage imageNamed:@"空心选择圆"];
        if (indexPath.row==0) {
            if (_quan3==NO) {
                img.image=[UIImage imageNamed:@"空心选择圆"];
            }else{
                img.image=[UIImage imageNamed:@"实心选择圆"];
            }
            lb.text=@"餐饮";
        }else if(indexPath.row==1){
            if (_quan4==NO) {
                img.image=[UIImage imageNamed:@"空心选择圆"];
            }else{
                img.image=[UIImage imageNamed:@"实心选择圆"];
            }
            lb.text=@"超市";
        }else{
            if (_quan5==NO) {
                img.image=[UIImage imageNamed:@"空心选择圆"];
            }else{
                img.image=[UIImage imageNamed:@"实心选择圆"];
            }
            lb.width=80;
            lb.text=@"休闲娱乐";
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        switch (indexPath.row) {
            case 0:
            {
                _isOpen1=NO;
                _quan1=YES;
                _quan2=NO;
                break;
            }
            case 1:{
                _isOpen1=NO;
                _quan2=YES;
                _quan1=NO;
                break;
            }
            default:
                break;
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.tb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (indexPath.section==3) {
        switch (indexPath.row) {
            case 0:
            {
                _isOpen2=NO;
                _quan3=YES;
                _quan4=NO;
                _quan5=NO;
                break;
            }
            case 1:
            {
                _isOpen2=NO;
                _quan4=YES;
                _quan3=NO;
                _quan5=NO;
                break;
            }
            case 2:
            {
                _isOpen2=NO;
                _quan5=YES;
                _quan4=NO;
                _quan3=NO;
                break;
            }
            default:
                break;
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [self.tb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * vc=[[UIView alloc]init];
    CGFloat leftX=15;
    if (section==1||section==4) {
        vc.backgroundColor=RGBColor(238, 238, 238);
        vc.frame=CGRectMake(0, 0, EPScreenW,8);
    }else{
        vc.backgroundColor=[UIColor whiteColor];
        if (section==0) {
            CGFloat minY=(46-16)/2;
            UIView * line=[[UIView alloc]init];
            [vc addSubview:line];
            line.frame=CGRectMake(leftX, 46, EPScreenW-30, 1);
            line.backgroundColor=RGBColor(238, 238, 238);
            UILabel * nameLb=[[UILabel alloc]init];
            [vc addSubview:nameLb];
            nameLb.frame=CGRectMake(leftX, minY, 65, 16);
            nameLb.text=@"商户名称:";
            nameLb.font=[UIFont systemFontOfSize:14];
            nameLb.textColor=RGBColor(51, 51, 51);
            UILabel * addLb=[[UILabel alloc]init];
            [vc addSubview:addLb];
            addLb.frame=CGRectMake(leftX, minY+CGRectGetMaxY(line.frame), 65, 16);
            addLb.text=@"商户地址:";
            addLb.font=[UIFont systemFontOfSize:14];
            addLb.textColor=RGBColor(51, 51, 51);
            //内容
            UITextField * nameTf=[[UITextField alloc]init];
            [vc addSubview:nameTf];
            nameTf.frame=CGRectMake(CGRectGetMaxX(nameLb.frame)+5,(46-30)/2 , EPScreenW-30-70, 30);
            nameTf.font=[UIFont systemFontOfSize:15];
            nameTf.textColor=RGBColor(51, 51, 51);
            _tfName=nameTf;
            UITextField * addTf=[[UITextField alloc]init];
            [vc addSubview:addTf];
            addTf.frame=CGRectMake(CGRectGetMaxX(addLb.frame)+5,(46-30)/2+46 , EPScreenW-30-70, 30);
            addTf.font=[UIFont systemFontOfSize:15];
            addTf.textColor=RGBColor(51, 51, 51);
            _tfAdd=addTf;
        }
        if (section==2) {
            UILabel * typeLb=[[UILabel alloc]init];
            [vc addSubview:typeLb];
            typeLb.frame=CGRectMake(leftX,(46-16)/2, 65, 16);
            typeLb.text=@"商户类型";
            typeLb.font=[UIFont systemFontOfSize:14];
            typeLb.textColor=RGBColor(51, 51, 51);
            CGSize imgSize=[[UIImage imageNamed:@"下拉按钮"] size];
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [vc addSubview:btn];
           // btn.size=imgSize;
            btn.height=46;
            btn.width=imgSize.width;
            btn.x=EPScreenW-leftX-imgSize.width;
            //btn.y=(46-imgSize.height)/2;
            btn.y=0;
            [btn setImage:[UIImage imageNamed:@"下拉按钮"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickTypeOpen) forControlEvents:UIControlEventTouchUpInside];
            UILabel * lb=[[UILabel alloc]init];
            [vc addSubview:lb];
            lb.frame=CGRectMake(CGRectGetMinX(btn.frame)-80, 0, 80, 46);
            lb.textColor=RGBColor(165, 165, 165);
            lb.font=[UIFont systemFontOfSize:12];
            lb.textAlignment=NSTextAlignmentRight;
            UILabel * contentLb=[[UILabel alloc]init];
            [vc addSubview:contentLb];
            contentLb.frame=CGRectMake(CGRectGetMaxX(typeLb.frame)+5, 0, 80, 46);
            contentLb.font=[UIFont systemFontOfSize:15];
            contentLb.textColor=RGBColor(51, 51, 51);
            if (_quan1==YES) {
                lb.text=@"已选择";
                contentLb.text=@"个体";
            }else if (_quan2==YES){
                lb.text=@"已选择";
                contentLb.text=@"企业";
            }else{
                lb.text=@"未选择";
                contentLb.text=@"";
            }
            _lbType=contentLb;
            lb.userInteractionEnabled=YES;
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTypeOpen)];
            [lb addGestureRecognizer:tap];
        }
        if (section==3) {
            UILabel * rangeLb=[[UILabel alloc]init];
            [vc addSubview:rangeLb];
            rangeLb.frame=CGRectMake(leftX,(46-16)/2, 65, 16);
            rangeLb.text=@"经营范围";
            rangeLb.font=[UIFont systemFontOfSize:14];
            rangeLb.textColor=RGBColor(51, 51, 51);
            CGSize imgSize=[[UIImage imageNamed:@"下拉按钮"] size];
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [vc addSubview:btn];
            btn.height=46;
            btn.width=imgSize.width;
            btn.x=EPScreenW-leftX-imgSize.width;
            //btn.y=(46-imgSize.height)/2;
            btn.y=0;
            [btn setImage:[UIImage imageNamed:@"下拉按钮"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickRangeOpen) forControlEvents:UIControlEventTouchUpInside];
            UILabel * lb=[[UILabel alloc]init];
            [vc addSubview:lb];
            lb.frame=CGRectMake(CGRectGetMinX(btn.frame)-80, 0, 80, 46);
            lb.textColor=RGBColor(165, 165, 165);
            lb.font=[UIFont systemFontOfSize:12];
            lb.textAlignment=NSTextAlignmentRight;
            UILabel * contentLb=[[UILabel alloc]init];
            [vc addSubview:contentLb];
            contentLb.frame=CGRectMake(CGRectGetMaxX(rangeLb.frame)+5, 0, 80, 46);
            contentLb.font=[UIFont systemFontOfSize:15];
            contentLb.textColor=RGBColor(51, 51, 51);
            if (_quan3==YES) {
                lb.text=@"已选择";
                contentLb.text=@"餐饮";
            }else if (_quan4==YES){
                lb.text=@"已选择";
                contentLb.text=@"超市";
            }else if(_quan5==YES){
                lb.text=@"已选择";
                contentLb.text=@"休闲娱乐";
            }else{
                lb.text=@"未选择";
                contentLb.text=@"";
            }
            _lbRange=contentLb;
            lb.userInteractionEnabled=YES;
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRangeOpen)];
            [lb addGestureRecognizer:tap];
        }
        if (section==5) {
            for (int i=0; i<2; i++) {
                UIView * line=[[UIView alloc]init];
                [vc addSubview:line];
                line.frame=CGRectMake(leftX, 46*(i+1), EPScreenW-2*leftX, 1);
                line.backgroundColor=RGBColor(238, 238, 238);
            }
            UILabel * contactLb=[[UILabel alloc]init];
            [vc addSubview:contactLb];
            contactLb.frame=CGRectMake(leftX,(46-16)/2, 65, 16);
            contactLb.text=@"联系方式";
            contactLb.font=[UIFont systemFontOfSize:14];
            contactLb.textColor=RGBColor(51, 51, 51);
            
            UITextField * tfphone=[[UITextField alloc]init];
            [vc addSubview:tfphone];
            tfphone.frame=CGRectMake(CGRectGetMaxX(contactLb.frame)+5,(46-30)/2 , EPScreenW-30-70, 30);
            tfphone.placeholder=@"手机号/我们会及时与您联系";
            tfphone.font=[UIFont systemFontOfSize:14];
            tfphone.textColor=RGBColor(51, 51, 51);
            tfphone.keyboardType=UIKeyboardTypePhonePad;
            tfphone.delegate=self;
            _tfphone=tfphone;
            UILabel * wechatLb=[[UILabel alloc]init];
            [vc addSubview:wechatLb];
            wechatLb.frame=CGRectMake(leftX,(46-16)/2+46,35, 16);
            wechatLb.text=@"微信:";
            wechatLb.font=[UIFont systemFontOfSize:14];
            wechatLb.textColor=RGBColor(51, 51, 51);
            UITextField * tfWechat=[[UITextField alloc]init];
            [vc addSubview:tfWechat];
            tfWechat.frame=CGRectMake(CGRectGetMaxX(wechatLb.frame)+5,(46-30)/2+46 , EPScreenW-30-40, 30);
            tfWechat.font=[UIFont systemFontOfSize:15];
            tfWechat.textColor=RGBColor(51, 51, 51);
            tfWechat.keyboardType=UIKeyboardTypeASCIICapable;
            _tfWechat=tfWechat;
            UILabel * QQLb=[[UILabel alloc]init];
            [vc addSubview:QQLb];
            QQLb.frame=CGRectMake(leftX,(46-16)/2+46*2,35, 16);
            QQLb.text=@"QQ:";
            QQLb.font=[UIFont systemFontOfSize:14];
            QQLb.textColor=RGBColor(51, 51, 51);
            UITextField * tfQQ=[[UITextField alloc]init];
            [vc addSubview:tfQQ];
            tfQQ.frame=CGRectMake(CGRectGetMaxX(QQLb.frame)+5,(46-30)/2+46*2 , EPScreenW-30-40, 30);
            tfQQ.font=[UIFont systemFontOfSize:15];
            tfQQ.textColor=RGBColor(51, 51, 51);
            tfQQ.keyboardType=UIKeyboardTypePhonePad;
            _tfQQ=tfQQ;
        }
    }
    return vc;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1||section==4) {
        return 8;
    }else{
        if (section==0) {
            return 92;
        }else{
            if (section==2||section==3) {
                return 46;
            }else{
                return 138;
            }
            
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger loc =range.location;
    if (loc < 11)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return YES;
}
- (UITableView *)tb{
    if (!_tb) {
        _tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, EPScreenW, EPScreenH-64-49) style:UITableViewStylePlain];
        _tb.delegate=self;
        _tb.dataSource=self;
        _tb.backgroundColor=RGBColor(231, 231, 231);
        _tb.separatorStyle=UITableViewCellSeparatorStyleNone;
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
