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

#import <UIKit/UIKit.h>

#import "SPLStudyplus.h"
#import "SPLStudyplusAPIRequest.h"
#import "SPLStudyplusLogger.h"
#import "SPLStudyplusError.h"
#import "UICKeyChainStore.h"

static NSString * const UsernameStoreKey = @"username";
static NSString * const AccessTokenStoreKey = @"accessToken";
static NSString * const AppStoreURL = @"https://itunes.apple.com/jp/app/mian-qiangga-leshiku-xuku!/id505410049?mt=8";

@interface SPLStudyplus()
@property (nonatomic, copy, readwrite) NSString *consumerKey;
@property (nonatomic, copy, readwrite) NSString *consumerSecret;
@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *accessToken;
@property (nonatomic, readwrite) SPLStopwatch *stopwatch;
@end

@implementation SPLStudyplus

+ (SPLStudyplus*)studyplusWithConsumerKey:(NSString*)consumerKey
                        andConsumerSecret:(NSString*)consumerSecret
{
    return [[SPLStudyplus alloc] __initWithConsumerKey:consumerKey
                                     andConsumerSecret:consumerSecret];
}

- (id)__initWithConsumerKey:(NSString*)consumerKey
          andConsumerSecret:(NSString*)consumerSecret {
    
    if (self = [super init]) {
        self.consumerKey = consumerKey;
        self.consumerSecret = consumerSecret;
        self.username = nil;
        self.accessToken = nil;
        self.openAppStoreIfNotInstalled = YES;
        self.apiVersion = 1;
        self.debug = NO;
        self.stopwatch = [SPLStopwatch new];
    }
    
    return self;
}

- (NSString*)username
{
    return [[self keyChain] stringForKey:UsernameStoreKey];
}

- (NSString*)accessToken
{
    return [[self keyChain] stringForKey:AccessTokenStoreKey];
}

- (id)authWhenError:(NSError**)error
{
    return nil;
}

- (BOOL)auth
{
    return [self openStudyplus:@"auth"];
}

- (BOOL)login
{
    return [self openStudyplus:@"login"];
}

- (void)logout
{
    UICKeyChainStore *keyChain = [self keyChain];
    [keyChain removeItemForKey:AccessTokenStoreKey];
    [keyChain removeItemForKey:UsernameStoreKey];
    [keyChain synchronize];
}

- (BOOL)isConnected
{
    return self.accessToken != nil;
}

- (void)postStudyRecord:(SPLStudyplusRecord *)studyplusRecord
{
    if (self.debug) {
        if ([self.delegate respondsToSelector:@selector(studyplusDidPostStudyRecord:)]) {
            [self.delegate studyplusDidPostStudyRecord:self];
        }
        return;
    }
    
    SPLStudyplusAPIRequest *request = [SPLStudyplusAPIRequest
                                       newRequestWithAccessToken:self.accessToken
                                       options:@{
                                                 @"version": [NSNumber numberWithInteger:self.apiVersion],
                                                 }];
    
    __block id<SPLStudyplusDelegate> __delegate = self.delegate;
    
    [request postRequestWithPath:@"study_records"
                requestParameter:[studyplusRecord toRequestParam]
                       completed:^(NSDictionary *responseParameter) {
                           if ([__delegate respondsToSelector:@selector(studyplusDidPostStudyRecord:)]) {
                               [__delegate studyplusDidPostStudyRecord:self];
                           }
                       } failed:^(NSError *error) {
                           if ([__delegate respondsToSelector:@selector(studyplusDidFailToPostStudyRecord:withError:)]) {
                               [__delegate studyplusDidFailToPostStudyRecord:self withError:error];
                           }
                       }];
}

- (BOOL)openURL:(NSURL*)url
{
    if (![self isAcceptableURL:url]) {
        return NO;
    }
    
    if ([url.pathComponents[1] isEqualToString:@"success"]) {
        NSString *accessToken = url.pathComponents[2];
        NSString *username = url.pathComponents[3];
        [self saveAccessToken:accessToken andUsername:username];
        [self.delegate studyplusDidConnect:self];
    } else if ([url.pathComponents[1] isEqualToString:@"fail"]) {
        NSInteger studyplusErrorCode = [url.pathComponents[2] integerValue];
        [self.delegate studyplusDidFailToConnect:self
                                       withError:[SPLStudyplusError
                                                  errorFromStudyplusErrorCode:studyplusErrorCode]];
    } else if ([url.pathComponents[1] isEqualToString:@"cancel"]) {
        if ([self.delegate respondsToSelector:@selector(studyplusDidCancel:)]) {
            [self.delegate studyplusDidCancel:self];
        }
    } else {
        StudyplusSDKLog(@"Unknown format : %@", [url absoluteString]);
        return NO;
    }
    
    return YES;
}

#pragma mark - privates

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init method is not available."
                                 userInfo:nil];
    return nil;
}

- (void)saveAccessToken:(NSString*)accessToken andUsername:(NSString*)username
{
    UICKeyChainStore *keyChain = [self keyChain];
    [keyChain setString:accessToken forKey:AccessTokenStoreKey];
    [keyChain setString:username forKey:UsernameStoreKey];
    [keyChain synchronize];
}

- (NSString*)urlScheme
{
    return [NSString stringWithFormat:@"studyplus-%@", self.consumerKey];
}

- (BOOL)openStudyplus:(NSString*)command
{
    NSString *urlString = [NSString stringWithFormat:
                           @"studyplus://external_app/%@/%@/%@",
                           command,
                           self.consumerKey,
                           self.consumerSecret
                           ];
    NSURL *url = [NSURL URLWithString:urlString];
    
    BOOL isStudyplusOpened = [UIApplication.sharedApplication openURL:url];
    if (isStudyplusOpened) {
        return YES;
    }
    
    // Studyplus app is not installed.
    
    if (self.openAppStoreIfNotInstalled) {
        NSURL *url = [NSURL URLWithString:AppStoreURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    return NO;
}

- (UICKeyChainStore*)keyChain
{
    NSString *keyChainServiceName = [NSString stringWithFormat:@"Studyplus_iOS_SDK_%@", self.consumerKey];
    return [UICKeyChainStore keyChainStoreWithService:keyChainServiceName];
}

- (BOOL)isAcceptableURL:(NSURL*)url
{
    if (![url.scheme isEqualToString:[self urlScheme]]
        || !url.host
        || !url.pathComponents) {
        return NO;
    }
    
    BOOL isAuthResult = [url.host isEqualToString:@"auth-result"];
    BOOL isLoginResult = [url.host isEqualToString:@"login-result"];
    if (!isAuthResult && !isLoginResult) {
        return NO;
    }
    
    return YES;
}

@end
