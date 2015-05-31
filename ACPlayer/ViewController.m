//
//  ViewController.m
//  ACPlayer
//
//  Created by alan on 2015/4/21.
//  Copyright (c) 2015年 alan. All rights reserved.
//

#import "ViewController.h"

#import "YoutubeVideoPlayer.h"

#import "YouTubeAPIService.h"

#import "YouTubeListTableCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController () <ACYTPlayerViewDelegate , YTPlayerViewDelegate ,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) YoutubeVideoPlayer *playerView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *objects;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation ViewController

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize size = [self.playerView.playerView setWidthAndKeepRatio:self.view.frame.size.width];
    self.playerView.frame =CGRectMake(0, 0, size.width,  size.height);
    
    [self.tableView setFrame:CGRectMake(0,
                                        self.playerView.frame.size.height,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height - self.playerView.frame.size.height)];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];

    self.playerView = [YoutubeVideoPlayer view];
    self.playerView.playerView.playerViewDelegate = self;
    [self.view addSubview:self.playerView];

    //////////////////////////////////////////////////////////////////////////////
    
    [self.playerView.control.nextBtn addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView.control.preBtn addTarget:self action:@selector(prePressed) forControlEvents:UIControlEventTouchUpInside];

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
    [self.playerView playVideo:model.videoId title:model.title];
}

#pragma mark - Player Delegate

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    [self.playerView updateControlLayoutToState:state];
}

- (void)playerViewDidPlaying:(ACYTPlayerView *)playerView seekTime:(float)time
{
    [self.playerView playVideoSliderValue:time currenttime:playerView.currentTime duration:playerView.duration];
}

- (void)playerViewDidEnd:(ACYTPlayerView *)playerView videoId:(NSString *)vid
{
    self.currentIndex++;
    [self playVideo];
}

#pragma mark - Action

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
