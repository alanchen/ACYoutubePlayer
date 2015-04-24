//
//  YouTubeAPIService.h
//  PetViewer
//
//  Created by alan on 13/10/21.
//  Copyright (c) 2013年 MoneyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "YouTubeVideoModel.h"

 //https://developers.google.com/youtube/v3/docs/
//https://developers.google.com/youtube/v3/docs/search/list

//====================================================================================
// channel https://www.youtube.com/channel/UCvORvP97VudgUE664SaG0uQ/
//
// Example url: https://www.googleapis.com/youtube/v3/search?key=AIzaSyB4BlXGyBiGs1x_sR__MXkbw66et0lIhkw&channelId=UCvORvP97VudgUE664SaG0uQ&part=id&order=date&maxResults=15
//====================================================================================

//====================================================================================
// Play list https://www.youtube.com/playlist?list=PL-yoZZaZqjZ6ziLeRkaxsEL5ii0SIYLRh
//
// API Reference:
// https://developers.google.com/youtube/v3/docs/playlistItems/list
//
// Example url: https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=16&playlistId=PL-yoZZaZqjZ6ziLeRkaxsEL5ii0SIYLRh&fields=items(snippet)&key=AIzaSyB4BlXGyBiGs1x_sR__MXkbw66et0lIhkw
//====================================================================================


@interface YouTubeAPIService : NSObject

+(id)sharedInstance;

/*

 https://developers.google.com/youtube/v3/docs/search/list

 order = date rating relevance title videoCount viewCount
 
 If you want to get next page , send nextPage to params like this
 nextPageToken is from api callback info [info objectForKey:@"nextPageToken"];
 nextPage = [NSString stringWithFormat:@"&pageToken=%@",nextPageToken];
 
 */

-(void)apiSearchVideoDetaiilWithQuery:(NSString *)query
                           maxResults:(NSUInteger)maxResults
                                order:(NSString *)order
                               params:(NSString *)params
                              success:(void (^)(NSMutableArray *results, id responseObject , id info))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)apiGetVideoDetaiilWithChannelId:(NSString *)channelId
                            maxResults:(NSUInteger)maxResults
                                 order:(NSString *)order
                                params:(NSString *)params
                               success:(void (^)(NSMutableArray *results, id responseObject, id info))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)apiGetPlaylistItemsWithPlaylistId:(NSString *)playlistId
                              maxResults:(NSUInteger)maxResults
                                 success:(void (^)(NSMutableArray *results, id responseObject, id info))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
