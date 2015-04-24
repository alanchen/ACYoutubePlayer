//
//  YouTubeAPIService.m
//  PetViewer
//
//  Created by alan on 13/10/21.
//  Copyright (c) 2013年 MoneyMan. All rights reserved.
//

#import "YouTubeAPIService.h"

@implementation YouTubeAPIService

static NSString *baseUrl = @"https://www.googleapis.com/youtube/v3";
static NSString *apiKey = @"AIzaSyB4BlXGyBiGs1x_sR__MXkbw66et0lIhkw";

+(id)sharedInstance
{
    static YouTubeAPIService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YouTubeAPIService alloc] init];
    });
    
    return sharedInstance;
}

// 1.x version

//-(AFHTTPRequestOperation *)createOperationWithMethod:(NSString *)method
//                                                path:(NSString *)path
//                                          parameters:(NSDictionary *)parameters
//{
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
//    NSMutableURLRequest *request = [httpClient requestWithMethod:method path:path parameters:nil];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//
//    return operation;
//}

// 2.x version

-(AFHTTPRequestOperation *)createOperationWithMethod:(NSString *)method
                                                path:(NSString *)path
                                          parameters:(NSDictionary *)parameters
{
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return operation;
}

#pragma  mark - Basic Functions

-(AFHTTPRequestOperation *)apiGetVideoDetailWithIDs:(NSString *)IDs
                                         maxResults:(NSUInteger)maxResults
                                             params:(NSString *)params
                                            success:(void (^)(NSMutableArray *results, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *arg_maxResults = [NSString stringWithFormat:@"&maxResults=%lu",(unsigned long)maxResults];
    NSString *arg_ids = [NSString stringWithFormat:@"&id=%@",IDs];
    NSString *args =[NSString stringWithFormat:@"&part=id,contentDetails,snippet,contentDetails,statistics%@%@",arg_maxResults,arg_ids];
    
    if(params)
        args = [args stringByAppendingString:params];
    
    NSString *searchUrl = [NSString stringWithFormat:@"%@/videos?key=%@%@",baseUrl,apiKey,args] ;
    searchUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *operation = [self createOperationWithMethod:@"GET" path:searchUrl parameters:nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JSON = responseObject;
        NSArray *originalVideos = [JSON objectForKey:@"items"];
        NSMutableArray *videoModels = [NSMutableArray array];
        [originalVideos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            YouTubeVideoModel *model = [[YouTubeVideoModel alloc] initWithInfo:obj];
            [videoModels addObject:model];
        }];
        
        if(success)
            success(videoModels,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
            failure(operation,error);
    }];
    
    
    [operation start];
    
    return operation;
}

//https://developers.google.com/youtube/v3/docs/search/list
-(AFHTTPRequestOperation *)apiSearchVideoWithQuery:(NSString *)query
                                        maxResults:(NSUInteger)maxResults
                                             order:(NSString *)order
                                            params:(NSString *)params
                                           success:(void (^)(NSString *results, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(order==nil)
        order = @"relevance";
    
    NSString *arg_order = [NSString stringWithFormat:@"&order=%@",order];
    NSString *arg_q = [NSString stringWithFormat:@"&q=%@",query];
    NSString *arg_maxResults = [NSString stringWithFormat:@"&maxResults=%lu",(unsigned long)maxResults];
    NSString *args =[NSString stringWithFormat:@"&part=id%@%@%@&videoSyndicated=true&type=video&videoDefinition=high",arg_order,arg_q,arg_maxResults];
    
    if(params)
        args = [args stringByAppendingString:params];
    
    NSString *searchUrl = [NSString stringWithFormat:@"%@/search?key=%@%@",baseUrl,apiKey,args] ;
    NSLog(@"searchUrl = %@",searchUrl);
    searchUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *operation = [self createOperationWithMethod:@"GET" path:searchUrl parameters:nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *originalVideos = [responseObject objectForKey:@"items"];
        NSMutableArray *ids = [NSMutableArray array];
        
        [originalVideos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *idStr = [[obj objectForKey:@"id"] objectForKey:@"videoId"];
            if(idStr)
                [ids addObject:idStr];
        }];
        
        NSString *results = [ids componentsJoinedByString:@","];
        
        if(success)
            success(results,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation,error);
    }];
    
    [operation start];
    
    return operation;
}

-(AFHTTPRequestOperation *)apiGetVideosWithChannelId:(NSString *)channelId
                                          maxResults:(NSUInteger)maxResults
                                               order:(NSString *)order
                                              params:(NSString *)params
                                             success:(void (^)(NSString *results, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *arg_order = [NSString stringWithFormat:@"&order=%@",order];
    NSString *arg_maxResults = [NSString stringWithFormat:@"&maxResults=%lu",(unsigned long)maxResults];
    NSString *args =[NSString stringWithFormat:@"&part=id&channelId=%@%@%@&videoSyndicated=true&type=video&videoDefinition=high",channelId,arg_order,arg_maxResults];
    
    if(params)
        args = [args stringByAppendingString:params];
    
    NSString *searchUrl = [NSString stringWithFormat:@"%@/search?key=%@%@",baseUrl,apiKey,args] ;
    searchUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"searchUrl = %@",searchUrl);
    
    AFHTTPRequestOperation *operation = [self createOperationWithMethod:@"GET" path:searchUrl parameters:nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JSON = responseObject;
        NSArray *originalVideos = [JSON objectForKey:@"items"];
        NSMutableArray *ids = [NSMutableArray array];
        
        [originalVideos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *idStr = [[obj objectForKey:@"id"] objectForKey:@"videoId"];
            if(idStr)
                [ids addObject:idStr];
        }];
        
        NSString *results = [ids componentsJoinedByString:@","];
        
        if(success)
            success(results,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation,error);
    }];
    
    [operation start];

    return operation;
}

