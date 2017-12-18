//
//  PlayerView.m
//  BeginAnimation
//
//  Created by jeader on 16/2/28.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "PlayerView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView ()<AVPlayerViewControllerDelegate>
{
    AVPlayerViewController      *_playerController;
    AVPlayer                    *_player;
    AVAudioSession              *_session;
    NSString                    *_urlString;
}

@end

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url
{
    _urlString = url;
    self = [super initWithFrame:frame];
    if (self)
    {
        _session = [AVAudioSession sharedInstance];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
       
        NSURL *sourceMovieURL = [NSURL fileURLWithPath:_urlString];
        
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        self.rate=_player.rate;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"full" object:nil];
        _playerController = [[AVPlayerViewController alloc] init];
        _playerController.player = _player;
        _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerController.delegate = self;
//        _playerController.allowsPictureInPicturePlayback = true;
        //画中画，iPad可用
        _playerController.showsPlaybackControls = false;
        
//        _playerController.view.translatesAutoresizingMaskIntoConstraints = true;
//        //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
        _playerController.view.frame = self.frame;
        [self addSubview:_playerController.view];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    }
    return self;
}
- (void)moviePlayDidEnd:(NSNotification *)noti
{
    [self performSelector:@selector(remove) withObject:nil afterDelay:3];
    
}
- (void)remove
{
   [self removeFromSuperview];
}
- (void)play
{
    [_playerController.player play];
}
#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"1111111%s", __FUNCTION__);
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"2222222%s", __FUNCTION__);
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"3333333%s", __FUNCTION__);
}

- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"4444444%s", __FUNCTION__);
}

- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"555555%s", __FUNCTION__);
    
}

- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController {
    NSLog(@"6666666%s", __FUNCTION__);
    return true;
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"777777%s", __FUNCTION__);
}

@end
