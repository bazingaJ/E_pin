//
//  MyData.m
//  EPin-IOS
//
//  Created by jeader on 16/4/11.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPData.h"
#import "HeaderFile.h"
#import "EPAnalysis.h"
#import "FileHander.h"
#import "MJExtension.h"
#import "EPMainModel.h"
#import "JDPushDataTool.h"
@implementation EPData
//请求网络数据
+(void)getDataWithUrl:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/xml",nil]];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
        NSLog(@"err--=====%@",error);
    }];
    
}

#pragma mark- 登陆
-(void)goLoginWithloginWithUserName:(NSString *)name WithPsw:(NSString *)psw withPostType:(NSString *)type withManual:(NSString *)manual withCompletion:(void(^)(NSString * returnCode,NSString * msg))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    if ([type intValue]==0)
    {
        if ([manual intValue]==0)
        {

//          paramDic =@{@"phoneNo":PHONENO,@"password":PASSWORD,@"type":@"0",@"manual":@"0",@"loginTime":LOGINTIME};
//
//            NSDictionary * inDic1 =@{@"phoneNo":name,@"password":psw,@"type":@"0",@"manual":@"0",@"loginTime":LOGINTIME};
//            paramDic=inDic1;

        }
        else
        {
            NSDictionary * inDic1 =@{@"phoneNo":name,@"password":psw,@"type":@"0",@"manual":@"1",@"clientId":CLIENTID,@"app":@"1"};
            paramDic=inDic1;
            
        }
    }
    else
    {
        
    }
   // NSLog(@"err--=====%@",paramDic);
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSString * str =[NSString stringWithFormat:@"%@/loginAndRegister.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        NSString * loginTime =[responseObject objectForKey:@"loginTime"];
        NSString * useId=[responseObject[@"userId"] stringValue];
        if (loginTime)
        {
            NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
            [us setValue:loginTime forKey:@"loginTime"];
            [us setValue:useId forKey:@"userId"];
            [us synchronize];
        }
        if ([returnCode intValue]==0)
        {
            block(returnCode,nil);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(@"666",nil);
    }];
}

#pragma mark- 花积分上部分
- (void)getSpendInfoWithCompletion:(void(^)(NSString * returnCode,NSString * msg,id  responseObject))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    paramDic=@{@"type":@"3"};
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSString * str =[NSString stringWithFormat:@"%@/getYPgoodsList.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        block(nil,nil,responseObject);
        FileHander * fileSave =[FileHander shardFileHand];
        NSString *sss=@"spendJiFen";
        [fileSave saveFile:responseObject withForName:@"spendModule" withError:&sss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(@"666",nil,nil);
    }];
}

#pragma mark- 花积分下部分
- (void)getSpendDownInfoWithCompletion:(void(^)(NSString * returnCode,NSString * msg,id  responseObject))block
{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    paramDic[@"type"]=@"1";
    paramDic[@"goodsType"]=@"4";
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSString * str =[NSString stringWithFormat:@"%@/getYPMoregoodsList.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        block(nil,nil,responseObject);
        FileHander * fileSave =[FileHander shardFileHand];
        NSString *sss=@"spendJiFen2";
        [fileSave saveFile:responseObject withForName:@"spendModule2" withError:&sss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(@"666",nil,nil);
    }];
}

