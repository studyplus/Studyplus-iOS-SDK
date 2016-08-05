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

#import "SPLStudyplusError.h"
#import "SPLStudyplusLogger.h"

static NSString* const ErrorDomain = @"jp.studyplus.sdk";

@implementation SPLStudyplusError

+ (NSError*)errorFromStudyplusErrorCode:(SPLErrorCode)studyplusErrorCode
{
    NSError *error;
    switch (studyplusErrorCode) {
        case SPLErrorCodeGetAppDescription:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Failed to get information about application. (400 bad request)"];
            break;
            
        case SPLErrorCodeAuthFailed:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Failed to authorize Studyplus user. (400 bad request)"];
            break;
            
        case SPLErrorCodeLoginFailed:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Failed to login to Studyplus. (400 bad request)"];
            break;
            
        case SPLErrorCodeStudyplusInMaintenance:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Maybe Studyplus is in temporary maintenance."];
            break;
            
        case SPLErrorCodeInvalidStudyplusSession:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Studyplus session is invalid."];
            break;
            
        case SPLErrorCodeNetworkUnavailable:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Network is not available."];
            break;
            
        case SPLErrorCodeServerError:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Some error(s) occurred in Studyplus server."];
            break;
            
        case SPLErrorCodePostRecordFailed:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:@"Failed to post study record. (400 bad request)"];
            break;

        case SPLErrorCodeNoAccessToken:
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                                localizedDescription:@"No access token"];
            break;

        case SPLErrorCodeUnknown:
            error = [SPLStudyplusError errorWithCode:SPLErrorCodeUnknown
                         localizedDescription:@"Unknown Error."];
            break;
        default:
            StudyplusSDKLog(@"Unexpected Studyplus status:[%ld]", (long)studyplusErrorCode);
            error = [SPLStudyplusError errorWithCode:studyplusErrorCode
                         localizedDescription:[NSString
                                               stringWithFormat:@"Unexpected Error(errorCode:[%ld]).",
                                               (long)studyplusErrorCode]];
            break;
    }
    return error;
}

+ (NSError*)errorFromStudyRecordPostStatusCode:(NSInteger)httpStatusCode
{
    if (httpStatusCode < 400 || 599 < httpStatusCode) {
        // no error
        return nil;
    }
    
    NSError *error;
    switch (httpStatusCode) {
        case 400:
            error = [SPLStudyplusError
                     errorFromStudyplusErrorCode:SPLErrorCodePostRecordFailed];
            break;
            
        case 401:
            error = [SPLStudyplusError
                     errorFromStudyplusErrorCode:SPLErrorCodeInvalidStudyplusSession];
            break;
            
        case 500:
            error = [SPLStudyplusError
                     errorFromStudyplusErrorCode:SPLErrorCodeServerError];
            
            break;
        case 503:
            error = [SPLStudyplusError
                     errorFromStudyplusErrorCode:SPLErrorCodeStudyplusInMaintenance];
            break;
            
        default:
            StudyplusSDKLog(@"Unexpected http status:[%ld]", (long)httpStatusCode);
            error = [SPLStudyplusError
                     errorFromStudyplusErrorCode:SPLErrorCodeUnknown];
            break;
    }
    return error;
}

+ (NSError*)errorWithCode:(SPLErrorCode)errorCode localizedDescription:(NSString*)localizedDescription
{
    return [NSError errorWithDomain:ErrorDomain
                               code:errorCode
                           userInfo:@{NSLocalizedDescriptionKey:localizedDescription}];
}

@end
