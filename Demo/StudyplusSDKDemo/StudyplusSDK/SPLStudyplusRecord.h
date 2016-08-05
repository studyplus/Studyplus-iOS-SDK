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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SPLStudyplusRecordAmount;

/**
 Study record object to post to Studyplus.<br>
 Studyplusに投稿する一件の勉強記録を表現するクラスです。
 */
@interface SPLStudyplusRecord : NSObject

/**
 The seconds of the learning.<br>
 勉強した時間（秒数）です。
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 The date and time of learning.<br>
 勉強した日時です。
 */
@property (nonatomic, readonly) NSDate *recordedAt;

/**
 The amount of learning.<br>
 勉強した量です。
 
 @see StudyplusRecordAmount
 */
@property (nonatomic, readonly) SPLStudyplusRecordAmount *recordAmount;

/**
 The comment of learning.<br>
 勉強に関するコメントです。
 */
@property (nonatomic, readonly, nullable) NSString *comment;

/**
 Creates and returns StudyplusRecord object that has number of seconds, no amount, and empty comment.<br>
 学習時間のみを指定した勉強記録オブジェクトを作成し、返します。学習量とコメントは無しです。
 
 @param duration Specify the seconds of the learning.<br>
 勉強した時間（秒数）を指定してください。

 @result StudyplusRecord object.
 */
+ (SPLStudyplusRecord*)recordWithDuration:(NSTimeInterval)duration;

/**
 Creates and returns StudyplusRecord object that has number of seconds and other attributes.
 学習時間とその他のオプション属性を指定した勉強記録オブジェクトを作成し、返します。
 
 @param duration Specify the seconds of the learning.<br>
 勉強した時間（秒数）を指定してください。
 
 @param options Dictionary with amount:StudyplusRecordAmount, comment:NSString, recordedAt:NSDate.<br>
     // example.<br>
     @{<br>
       // @see StudyplusRecordAmount<br>
       @"amount": [StudyplusRecordAmount amountAsRangeWithFrom:10 to:33],<br>
       // Time the learning is ended. 学習を終えた日時。<br>
       @"recordedAt": [NSDate date],<br>
       // Studyplus timeline comment. Studyplusのタイムライン上で表示されるコメント。<br>
       @"comment": @"アプリ◯◯で勉強しました！",<br>
     }<br>
 
 @result StudyplusRecord object.
 */
+ (SPLStudyplusRecord*)recordWithDuration:(NSTimeInterval)duration options:(NSDictionary* _Nullable)options;

/**
 @result Returns the parameters of the study record for posting API
 */
- (NSDictionary*)toRequestParam;

NS_ASSUME_NONNULL_END

@end
