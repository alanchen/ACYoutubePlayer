//
//  YouTubeVideoModel.m
//  PetViewer
//
//  Created by alan on 13/10/13.
//  Copyright (c) 2013年 MoneyMan. All rights reserved.
//

#import "YouTubeVideoModel.h"

@implementation YouTubeVideoModel

-(id)initWithInfo:(NSDictionary *)info
{
    self =[super init];
    
    if(self){
        self.info = info;
    }
    
    return self;
}

-(NSString *)videoId
{
    return [self.info objectForKey:@"id"];
}

-(NSString *)thumbnail
{
    return [[[[self.info objectForKey:@"snippet"] objectForKey:@"thumbnails"] objectForKey:@"medium"] objectForKey:@"url"];
}

-(NSString *)standardImage
{
    return [[[[self.info objectForKey:@"snippet"] objectForKey:@"thumbnails"] objectForKey:@"standard"] objectForKey:@"url"];
}

-(NSString *)defaultImage
{
    return [[[[self.info objectForKey:@"snippet"] objectForKey:@"thumbnails"] objectForKey:@"default"] objectForKey:@"url"];
}

-(NSString *)highImage
{
    return [[[[self.info objectForKey:@"snippet"] objectForKey:@"thumbnails"] objectForKey:@"high"] objectForKey:@"url"];
}

-(NSString *)title
{
    return [[self.info objectForKey:@"snippet"] objectForKey:@"title"] ;
}

-(NSString *)videoUrl
{
    //https://developers.google.com/youtube/player_parameters
    //Values: 0 or 1. Default is 0. Setting to 1 enables HD playback by default. This has no effect on the Chromeless Player.
    
    return [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@&autoplay=1&hd=1",self.videoId];
//    return [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",self.videoId];
}

-(NSString *)descriptionText
{
    return [[self.info objectForKey:@"snippet"] objectForKey:@"description"] ;
}

-(NSString *)channelTitle
{
     return [[self.info objectForKey:@"snippet"] objectForKey:@"channelTitle"] ;
}

-(NSString *)publishedDate
{
    return [[self.info objectForKey:@"snippet"] objectForKey:@"publishedAt"] ;
}

-(void)printInfo
{
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@ %@",self.title,self.videoUrl,self.thumbnail]);
}

-(NSInteger)likeCount
{
     return [[[self.info objectForKey:@"statistics"] objectForKey:@"likeCount"] integerValue];
}

-(NSInteger)dislikeCount
{
    return [[[self.info objectForKey:@"statistics"] objectForKey:@"dislikeCount"] integerValue];
}

-(NSInteger)viewCount
{
    return [[[self.info objectForKey:@"statistics"] objectForKey:@"viewCount"] integerValue];
}

-(NSString *)duration
{
    return [[self.info objectForKey:@"contentDetails"] objectForKey:@"duration"] ;
}

-(NSString *)displayViewCount;
{
    return  [NSString stringWithFormat:@"%ld  點閱",(long)[self viewCount]];
}

-(NSString *)displayDuration
{
    NSString *duration = [self duration];
    duration = [duration stringByReplacingOccurrencesOfString:@"PT" withString:@""];
    
    NSUInteger hours=0;
    NSUInteger minutes=0;
    NSUInteger seconds=0;
    
    NSRange range = [duration rangeOfString:@"H"];
    if(range.length>0)
    {
        NSString *h = [duration substringToIndex:range.location];
        hours = [h integerValue];
        duration = [duration substringFromIndex:range.location+1];
    }
    
    range = [duration rangeOfString:@"M"];
    if(range.length>0)
    {
        NSString *m = [duration substringToIndex:range.location];
        minutes = [m integerValue];
        duration = [duration substringFromIndex:range.location+1];
    }
    
    range = [duration rangeOfString:@"S"];
    if(range.length>0)
    {
        NSString *s = [duration substringToIndex:range.location];
        seconds = [s integerValue];
    }
    
    NSString *result=@"";
    
    if(hours){
        result = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
    }
    else{
        result = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
    }
    
    return  result;
}

-(NSString *)displayLikePercentage
{
    float total = [self likeCount] + [self dislikeCount];
    float p = 0.0;
    
    if(total)
        p = ((float)[self likeCount] /  (float )total) *100;
    
    if(p==0)
        return @"";
    
    return  [NSString stringWithFormat:@"%.0f%% likes",p];
}

-(NSString *)displayDate
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterFullStyle;
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [formatter dateFromString:[self publishedDate]];
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"yyyy.MM.dd"];

    return [output stringFromDate:date];
}

@end
