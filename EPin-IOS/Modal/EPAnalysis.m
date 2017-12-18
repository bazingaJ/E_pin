//
//  EPAnalysis.m
//  EPin-IOS
//
//  Created by jeader on 16/4/27.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPAnalysis.h"

@implementation EPAnalysis


- (NSMutableDictionary *)analysisWith:(NSMutableDictionary *)dic
{
    NSMutableDictionary * finalDic =[NSMutableDictionary dictionary];
    
    //banner图片解析
    NSMutableArray * bannerImgArr =dic[@"bannerImg"];
    //猜你喜欢解析
    NSMutableArray * likeArr =dic[@"guessLike"];
    NSMutableArray * addArr1 =[NSMutableArray array];
    for (NSDictionary * smallDic in likeArr)
    {
        EPAnalysis * analysis =[[EPAnalysis alloc] init];
        analysis.likeImg=smallDic[@"likeImg"];
        analysis.likeName=smallDic[@"likeName"];
        analysis.likePrice=smallDic[@"likePrice"];
        analysis.likeGoodsId=smallDic[@"goodsId"];
        [addArr1 addObject:analysis];
    }
    
    //热门推荐解析
    NSMutableArray * hotArr =dic[@"hotRecommend"];
    NSMutableArray * addArr2 =[NSMutableArray array];
    for (NSDictionary * smallDic in hotArr)
    {
        EPAnalysis * analysis =[[EPAnalysis alloc] init];
        analysis.hotImg=smallDic[@"hotImg"];
        analysis.hotName=smallDic[@"hotName"];
        analysis.hotPrice=smallDic[@"hotPrice"];
        analysis.hotGoodsId=smallDic[@"goodsId"];
        [addArr2 addObject:analysis];
    }
    
    //200积分专区
    NSMutableArray * secondArr =dic[@"secondRegion"];
    NSMutableArray * addArr3 =[NSMutableArray array];
    for (NSDictionary * smallDic in secondArr)
    {
        EPAnalysis * analysis =[[EPAnalysis alloc] init];
        analysis.secondImg=smallDic[@"secondImg"];
        analysis.secondName=smallDic[@"secondName"];
        analysis.secondPrice=smallDic[@"secondPrice"];
        analysis.secondGoodsId=smallDic[@"goodsId"];
        [addArr3 addObject:analysis];
    }
    //500积分专区
    NSMutableArray * thirdArr =dic[@"thirdRegion"];
    NSMutableArray * addArr4 =[NSMutableArray array];
    for (NSDictionary * smallDic in thirdArr)
    {
        EPAnalysis * analysis =[[EPAnalysis alloc] init];
        analysis.thirdImg=smallDic[@"thirdImg"];
        analysis.thirdName=smallDic[@"thirdName"];
        analysis.thirdPrice=smallDic[@"thirdPrice"];
        analysis.thirdGoodsId=smallDic[@"goodsId"];
        [addArr4 addObject:analysis];
    }
    //全部商品专区
    NSMutableArray * allArr =dic[@"wholeGoods"];
    NSMutableArray * addArr5 =[NSMutableArray array];
    for (NSDictionary * smallDic in allArr)
    {
        EPAnalysis * analysis =[[EPAnalysis alloc] init];
        analysis.goodsImg=smallDic[@"goodsImg"];
        analysis.goodsName=smallDic[@"goodsName"];
        analysis.goodsPrice=smallDic[@"goodsPrice"];
        analysis.discountPrice=smallDic[@"discountPrice"];
        analysis.sellCounts=smallDic[@"sellCounts"];
        analysis.goodsID=smallDic[@"goodsId"];
        [addArr5 addObject:analysis];
    }
    finalDic[@"bannerArr"]=bannerImgArr;
    finalDic[@"likeArr"]=addArr1;
    finalDic[@"hotArr"]=addArr2;
    finalDic[@"secondArr"]=addArr3;
    finalDic[@"thirdArr"]=addArr4;
    finalDic[@"wholeArr"]=addArr5;
    
    return finalDic;
}

@end
