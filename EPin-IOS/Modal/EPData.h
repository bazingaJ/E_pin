//
//  MyData.h
//  EPin-IOS
//
//  Created by jeader on 16/4/11.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *   @brief 发送请求解析数据的类
 */
@interface EPData : NSObject


//请求数据
+(void)getDataWithUrl:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 *  违章积分处理的接口
 *
 *  @param point     处理所需的积分
 *  @param violation 处理的违章记录
 */
- (void)getSubmitePeccInfoWithSpendPoint:(NSString *)point withViolations:(NSMutableString *)violation withCompletionBlock:(void(^)(NSString * returnCode,NSString * msg))block;



/**
 *  登陆
 *
 *  @param name   用户名(手机号)
 *  @param psw    密码
 *  @param type   请求的接口类型
 *  @param manual 是否是手动登陆
 *  @param block  返回的block
 */
-(void)goLoginWithloginWithUserName:(NSString *)name WithPsw:(NSString *)psw withPostType:(NSString *)type withManual:(NSString *)manual withCompletion:(void(^)(NSString * returnCode,NSString * msg))block;
/**
 *  获取验证码接口
 *
 *  @param phone 验证使用的手机号
 *  @param block 返回代码
 */
- (void)getconfirmCodeWithPhoneNo:(NSString *)newphone WithType:(NSString *)type WithCompletion:(void(^)(NSString * returnCode,NSString * number,NSString * msg))block;

/**
 *  花积分
 *
 *  @param block 返回的block
 */
- (void)getSpendInfoWithCompletion:(void(^)(NSString * returnCode,NSString * msg,id responseObject))block;
- (void)getSpendDownInfoWithCompletion:(void(^)(NSString * returnCode,NSString * msg,id  responseObject))block;
//- (void)getCallCarData;

/**
 *  违章查询
 *
 *  @param plate    车牌号
 *  @param engineNo 发动机后六位
 *  @param block    返回block
 */
- (void)getPeccWithPlateNo:(NSString *)plate WithEngineNo:(NSString *)engineNo WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
 *  设置OR修改支付密码
 *
 *  @param type     类型  是设置还是更改
 *  @param manual   是否是手动登录
 *  @param password 支付密码
 *  @param codeNo   验证码
 *  @param block    返回block
 */
-(void)resetPasswordWithwithPostType:(NSString *)type withPassword:(NSString *)password withCodeNo:(NSString *)codeNo withNewPayPassword:(NSString *)newPayPassword withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
 *  获取失物
 *
 *  @param type  类型
 *  @param block 返回block
 */
-(void)getLosterDataWithType:(NSString *)type withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
 *  召车信息
 *
 *  @param time        上车时间
 *  @param address     上车地点
 *  @param destination 目的地
 *  @param tel         联系人号码
 *  @param type        召车类型
 *  @param todo        要请求什么
 *  @param block       返回block
 */
- (void)getCallCarDataWithGetCarTime:(NSString *)time WithGetCarAddress:(NSString *)address WtihDestination:(NSString *)destination WithContect:(NSString *)tel WithUserType:(NSString *)type WhatToDo:(NSString *)request withOrderNumber:(NSString * )number withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
  * 车辆接口
  *
  * @param type      类型 绑定，获取，删除
  * @param plateNo   车牌号
  * @param engineNo  发动机缸号
  * @param type      车牌编号
  * @param block     返回的block
*/
- (void)bindCarMessageWithType:(NSString *)type withPlateNo:(NSString *)plateNo withEnineNo:(NSString *)engineNo withCarNo:(NSString *)carNo  withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
 *  获取提交失物信息  提交行程信息
 *
 *  @param num   每一条失物信息的唯一单号
 *  @param type  获取/提交不同的类型 0 获取 1 提交
 *  @param block 返回的block
 */
- (void)getTravelInfoWithNumber:(NSString *)num withLostId:(NSString *)lost withType:(NSString *)type withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;

/**
 *  招领失物提交照片信息
 *
 *  @param block 返回的block
 */
- (void)getTravelInfoWithlostId:(NSString *)lost withCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
 * 订单接口
 *
 * @param type      类型 提交，获取，付款，取消，删除
 * @param goodsId   商品ID
 * @param count     购买数量
 * @param orderId   订单id
 * @param payStyle  支付方式
 * @param cardId    绑定银行卡
 * @param useScore  使用积分
 * @param orderNo   订单号
 * @param block     返回的block
 */
- (void)getMyOrderInfoWithType:(NSString *)type withGoodsId:(NSString *)goodsId withCount:(NSString *)count withOrderId:(NSString *)orderId withIp:(NSString *)ip withPayStyle:(NSString * )payStyle withCardId:(NSString *)cardId withUseScore:(NSString *)useScore withOrderNo:(NSString *)orderNo  password:(NSString * )payPassword withCodes:(NSString *)codes  withRefundReson:(NSString *)reson WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
//获取我的积分详情接口
+(void)getScoreInfoWithBeginDate:(NSString *)begin WithOverDate:(NSString *)over withType:(NSString *)type Completion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
/**
 * 拍卖接口
 *
 * @param type      类型 0 获取列表 1获取详情 2 认购 3.我参与的列表 4.获取签名 5 获取历史中奖信息 6 余额支付认购
 * @param goodsId   拍卖品ID
 * @param orderId   订单id
 * @param block     返回的block
 */
- (void)getAuctionDataWithType:(NSString *)type withGoodsId:(NSString *)goodsId withOrderId:(NSString *)orderId  Completion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
//订单号
- (NSString *)getUniqueStrByUUID;

//召车
- (void)requestSignWithType:(NSString *)type WithOrderId:(NSString *)order WithPoint:(NSString *)score WithPayCode:(NSString *)code WithWholeMoney:(NSString *)wholeMoney WithDriverId:(NSString *)driver WithIPAddress:(NSString *)ip WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;
//银联支付验证签名
- (void)verify:(NSString *)sign WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;

#pragma mark - 提交召车评价信息
- (void)commitCallCarJudgeInfoWith:(NSString *)orderId WithStarCount:(NSString *)count WithCompletion:(void(^)(NSString * returnCode,NSString * msg,NSMutableDictionary * dic))block;

@end
