//
//  PlayerView.h
//  BeginAnimation
//
//  Created by jeader on 16/2/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerView : UIView
@property float rate;

- (id)initWithFrame:(CGRect)frame url:(NSString *)url;

- (void)play;


@end
