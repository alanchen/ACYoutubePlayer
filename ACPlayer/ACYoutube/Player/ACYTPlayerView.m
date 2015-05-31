//
//  ACYTPlayerView.m
//  youtube-player-ios-example
//
//  Created by alan on 2015/4/22.
//  Copyright (c) 2015年 YouTube Developer Relations. All rights reserved.
//

#import "ACYTPlayerView.h"

@interface ACYTPlayerView ()<YTPlayerViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) YTPlayerView *playerView;
@property (nonatomic) BOOL isLoaded;

@property (nonatomic,strong)NSString *currentVideoId;

@property (nonatomic,weak)NSTimer *timer;

@end

@implementation ACYTPlayerView

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
   
    if (newWindow == (id)[NSNull null] || newWindow == nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];

        self.playerView = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  frame.size.height)];
        self.playerView.backgroundColor = [UIColor blackColor];
        self.playerView.webView.backgroundColor = [UIColor blackColor];
        [self.playerView.webView setOpaque:NO];
        self.playerView.delegate = self;
        self.playerView.userInteractionEnabled = NO;
        [self addSubview:self.playerView];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.spinner setHidesWhenStopped:YES];
        [self.spinner stopAnimating];
        [self addSubview:self.spinner];
    }
    
    return self;
}

-(void)dealloc
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    self.spinner.frame = CGRectMake(    self.frame.size.width/2 - self.spinner.frame.size.width/2,
                                        self.frame.size.height/2 - self.spinner.frame.size.height/2,
                                        self.spinner.frame.size.width,
                                        self.spinner.frame.size.height);
}

#pragma mark - Private

-(void)timerLoopFire
{
    if(self.timer)
        return;
    
    __weak __typeof(self)weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(timerLoop) userInfo:nil repeats:YES];
}

-(void)timerLoopCancel
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timerLoop
{
    float current = [self currentTime] / [self duration];
    
    if(self.playerState != kYTPlayerStatePlaying)
        return;
    
    if([_playerViewDelegate respondsToSelector:@selector(playerViewDidPlaying:seekTime:)])
    {
        [_playerViewDelegate playerViewDidPlaying:self seekTime:current];
    }
}

-(void)startSpinning
{
    [self.spinner startAnimating];
    self.playerView.hidden = YES;
}

-(void)stopSpinning
{
    [self.spinner stopAnimating];
    self.playerView.hidden = NO;
}

