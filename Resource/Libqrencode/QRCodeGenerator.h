//
//  QRCodeGenerator.h
//  YinjuWebView
//
//  Created by JXNJ on 15/2/28.
//  Copyright (c) 2015年 JXNJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QRCodeGenerator : NSObject

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;


@end