//
//  YoutubeVideoPlayer.m
//  ACPlayer
//
//  Created by alan on 2015/5/31.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import "YoutubeVideoPlayer.h"

@interface YoutubeVideoPlayer () <ACYTPlayerViewDelegate , YTPlayerViewDelegate>

@end


@implementation YoutubeVideoPlayer

+(YoutubeVideoPlayer *)view
{
    YoutubeVideoPlayer *v = [[YoutubeVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    return v;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.playerView = [[ACYTPlayerView alloc] initWithFrame:frame];
        self.playerView.playerViewDelegate = self;
        [self addSubview:self.playerView];
        
        self.control = [[ACYTControlView alloc] initWithFrame:self.playerView.frame];
        [self.control hideWithAnimation:NO];
        [self addSubview:self.control];
        
        //////////////////////////////////////////////////////////////////////////////
        
        [self.control.playBtn addTarget:self action:@selector(playPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.control.expandBtn addTarget:self action:@selector(expandPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.control.hdBtn addTarget:self action:@selector(hdPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.control.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.control.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpOutside];

    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.control.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - public

-(void)playVideo:(NSString *)videoId title:(NSString *)title
{
    [self.playerView playVideoWithVideoId:videoId];
    [self.control.playBtn setSelected:YES];
    [self.control.titleLabel setText:title];
    
    [self.control.hdBtn setSelected:NO];
}

-(void)playVideoSliderValue:(float)value currenttime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    [self.control setSliedrValue:value];
    [self.control setLeftTime:currentTime];
    [self.control setRightTime:duration];
}

-(void)updateControlLayoutToState:(YTPlayerState)state
{
    if(state== kYTPlayerStatePlaying){
        [self.control showPlayingStatus];
    }
    else{
        [self.control showPauseStatus];}
}

#pragma mark - Player Delegate

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    [self updateControlLayoutToState:state];
}

- (void)playerViewDidPlaying:(ACYTPlayerView *)playerView seekTime:(float)time
{
    [self playVideoSliderValue:time currenttime:playerView.currentTime duration:playerView.duration];

    if([self.playerView playerState] == kYTPlayerStateEnded)
    {
        
    }
}

- (void)playerViewDidEnd:(ACYTPlayerView *)playerView videoId:(NSString *)vid
{
  
    
}

#pragma mark - Action

-(void)sliderAction:(UISlider *)s
{
    [self.playerView seekTo:self.control.slider.value];
}

-(void)hdPressed
{
    if(!self.control.hdBtn.isSelected)
    {
        [self.control.hdBtn setSelected:YES];
        [self.playerView changeToQualityMedium];
    }
    else
    {
        [self.control.hdBtn setSelected:NO];
        [self.playerView changeToQualityHD];
    }
}

-(void)expandPressed
{
    if(!self.control.expandBtn.isSelected)
    {
        [self.control.expandBtn setSelected:YES];
        [self.playerView expand];
    }
    else
    {
        [self.control.expandBtn setSelected:NO];
        [self.playerView compress];
    }
}

-(void)playPressed
{
    if(!self.control.playBtn.isSelected)
    {
        [self.control showPlayingStatus];
        [self.playerView playVideo];
    }
    else
    {
        [self.control showPauseStatus];
        [self.playerView pauseVideo];
    }
}


@end
