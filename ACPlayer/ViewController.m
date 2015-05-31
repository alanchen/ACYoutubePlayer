//
//  ViewController.m
//  ACPlayer
//
//  Created by alan on 2015/4/21.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import "ViewController.h"

#import "ACYTPlayerView.h"

#import "ACYTControlView.h"

#import "ACConstraintHelper.h"

#import "YouTubeAPIService.h"

#import "YouTubeListTableCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController () <ACYTPlayerViewDelegate , YTPlayerViewDelegate ,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) ACYTPlayerView *playerView;
@property (nonatomic,strong) ACYTControlView *control;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *objects;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation ViewController

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.playerView setWidthAndKeepRatio:self.view.frame.size.width];
    [self.control setFrame:self.playerView.frame];
    
    [self.tableView setFrame:CGRectMake(0,
                                        self.playerView.frame.size.height,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height - self.playerView.frame.size.height)];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];

    self.playerView = [[ACYTPlayerView alloc] initWithFrame:self.view.frame];
    self.playerView.playerViewDelegate = self;
    [self.view addSubview:self.playerView];
    
    self.control = [[ACYTControlView alloc] initWithFrame:self.playerView.frame];
    [self.control hideWithAnimation:NO];
    [self.view addSubview:self.control];

    //////////////////////////////////////////////////////////////////////////////
    
    [self.control.nextBtn addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.control.preBtn addTarget:self action:@selector(prePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.control.playBtn addTarget:self action:@selector(playPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.control.expandBtn addTarget:self action:@selector(expandPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.control.hdBtn addTarget:self action:@selector(hdPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.control.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.control.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpOutside];


    //////////////////////////////////////////////////////////////////////////////
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[YouTubeListTableCell class] forCellReuseIdentifier:@"YouTubeListTableCell"];
    [self.view sendSubviewToBack:self.tableView];
    
    //////////////////////////////////////////////////////////////////////////////

    [self apiGetVideo];
}

#pragma mark -

-(void)apiGetVideo
{
    [[YouTubeAPIService sharedInstance] apiSearchVideoDetaiilWithQuery:@"周杰倫" maxResults:10 order:@"viewcount" params:nil success:^(NSMutableArray *results, id responseObject, id info)
     {
         self.objects = results;

         [self playVideo];
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

-(void)playVideo
{
    if( [self.objects count]==0)
        return;
    
    if(self.currentIndex < 0)
        self.currentIndex = [self.objects count]-1;
    
    if( self.currentIndex >= [self.objects count] )
        self.currentIndex = 0;
 
    YouTubeVideoModel *model =  [self.objects objectAtIndex: self.currentIndex];
    [self.playerView playVideoWithVideoId:model.videoId];
    [self.control.playBtn setSelected:YES];
    
    [self.control.titleLabel setText:model.title];

}

#pragma mark - Player Delegate

- (void)playerViewDidPlaying:(ACYTPlayerView *)playerView seekTime:(float)time
{
    [self.control setSliedrValue:time];
    [self.control setLeftTime:playerView.currentTime];
    [self.control setRightTime:playerView.duration];
    
    if([self.playerView playerState] == kYTPlayerStateEnded)
    {
    
    }
}

- (void)playerViewDidEnd:(ACYTPlayerView *)playerView videoId:(NSString *)vid
{
    self.currentIndex++;
    [self playVideo];
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
        [self.control.playBtn setSelected:YES];
        [self.playerView playVideo];
    }
    else
    {
        [self.control.playBtn setSelected:NO];
        [self.playerView pauseVideo];
    }
}

-(void)nextPressed
{
    self.currentIndex++;
    [self playVideo];
}

-(void)prePressed
{
    self.currentIndex--;
    [self playVideo];

}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YouTubeListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YouTubeListTableCell" forIndexPath:indexPath];
    [cell showData:[self.objects objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.currentIndex = indexPath.row;
    
    [self playVideo];
}


@end
