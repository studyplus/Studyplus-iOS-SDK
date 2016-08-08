//  The MIT License (MIT)
//
//  Copyright (c) 2014 Studyplus inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "AFNetworking.h"
#import "SPLStudyplusAPIRequest.h"
#import "SPLStudyplusLogger.h"
#import "SPLStudyplusError.h"

@interface SPLStudyplusAPIRequest()
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSInteger apiVersion;
@end

static NSString * const ApiBaseURL = @"https://external-api.studyplus.jp/";
static NSInteger const ApiDefaultVersion = 1;

@implementation SPLStudyplusAPIRequest

- (id)init
{
    if (self = [super init]) {
        _accessToken = nil;
    }
    return self;
}

+ (SPLStudyplusAPIRequest*)newRequestWithAccessToken:(NSString*)accessToken
                                             options:(NSDictionary*)options
{
    return [[SPLStudyplusAPIRequest alloc] initWithAccessToken:accessToken
                                                       options:options];
}

- (id)initWithAccessToken:(NSString*)accessToken
                  options:(NSDictionary*)options
{
    if (self = [super init]) {
        _accessToken = accessToken;
        _apiVersion = options[@"version"] ? [options[@"version"] integerValue] : ApiDefaultVersion;
    }
    return self;
}

- (void)postRequestWithPath:(NSString *)path
           requestParameter:(NSDictionary *)requestParameter
                  completed:(void(^)(NSDictionary *response))completed
                     failed:(void(^)(NSError *error))failed
{
    if (!self.accessToken || self.accessToken.length == 0) {
        failed([SPLStudyplusError errorFromStudyplusErrorCode:SPLErrorCodeNoAccessToken]);
        return;
    }
    
    [self sendRequestWithPath:path
                requestParams:requestParameter
                    completed:completed
                       failed:^(NSInteger httpStatusCode, NSError *error) {
                           if (error) {
                               failed(error);
                           } else {
                               failed([SPLStudyplusError errorFromStudyRecordPostStatusCode:httpStatusCode]);
                           }
                       }];
}

- (void)sendRequestWithPath:(NSString*)path
              requestParams:(NSDictionary *)requestParams
                  completed:(void(^)(NSDictionary *response))completed
                     failed:(void(^)(NSInteger httpStatusCode, NSError *error))failed
{
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:[NSString stringWithFormat:@"OAuth %@", self.accessToken]
             forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;
    
    [manager POST:[self buildUrlFromPath:path] parameters:requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
        StudyplusSDKLog(@"response: %@", response);
        completed(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        StudyplusSDKLog(@"Error: %@", error);
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        failed(res.statusCode, error);
    }];
}

- (NSString *)apiBaseURL
{
#ifdef STUDYPLUS_API_URL
    return STUDYPLUS_API_URL;
#else
    return ApiBaseURL;
#endif
}

- (NSString *)buildUrlFromPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@v%ld/%@", [self apiBaseURL], (long)self.apiVersion, path];
}

@end
