//
//  NSString+PlaceholderString.h
//  EPin-IOS
//
//  Created by jeader on 2016/11/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PlaceholderString)

/**
 占位的字符串

 @param string 本应该显示的字符串
 @param AnotherString 占位代替的字符串
 @return 判断之后返回的字符串
 */
+ (NSString *)stringByRealString:(NSString *)string WithReplaceString:(NSString *)AnotherString;


@end
