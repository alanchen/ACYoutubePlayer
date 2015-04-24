//
//  ACYTPlayerView.h
//  youtube-player-ios-example
//
//  Created by alan on 2015/4/22.
//  Copyright (c) 2015年 YouTube Developer Relations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@protocol ACYTPlayerViewDelegate ;

@interface ACYTPlayerView : UIView

@property (nonatomic, weak) id <YTPlayerViewDelegate,ACYTPlayerViewDelegate> playerViewDelegate;

- (BOOL)playVideoWithVideoId:(NSString *)videoId;
- (BOOL)playVideoWithVideoId:(NSString *)videoId withQuality:(YTPlaybackQuality)q;

- (void)changeToQualityHD;
- (void)changeToQualitySmall;
- (void)changeToQualityMedium;
- (void)changeToQuality:(YTPlaybackQuality)q;

- (void)playVideo;
- (void)pauseVideo;
- (void)stopVideo;

- (void)seekTo:(float)percentage; // 0 ~ 1
- (void)seekToSeconds:(float)seekToSeconds; // secs
- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;


- (YTPlayerState)playerState;
- (NSURL *)videoUrl;

- (void)setWidthAndKeepRatio:(float)width;
- (void)setHeightAndKeepRatio:(float)height;

- (void)expand;
- (void)compress;


@end

///////////////////////////////////////////////////////////////////

@protocol ACYTPlayerViewDelegate <NSObject>

@optional
- (void)playerViewDidPlaying:(ACYTPlayerView *)playerView seekTime:(float)time; //time 0~1
- (void)playerViewDidEnd:(ACYTPlayerView *)playerView videoId:(NSString *)vid;

@end