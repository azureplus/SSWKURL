//
//  TPWKURLProtocol.m
//  trustpocket
//
//  Created by sgcy on 2020/4/21.
//  Copyright © 2020 sgcy. All rights reserved.
//

#import "TPWKURLProtocol.h"

@interface TPWKURLProtocol()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession         *session;
@property (nonatomic, strong) NSURLResponse        *response;
@property (nonatomic, strong) NSData               *data;
@property (nonatomic, strong) NSDate               *startDate;
@property (nonatomic, strong) NSError              *error;
@property (nonatomic, strong) NSOperationQueue     *queue;

@end

@implementation TPWKURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
//    ///只缓存get请求
//    if (request.HTTPMethod && ![request.HTTPMethod.uppercaseString isEqualToString:@"GET"]) {
//        return NO;
//    }
//

//
//    /// 不缓存 ajax 请求
//    NSString *hasAjax = [request valueForHTTPHeaderField:@"X-Requested-With"];
//    if (hasAjax != nil) {
//        return NO;
//    }
//
//    NSString *pathExtension = [request.URL.absoluteString componentsSeparatedByString:@"?"].firstObject.pathExtension.lowercaseString;
//    NSArray *validExtension = @[ @"jpg", @"jpeg", @"gif", @"png", @"webp", @"bmp", @"tif", @"ico", @"js", @"css", @"html", @"htm", @"ttf", @"svg"];
//    if (pathExtension && [validExtension containsObject:pathExtension]) {
//        return YES;
//    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
//    NSString *hasAjax = [request valueForHTTPHeaderField:@"X-Requested-With"];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    if (request.HTTPBody.length > 0) {
        NSDictionary *headers = @{
                                  @"customize": @"customize",
                                  };
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
            [mutableRequest setValue:obj forHTTPHeaderField:key];
        }];
    }
    return [mutableRequest copy];
}


- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.queue];
    }
    return _session;
}

- (void)startLoading:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    
    self.startDate  = [NSDate date];
//    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        completionHandler(data,response,error);
//        self.data = data;
//        self.response = response;
//        self.error = error;
//        [self finishLoading];
//    }];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request];
    
    self.dataTask = task;
    [task resume];

}



- (void)stopLoading
{
    [self.dataTask cancel];
}

- (void)finishLoading {
    [self.dataTask cancel];
    self.dataTask  = nil;
    
    
    NSLog(@"[URL]:%@",self.request.URL.absoluteString);
    NSLog(@"[HEADERS]:%@",self.request.allHTTPHeaderFields);
    NSLog(@"[BODY]:%@",self.request.HTTPBody);
    NSLog(@"[RESPONSE]:%@",self.response);


}


#pragma mark - delegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    if (completionHandler) {
        completionHandler(disposition);
    }
}



- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{

}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSCachedURLResponse *cachedResponse = proposedResponse;

    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}


@end
