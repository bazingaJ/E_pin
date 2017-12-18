//
//  EPAddInfoViewController.m
//  EPin-IOS
//
//  Created by jeader on 16/4/21.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPAddInfoVC.h"
#import "HeaderFile.h"

@interface EPAddInfoVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *engineNo;
@property(nonatomic,strong)UILabel * tanchu;

@end

@implementation EPAddInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置代理
    self.plateNo.delegate=self;
    self.engineNo.delegate=self;
    self.plateNo.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.engineNo.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self prepareForNav];
    [self prepareForBtn];
    [self submitView];
}
- (void)submitView
{
    UILabel * lb=[[UILabel alloc]init];
    lb.backgroundColor=[UIColor blackColor];
    lb.x=(EPScreenW-90)/2;
    lb.y=180;
    lb.width=90;
    lb.height=25;
    lb.text=@"绑定成功";
    lb.font=[UIFont systemFontOfSize:14];
    lb.textColor=[UIColor whiteColor];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.hidden=YES;
    lb.alpha=0.0;
    _tanchu=lb;
    lb.layer.masksToBounds=YES;
    lb.layer.cornerRadius=5;
    [self.view addSubview:lb];
}
- (void)prepareForNav
{
    [self addNavigationBar:0 title:@"绑定车辆"];
}
- (void)prepareForBtn
{
    self.commitBtn.clipsToBounds=YES;
    self.commitBtn.layer.cornerRadius=5;
}
- (IBAction)clickButton:(id)sender
{
    [self.view endEditing:YES];
    if (self.plateNo.text.length==0||self.engineNo.text.length==0) {
        [EPTool addAlertViewInView:self title:@"温馨提示" message:@"输入的车牌号或发动机缸号为空" count:0 doWhat:nil];
    }else{
        //提交按钮
        [EPTool addMBProgressWithView:self.view style:0];
        [EPTool showMBWithTitle:@""];
        EPData * data=[EPData new];
        NSString * plateNo=[NSString stringWithFormat:@"%@",self.plateNo.text];
        [data bindCarMessageWithType:@"0" withPlateNo:plateNo withEnineNo:self.engineNo.text withCarNo:nil withCompletion:^(NSString *returnCode, NSString *msg, NSMutableDictionary *dic) {
            NSLog(@"绑定车辆----%@",dic);
            if ([returnCode intValue]==0){
                //成功
                [EPTool hiddenMBWithDelayTimeInterval:0];
                [UIView animateWithDuration:1 animations:^{
                    _tanchu.alpha=1.0;
                    _tanchu.hidden=NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:15 animations:^{
                        _tanchu.alpha=0.0;
                        _tanchu.hidden=YES;
                    }];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else if([returnCode intValue]==2){
                [EPTool hiddenMBWithDelayTimeInterval:0];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0  doWhat:^{
                    [EPLoginViewController  publicDeleteInfo];
                    EPLoginViewController * login=[[EPLoginViewController alloc]init];
                    [self.navigationController presentViewController:login animated:YES completion:nil];
                }];
            }else{
                [EPTool hiddenMBWithDelayTimeInterval:0];
                [EPTool addAlertViewInView:self title:@"温馨提示" message:msg count:0 doWhat:nil];
            }
        }];
    }
}
//限制文本框输入的字数长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.plateNo)
    {
        NSInteger loc =range.location;
        if (loc < 7)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else if (textField == self.engineNo)
    {
        NSInteger loc =range.location;
        if (loc < 6)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