#pragma mark- 获取验证码
- (void)getconfirmCodeWithPhoneNo:(NSString *)newphone WithType:(NSString *)type WithCompletion:(void(^)(NSString * returnCode,NSString * number,NSString * msg))block
{
    if (newphone==PHONENO) {
        
    }
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    if ([type intValue]== 4) {
        
    }else{
        dic1[@"phoneNo"] = PHONENO;
//        dic1[@"password"] = PASSWORD;
    }
        dic1[@"type"] = type;
        dic1[@"newPhoneNo"] = newphone;
        dic1[@"pushno"] = INVITECODE;
        dic1[@"loginTime"] = LOGINTIME;
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    NSString * str =[NSString stringWithFormat:@"%@/getSmsVaildCode.json",EPUrl];
    [manager POST:str parameters:dic1 success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * statusStr =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([statusStr intValue]==0)
        {
            block(statusStr,nil,msg);
        }
        else if ([statusStr intValue]==1)
        {
            block(statusStr,nil,msg);
        }
        else
        {
            block(statusStr,nil,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(@"666",nil,nil);
    }];
}

#pragma mark- 查询违章
- (void)getPeccWithPlateNo:(NSString *)plate WithEngineNo:(NSString *)engineNo WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSMutableDictionary *inDic = [NSMutableDictionary dictionary];
    inDic[@"phoneNo"] = PHONENO;
    //inDic[@"password"] = PASSWORD;
    inDic[@"licenseNo"] = @"苏AJ08G9";
    inDic[@"engineNo"] = @"005362";
    inDic[@"loginTime"] = LOGINTIME;
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSString * str=[NSString stringWithFormat:@"%@/getViolation.json",EPUrl];
    [manager POST:str parameters:inDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * statusStr =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        
        
        int status =[statusStr intValue];
        if (status==0)
        {
            //声明一个类对象 用其属性接返回的数据
//            MyData * data =[MyData new];
            //声明一个数组去接数据中返回的数组
            NSMutableArray * arr =[[NSMutableArray alloc]initWithCapacity:0];
            
//            data.pecc_status=[responseObject objectForKey:@"status"];
//            data.pecc_totalPoint=[responseObject objectForKey:@"totalScore"];
//            data.pecc_totalMoney=[responseObject objectForKey:@"totalMoney"];
//            data.pecc_count=[responseObject objectForKey:@"count"];
            
            arr=[responseObject objectForKey:@"historys"];
            if (arr==nil)
            {
                NSLog(@"没有接收到数据");
            }
            else
            {
//                [dict setObject:data.pecc_totalPoint forKey:@"totalPoint"];
//                [dict setObject:data.pecc_totalMoney forKey:@"totalMoney"];
//                [dict setObject:data.pecc_count forKey:@"count"];
//                [dict setObject:arr forKey:@"records"];
            }
            block(statusStr,nil,nil);
        }
        else if (status==1)
        {
            block(statusStr,msg,nil);
        }
        else
        {
            block(statusStr,msg,nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(@"666",nil,nil);
    }];
}

#pragma mark - 支付密码 
-(void)resetPasswordWithwithPostType:(NSString *)type withPassword:(NSString *)password withCodeNo:(NSString *)codeNo withNewPayPassword:(NSString *)newPayPassword withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    if ([type intValue]==0) {
        paramDic[@"payPassword"] = password;
    }else if ([type intValue]==1){
        paramDic[@"payPassword"] = password;
    }else if ([type intValue]==2){
        paramDic[@"payPassword"] = password;
        paramDic[@"newPayPassword"] = newPayPassword;
    }else if ([type intValue] ==3){
    }else if ([type intValue] ==4){
        paramDic[@"codeNo"] = codeNo;
    }else if ([type intValue] ==5){
        paramDic[@"codeNo"] = codeNo;
        paramDic[@"newPayPassword"] = newPayPassword;

    }
    paramDic[@"type"] = type;
    paramDic[@"phoneNo"] = PHONENO;
//    paramDic[@"password"] = PASSWORD;
    paramDic[@"loginTime"] = LOGINTIME;
  
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSString * str=[NSString stringWithFormat:@"%@/setPayPassword.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSString * statusStr =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        block(statusStr,msg,nil);
    }
          failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"error====%@",error);
    }];
}
//失物招领
-(void)getLosterDataWithType:(NSString *)type withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block{
    NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
    AFHTTPSessionManager * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
     paramDic[@"type"] = type;
    NSString * str=[NSString stringWithFormat:@"%@/getLoster.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        block(nil,nil,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
#pragma mark- 召车信息相关
- (void)getCallCarDataWithGetCarTime:(NSString *)time WithGetCarAddress:(NSString *)address WtihDestination:(NSString *)destination WithContect:(NSString *)tel WithUserType:(NSString *)type WhatToDo:(NSString *)request withOrderNumber:(NSString * )number withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    paramDic=@{@"type":request,
               @"phoneNo":PHONENO,
               @"loginTime":LOGINTIME,
               @"time":time,
               @"address":address,
               @"destination":destination,
               @"useType":type,
               @"orderId":number};
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString * str =[NSString stringWithFormat:@"%@/getCallCarData.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        
//        FileHander * fileSave =[FileHander shardFileHand];
//        NSString *sss=@"ss";
//        [fileSave saveFile:responseObject withForName:@"" withError:&sss];
        
        block(returnCode,msg,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString * errorStr =[NSString stringWithFormat:@"%@",error];
        block(@"666",errorStr,nil);
    }];
}
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    NSString *string = [retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];

    return string;
}