-(AFHTTPRequestOperation *)apiGetVideosWithPlaylistId:(NSString *)playlistId
                                           maxResults:(NSUInteger)maxResults
                                              success:(void (^)(NSString *results, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    NSString *searchUrl = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=%lu&playlistId=%@&fields=items(snippet)&key=%@", (unsigned long)maxResults, playlistId, apiKey];
    
    searchUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPRequestOperation *operation = [self createOperationWithMethod:@"GET" path:searchUrl parameters:nil];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JSON = responseObject;
        NSArray *items = [JSON objectForKey:@"items"];
        NSMutableArray *ids = [NSMutableArray array];
        
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *snippet = [obj objectForKey:@"snippet"];
            
            if (snippet) {
                NSDictionary *resourceId = [snippet objectForKey:@"resourceId"];
                if (resourceId) {
                    NSString *kind = [resourceId objectForKey:@"kind"];
                    
                    if ([kind isEqualToString:@"youtube#video"]) {
                        NSString *idStr = [resourceId objectForKey:@"videoId"];
                        if(idStr){
                            [ids addObject:idStr];
                        }
                    }
                    
                }
            }
        }];
        
        
        NSString *results = [ids componentsJoinedByString:@","];
    
        if(success)
            success(results,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
            failure(operation,error);
    }];

    [operation start];
    
    return operation;
}


#pragma  mark - Detail

-(void)apiSearchVideoDetaiilWithQuery:(NSString *)query
                           maxResults:(NSUInteger)maxResults
                                order:(NSString *)order
                               params:(NSString *)params
                              success:(void (^)(NSMutableArray *results, id responseObject, id info))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation_serach =
    [[YouTubeAPIService sharedInstance] apiSearchVideoWithQuery:query
                                                     maxResults:maxResults
                                                          order:order
                                                         params:params
                                                        success:^(NSString *results, id responseObject)
     {
         
         NSMutableDictionary *info = [NSMutableDictionary dictionary];
         
         NSString *nextPageToken = [responseObject objectForKey:@"nextPageToken"];
         if(nextPageToken){[info setObject:nextPageToken forKey:@"nextPageToken"];}
         
         [[YouTubeAPIService sharedInstance] apiGetVideoDetailWithIDs:results
                                                           maxResults:maxResults
                                                               params:nil
                                                              success:^(NSMutableArray *results, id responseObject) {
                                                                  
                                                                  if(success)
                                                                      success(results,responseObject,info);
                                                                  
                                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                  
                                                                  if(failure)
                                                                      failure(operation,error);
                                                                  
                                                              } ];
     }
                                                        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if(failure)
             failure(operation,error);
     }];
    
    [operation_serach start];
}

-(void)apiGetVideoDetaiilWithChannelId:(NSString *)channelId
                            maxResults:(NSUInteger)maxResults
                                 order:(NSString *)order
                                params:(NSString *)params
                               success:(void (^)(NSMutableArray *results, id responseObject, id info))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    AFHTTPRequestOperation *operation_serach =
    [[YouTubeAPIService sharedInstance] apiGetVideosWithChannelId:channelId
                                                       maxResults:maxResults
                                                            order:order
                                                           params:params
                                                          success:^(NSString *results, id responseObject)
     {
         
         NSDictionary *JSON = responseObject;
         NSMutableDictionary *info = [NSMutableDictionary dictionary];
         
         NSString *nextPageToken = [JSON objectForKey:@"nextPageToken"];
         if(nextPageToken){[info setObject:nextPageToken forKey:@"nextPageToken"];}
         
         [[YouTubeAPIService sharedInstance] apiGetVideoDetailWithIDs:results
                                                           maxResults:maxResults
                                                               params:nil
                                                              success:^(NSMutableArray *results, id responseObject)
          {
              if(success)
                  success(results,responseObject,info);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if(failure)
                  failure(operation,error);
              
          } ];
         
     }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if(failure)
             failure(operation,error);
     }];
    
    [operation_serach start];
}

-(void)apiGetPlaylistItemsWithPlaylistId:(NSString *)playlistId
                              maxResults:(NSUInteger)maxResults
                                 success:(void (^)(NSMutableArray *results, id responseObject, id info))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    AFHTTPRequestOperation *operation =
    [[YouTubeAPIService sharedInstance] apiGetVideosWithPlaylistId:playlistId
                                                        maxResults:maxResults
                                                           success:^(NSString *results, id responseObject)
     {
         [[YouTubeAPIService sharedInstance] apiGetVideoDetailWithIDs:results
                                                           maxResults:maxResults
                                                               params:nil
                                                              success:^(NSMutableArray *results, id responseObject)
          {
              if(success)
                  success(results,responseObject ,nil);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if(failure)
                  failure(operation,error);
              
          } ];
     }
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         if(failure)
             failure(operation,error);
     }];
    
    [operation start];
}

@end