#pragma mark - Delegate

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    NSLog(@"playerView Did Become Ready !");
    
    if(self.isLoaded == NO)
    {
        self.isLoaded =YES;
        [self.playerView playVideo];
    }

    if([_playerViewDelegate respondsToSelector:@selector(playerViewDidBecomeReady:)])
    {
        [_playerViewDelegate playerViewDidBecomeReady:playerView];
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    NSLog(@"playerView didChangeToState %ld", (long)state);
    
//    kYTPlayerStateUnstarted   0
//    kYTPlayerStateEnded       1
//    kYTPlayerStatePlaying     2
//    kYTPlayerStatePaused      3
//    kYTPlayerStateBuffering   4
//    kYTPlayerStateQueued      5
//    kYTPlayerStateUnknown     6
    
    if(state == kYTPlayerStateBuffering)
    {
        [self startSpinning];
        [self timerLoopFire];
    }
    else if(state == kYTPlayerStateEnded || state == kYTPlayerStateUnstarted || state == kYTPlayerStatePaused)
    {
        if(state == kYTPlayerStateEnded && [_playerViewDelegate respondsToSelector:@selector(playerViewDidEnd:videoId:)])
            [_playerViewDelegate playerViewDidEnd:self videoId:self.currentVideoId];
        
        [self stopSpinning];
        [self timerLoopCancel];
    }
    else if(state == kYTPlayerStatePlaying || state == kYTPlayerStateQueued)
    {
        [self stopSpinning];
        [self timerLoopFire];
    }
    else
    {
        [self stopSpinning];
    }

    if([_playerViewDelegate respondsToSelector:@selector(playerView:didChangeToState:)])
    {
        [_playerViewDelegate playerView:playerView didChangeToState:state];
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality;
{
    NSLog(@"playerView didChangeToQuality %ld", (long)quality);
    
    if([_playerViewDelegate respondsToSelector:@selector(playerView:didChangeToQuality:)])
    {
        [_playerViewDelegate playerView:playerView didChangeToQuality:quality];
    }
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    NSLog(@"playerView receivedError %ld", (long)error);
    
    if([_playerViewDelegate respondsToSelector:@selector(playerView:receivedError:)])
    {
        [_playerViewDelegate playerView:playerView receivedError:error];
    }
}

#pragma mark - Public

- (BOOL)playVideoWithVideoId:(NSString *)videoId
{
    return [self playVideoWithVideoId:videoId withQuality:kYTPlaybackQualityHD720];
}

- (BOOL)playVideoWithVideoId:(NSString *)videoId withQuality:(YTPlaybackQuality)q
{
    if(![videoId length])
        return NO;
    
    [self startSpinning];
    self.currentVideoId = videoId;
    
    if(!self.isLoaded)
    {
        return [self.playerView loadWithVideoId:videoId playerVars:[ACYTPlayerView defaultPlayerVars]];
    }
    else
    {
        [self.playerView stopVideo];
        [self.playerView cueVideoById:videoId startSeconds:0.0 suggestedQuality:q];
        [self.playerView playVideo];
    }
    
    return YES;
}

- (void)playVideo
{
    [self.playerView playVideo];
}

- (void)pauseVideo
{
   [self.playerView pauseVideo];
}

- (void)stopVideo
{
    [self.playerView stopVideo];
}

- (void)changeToQualityHD
{
    [self changeToQuality:kYTPlaybackQualityHD720];
}

- (void)changeToQualitySmall
{
    [self changeToQuality:kYTPlaybackQualitySmall];
}

- (void)changeToQualityMedium
{
    [self changeToQuality:kYTPlaybackQualityMedium];
}

- (void)changeToQuality:(YTPlaybackQuality)q
{
    if([self.currentVideoId length]==0)
        return;
    
    [self startSpinning];
    
    float currentTime = self.playerView.currentTime;
    
    [self.playerView cueVideoById:self.currentVideoId startSeconds:currentTime suggestedQuality:q];
    [self.playerView playVideo];
}

- (void)seekTo:(float)percentage
{
    float duration = self.duration?self.duration:1.0;
    float targetSec =  duration * percentage;
    
    [self seekToSeconds:targetSec];
}

- (void)seekToSeconds:(float)seekToSeconds
{
    [self.playerView seekToSeconds:seekToSeconds allowSeekAhead:YES];
}

- (NSTimeInterval)duration
{
    return  self.playerView.duration;
}

- (NSTimeInterval)currentTime
{
    return  self.playerView.currentTime;
}

- (YTPlayerState)playerState
{
    return  self.playerView.playerState;
}

- (NSURL *)videoUrl
{
    return  self.playerView.videoUrl;
}

- (CGSize)setWidthAndKeepRatio:(float)width
{
    float r = 9.0/16.0; //  ratio is 16:9
    
    float h = width*r;
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            width , h);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return CGSizeMake(width, h);
}

- (CGSize)setHeightAndKeepRatio:(float)height
{
    float r = 16.0/9.0; //  ratio is 16:9
    
    float w = height*r;
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            w , height);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return CGSizeMake(w, height);
}

-(void)expand
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void)compress
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

#pragma mark - Helper

//https://developers.google.com/youtube/player_parameters?playerVersion=HTML5

+(NSDictionary  *)defaultPlayerVars
{
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"autoplay" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1,
                                 @"iv_load_policy" : @3,
                                 @"rel":@0
                                 };
    
    return  playerVars;
}


@end
