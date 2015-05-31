//
//  YoutubeVideoPlayer.h
//  ACPlayer
//
//  Created by alan on 2015/5/31.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACYTPlayerView.h"
#import "ACYTControlView.h"
#import "ACConstraintHelper.h"

@interface YoutubeVideoPlayer : UIView

+(YoutubeVideoPlayer *)view;

@property (nonatomic,strong) ACYTPlayerView *playerView;
@property (nonatomic,strong) ACYTControlView *control;

-(void)playVideo:(NSString *)videoId title:(NSString *)title;
-(void)playVideoSliderValue:(float)value currenttime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;
-(void)updateControlLayoutToState:(YTPlayerState)state;

@end
