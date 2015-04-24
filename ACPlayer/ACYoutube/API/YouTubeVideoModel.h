//
//  YouTubeVideoModel.h
//  PetViewer
//
//  Created by alan on 13/10/13.
//  Copyright (c) 2013年 MoneyMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeVideoModel : NSObject

@property (nonatomic,strong)NSDictionary *info;

-(id)initWithInfo:(NSDictionary *)info;

-(NSString *)videoId;
-(NSString *)thumbnail; // 320x180
-(NSString *)standardImage; // 640x480
-(NSString *)defaultImage;
-(NSString *)highImage;
-(NSString *)title;
-(NSString *)videoUrl;
-(NSString *)descriptionText;
-(NSString *)channelTitle;
-(NSString *)publishedDate;

-(NSInteger)likeCount;
-(NSInteger)dislikeCount;
-(NSInteger)viewCount;
-(NSString *)duration;

-(void)printInfo;

-(NSString *)displayViewCount;
-(NSString *)displayDuration;
-(NSString *)displayLikePercentage;
-(NSString *)displayDate;

@end

/*  ////////////// info ///////////////

{
    contentDetails =             {
        caption = false;
        definition = hd;
        dimension = 2d;
        duration = PT11M8S;
        licensedContent = 0;
    };
    etag = "\"iqhxZrClbEyBShCvV0oqU2l98lA/l-b2bieI-d6hGDnf-N5bNDXw5fg\"";
    id = jAE9H9Xebpo;
    kind = "youtube#video";
    snippet =             {
        categoryId = 22;
        channelId = UCvORvP97VudgUE664SaG0uQ;
        channelTitle = "\U51a0\U9298 \U90b1";
        description = "";
        liveBroadcastContent = none;
        publishedAt = "2013-10-21T07:31:45.000Z";
        thumbnails =                 {
        default =                     {
            url = "https://i1.ytimg.com/vi/jAE9H9Xebpo/default.jpg";
        };
            high =                     {
                url = "https://i1.ytimg.com/vi/jAE9H9Xebpo/hqdefault.jpg";
            };
            maxres =                     {
                url = "https://i1.ytimg.com/vi/jAE9H9Xebpo/maxresdefault.jpg";
            };
            medium =                     {
                url = "https://i1.ytimg.com/vi/jAE9H9Xebpo/mqdefault.jpg";
            };
            standard =                     {
                url = "https://i1.ytimg.com/vi/jAE9H9Xebpo/sddefault.jpg";
            };
        };
        title = "\U90b1\U560e\U654f\Uff0c\U58d3\U8840\U968a\U901a\U95dc\U3010\U7121\U61fc\U4e4b\U8def - \U5c60\U9f8d\U8005\U6b7b\U9b25\U3011[\U795e\U9b54\U4e4b\U5854]";
    };
    statistics =             {
        commentCount = 5;
        dislikeCount = 0;
        favoriteCount = 0;
        likeCount = 13;
        viewCount = 251;
    };
},
*/

