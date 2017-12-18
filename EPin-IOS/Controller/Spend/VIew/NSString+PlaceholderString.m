//
//  NSString+PlaceholderString.m
//  EPin-IOS
//
//  Created by jeader on 2016/11/24.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "NSString+PlaceholderString.h"
static NSString * const kNothingString = @"正在加载...";

@implementation NSString (PlaceholderString)

+ (NSString *)stringByRealString:(NSString *)string WithReplaceString:(NSString *)AnotherString
{
    if ([string isEqualToString:@""] || string.length == 0 || [string isEqual:[NSNull null]] || string==nil)
    {
        if ([AnotherString isEqualToString:@""] || AnotherString.length == 0 || [AnotherString isEqual:[NSNull null]] || AnotherString == nil)
        {
            return kNothingString;
        }
        else
        {
            return AnotherString;
        }
        
    }
    else
    {
        return string;
    }
    
}

@end