- (void)commitCallCarJudgeInfoWith:(NSString *)orderId WithStarCount:(NSString *)count WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
//    paramDic=@{@"type":request,
//               @"phoneNo":PHONENO,
//               @"loginTime":LOGINTIME,
//               @"orderId":orderId};
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString * str =[NSString stringWithFormat:@"%@/getCallCarData.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        
        //        FileHander * fileSave =[FileHander shardFileHand];
        //        NSString *sss=@"ss";
        //        [fileSave saveFile:responseObject withForName:@"" withError:&sss];
        
        block(returnCode,msg,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString * errorStr =[NSString stringWithFormat:@"%@",error];
        block(@"666",errorStr,nil);
    }];
}


#pragma mark- 处理违章记录
- (void)getSubmitePeccInfoWithSpendPoint:(NSString *)point withViolations:(NSMutableString *)violation withCompletionBlock:(void(^)(NSString * returnCode,NSString * msg))block
{
    NSString *orderNo = [self getUniqueStrByUUID];
    
    NSDictionary * inDic =[NSDictionary dictionaryWithObjectsAndKeys:PHONENO,@"phoneNo",
                                                                     orderNo,@"orderNo",
                                                                     LOGINTIME,@"loginTime",
                                                                     @"苏AJ08G9",@"licenseNo",
                                                                     @"005362",@"engineNo",
                                                                     point,@"cost",
                                                                     violation,@"violations",
                                                                     @"0",@"app",
                                                                     nil];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString *urlStr = @"http://114.55.57.237/tad/client/handleViolation.json";
    [manager POST:urlStr parameters:inDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        NSString * leftScore =[responseObject objectForKey:@"leftScore"];
        NSUserDefaults * us =[NSUserDefaults standardUserDefaults];
        if (leftScore != nil)
        {
            [us setValue:leftScore forKey:@"leftScore"];
        }
        [us synchronize];
        if ([returnCode intValue]==0)
        {
            block(returnCode,nil);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg);
        }
        else
        {
            block(returnCode,msg);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(@"666",nil);
    }];
}
#pragma mark----绑定车辆，获取车辆,删除车辆------
- (void)bindCarMessageWithType:(NSString *)type   withPlateNo:(NSString *)plateNo withEnineNo:(NSString *)engineNo withCarNo:(NSString *)carNo  withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSDictionary * inDict=[[NSDictionary alloc]init];
    if ([type intValue]==0) {
        NSDictionary *dict1=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"plateNo":plateNo,
                              @"engineNo":engineNo};
        inDict=dict1;
    }else if ([type intValue]==1){
        NSDictionary *dict2=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME};
        inDict=dict2;
    }else{
        NSDictionary *dict3=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"plateNo":carNo};
        inDict=dict3;
    }
     NSString * str =[NSString stringWithFormat:@"%@/bindCarMessage.json",EPUrl];
     AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:inDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,nil,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg,responseObject);
        }
        else if([returnCode intValue]==2){
            [EPLoginViewController publicDeleteInfo];
            block(returnCode,msg,responseObject);

        }else
        {
            block(returnCode,msg,responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark----获取乘客行程信息和提交失物信息------
- (void)getTravelInfoWithNumber:(NSString *)num withLostId:(NSString *)lost withType:(NSString *)type withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    if (lost.length==0)
    {
        paramDic=@{@"phoneNo":PHONENO,
                   @"loginTime":LOGINTIME,
                   @"number":num,
                   @"lostId":@"",
                   @"type":type,};
    }
    else
    {
        
        paramDic=@{@"phoneNo":PHONENO,
                   @"loginTime":LOGINTIME,
                   @"number":num,
                   @"lostId":lost,
                   @"type":type,};
    }
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString * str =[NSString stringWithFormat:@"%@/getLostFoundData.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        
        block(returnCode,msg,responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString * errorStr =[NSString stringWithFormat:@"%@",error];
        block(@"666",errorStr,nil);
    }];
}

- (void)getTravelInfoWithlostId:(NSString *)lost withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
    if (lost.length==0)
    {
        paramDic=@{@"phoneNo":PHONENO,
                   @"loginTime":LOGINTIME,
                   @"lostId":@"",
                   @"type":@"2",};
    }
    else
    {
        paramDic=@{@"phoneNo":PHONENO,
                   @"loginTime":LOGINTIME,
                   @"lostId":lost,
                   @"type":@"2",};
    }
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString * str =[NSString stringWithFormat:@"%@/getLostFoundData.json",EPUrl];
    [manager POST:str parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString * imagePath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"bill.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        NSData *data = UIImagePNGRepresentation(image);
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"lostFoundImg" fileName:fileName mimeType:@"image/png"];
        //        NSFileManager * fm = [NSFileManager defaultManager];
        //        if ([fm fileExistsAtPath:imagePath])
        //        {
        //            [fm removeItemAtPath:imagePath error:NULL];
        //        }
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        block(returnCode,msg,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSString * errorStr =[NSString stringWithFormat:@"%@",error];
        block(@"666",errorStr,nil);
        
    }];
}
#pragma ------订单接口-----
- (void)getMyOrderInfoWithType:(NSString *)type withGoodsId:(NSString *)goodsId withCount:(NSString *)count withOrderId:(NSString *)orderId withIp:(NSString *)ip withPayStyle:(NSString * )payStyle withCardId:(NSString *)cardId withUseScore:(NSString *)useScore withOrderNo:(NSString *)orderNo  password:(NSString * )payPassword withCodes:(NSString *)codes  withRefundReson:(NSString *)reson WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block{
    
    NSString * str =[NSString stringWithFormat:@"%@/getMyOrderInfo.json",EPUrl];
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    NSDictionary * inDict=[[NSDictionary alloc]init];
    if ([type intValue]==0) {
        if ([useScore intValue]>0) {
            useScore = @"1";
        }else{
            useScore = @"0";
        }
        
        //提交订单
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"useScore":useScore,
                              @"count":count,
                              @"goodsId":goodsId,
                              @"orderNo":orderNo,
                              @"loginTime":LOGINTIME};
        inDict=dict;

    }else if ([type intValue]==1){
        //获取订单
         NSDictionary * dict=@{@"type":type,
                               @"phoneNo":PHONENO,
                               @"loginTime":LOGINTIME};
         inDict=dict;
    }else if ([type intValue]==2){
        //订单付款
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"orderNo":orderNo,
                              @"payPassword":payPassword,
                              @"loginTime":LOGINTIME};
        inDict=dict;

    }else if ([type intValue]==3){
        //取消订单
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"orderNo":orderId};
        inDict=dict;

    }else if ([type intValue]==4){
        //删除订单
         NSDictionary * dict=@{@"type":type,
                               @"phoneNo":PHONENO,
                               @"loginTime":LOGINTIME,
                               @"orderNo":orderId};
        inDict=dict;
    }else if ([type intValue]==5){
        //申请退款
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"applyText":reson,
                              @"codes":codes};
        inDict=dict;
    }else if([type intValue]==6){
        //获取支付宝支付签名
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"orderNo":orderId
                              };
        inDict=dict;
    }else  if([type intValue]==7){
        //获取微信支付预支付交易会话ID
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"orderNo":orderNo,
                              @"goodsId":goodsId,
                              @"ip":ip
                              };
        inDict=dict;
    }else{
        //获取银联受理交易流水号
        NSDictionary * dict=@{@"type":type,
                              @"phoneNo":PHONENO,
                              @"loginTime":LOGINTIME,
                              @"orderNo":orderNo,
                              };
        inDict=dict;
        
    }
    NSLog(@"订单inDict===%@",inDict);
    [manager GET:str parameters:inDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"res >>>>>>%@",responseObject);
        NSString * returnCode =[responseObject objectForKey:@"returnCode"];
        NSString * msg =[responseObject objectForKey:@"msg"];
        if ([returnCode intValue]==0)
        {
            block(returnCode,nil,responseObject);
        }
        else if ([returnCode intValue]==1)
        {
            block(returnCode,msg,responseObject);
        }
        else if([returnCode intValue]==2){
            [EPLoginViewController publicDeleteInfo];
            block(returnCode,msg,responseObject);
            
        }else
        {
            block(returnCode,msg,responseObject);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
/**评论*/
#pragma mark-积分查询数据返回

+(void)getScoreInfoWithBeginDate:(NSString *)begin WithOverDate:(NSString *)over withType:(NSString *)type Completion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSMutableDictionary * inDic =[NSMutableDictionary dictionary];
    //查询所有记录
    inDic[@"phoneNo"]=PHONENO;
    inDic[@"loginTime"]=LOGINTIME;
    inDic[@"beginDate"]=begin;
    inDic[@"overDate"]= over;
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    manager.requestSerializer.timeoutInterval=10;
    NSString * str =[NSString stringWithFormat:@"%@/queryScore.json",EPUrl];
   
    [manager POST:str parameters:inDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"---->%@",responseObject);
         NSString * statusStr =[responseObject objectForKey:@"returnCode"];
         NSString * msg =[responseObject objectForKey:@"msg"];
         block(statusStr,msg,responseObject);
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         NSLog(@"error %s %@",__func__,error);
     }];
}
/**
 *  召车支付相关请求接口
 *
 *  @param type       处理类型
 *  @param order      订单号
 *  @param score      使用积分
 *  @param code       支付密码
 *  @param wholeMoney 车资总额
 */
