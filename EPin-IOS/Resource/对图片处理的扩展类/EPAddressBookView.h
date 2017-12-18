//
//  EPAddressBookView.h
//  EPin-IOS
//
//  Created by jeaderL on 16/6/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EPAddressBookView : NSObject

- (void)showInViewController:(UIViewController *)VC
               completeBlock:(void (^)(NSString *phoneNum))complete;


@end
