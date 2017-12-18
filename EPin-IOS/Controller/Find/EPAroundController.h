//
//  EPAroundController.h
//  55555
//
//  Created by jeaderQ on 16/4/1.
//  Copyright © 2016年 jeaderQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPAroundController : UIViewController
{
    UIImageView *image1,*image2;
    float random;
    float orign;
    NSTimer * _timer ;
}
@property (nonatomic, copy) void(^myBlock)();
@end