- (void)requestSignWithType:(NSString *)type WithOrderId:(NSString *)order WithPoint:(NSString *)score WithPayCode:(NSString *)code WithWholeMoney:(NSString *)wholeMoney WithDriverId:(NSString *)driver WithIPAddress:(NSString *)ip WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block
{
    NSDictionary * paramDic =[NSDictionary dictionary];
        paramDic=@{@"phoneNo":PHONENO,
                   @"loginTime":LOGINTIME,
                   @"orderId":order,
                   @"type":type,
                   @"useScore":score,
                   @"payPassword":code,
                   @"driverId":driver,
                   @"payMoney":wholeMoney,
                   @"ip":ip};
    
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSString * str =[NSString stringWithFormat:@"%@/payCallCarOrder.json",EPUrl];
    [manager POST:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        
        block(returnCode,msg,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"-----%@",error);
    }];
}
/**拍卖接口*/
- (void)getAuctionDataWithType:(NSString *)type withGoodsId:(NSString *)goodsId withOrderId:(NSString *)orderId  Completion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block{
    NSString * str =[NSString stringWithFormat:@"%@/getAuctionData.json",EPUrl];
     NSMutableDictionary * paramDic =[NSMutableDictionary dictionary];
//    if ([type intValue]==0)
//    {
//        //获取列表
//        if (LOGINTIME==nil) {
//            paramDic=@{@"type":type};
//        }else{
    paramDic[@"phoneNo"] = PHONENO;
    paramDic[@"loginTime"] = LOGINTIME;
    paramDic[@"type"] = type;
    paramDic[@"goodsId"] = goodsId;
    paramDic[@"orderId"] = orderId;

//            paramDic=@{@"phoneNo":PHONENO,
//                       @"loginTime":LOGINTIME,
//                       @"type":type,
//                       @"goodsId":goodsId,
//                       @"orderId":orderId
//                       };
//        }
//        
//    }
//    if ([type intValue]==1) {
//        //获取详情
//        paramDic=@{@"type":type,
//                   @"goodsId":goodsId
//                   };
//    }
//    if ([type intValue]==2) {
//        //认购
//        paramDic=@{@"phoneNo":PHONENO,
//                   @"loginTime":LOGINTIME,
//                   @"type":type,
//                   @"goodsId":goodsId,
//                   @"orderId":orderId
//                   };
//
//    }
//    if ([type intValue]==3) {
//        //我的拍卖
//        paramDic=@{@"phoneNo":PHONENO,
//                   @"loginTime":LOGINTIME,
//                   @"type":type};
//
//    }
//    if ([type intValue]==4) {
//        //获取支付宝签名
//        paramDic=@{@"phoneNo":PHONENO,
//                   @"loginTime":LOGINTIME,
//                   @"type":type,
//                   @"orderId":orderId};
//    }
//    if ([type intValue]==5) {
//        //获取历史中奖信息
//        paramDic=@{@"type":type};
//    }
//    if ([type intValue]==6) {
//        //余额支付认购
//        paramDic=@{@"phoneNo":PHONENO,
//                   @"loginTime":LOGINTIME,
//                   @"type":type,
//                   @"orderId":orderId};
//    }
//    NSLog(@"半价拍Dict--%@",paramDic);
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:str parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        
        block(returnCode,msg,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//银联支付获取签名
- (void)verify:(NSString *)sign WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block{
    NSString * str =[NSString stringWithFormat:@"%@/getAuctionData.json",EPUrl];
    NSDictionary * dict=@{@"phoneNo":PHONENO,
                          @"sign":sign
                          };
    AFHTTPSessionManager  * manager =[AFHTTPSessionManager manager];
    [manager POST:str parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString * returnCode =responseObject[@"returnCode"];
        NSString * msg =responseObject[@"msg"];
        block(returnCode,msg,responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
