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

@class SPLStudyplus;

/**
 The delegate to receive callbacks from SPLStudyplus.
 
 SPLStudyplusオブジェクトに対する各種操作後のコールバックを受けるdelegateです。
 */
@protocol SPLStudyplusDelegate <NSObject>

/**
 Will be called after the SPLStudyplus#login or SPLStudyplus#auth was successful.<br>
 SPLStudyplus#auth または SPLStudyplus#login が成功した後に呼ばれます。
 
 @param studyplus SPLStudyplus object.<br>
 SPLStudyplusオブジェクトです。
 */
- (void)studyplusDidConnect:(SPLStudyplus*)studyplus;

/**
 Will be called after the SPLStudyplus#login or SPLStudyplus#auth was failure.<br>
 SPLStudyplus#auth または SPLStudyplus#login が失敗した後に呼ばれます。

 @param studyplus Studyplus object.<br>
 Studyplusオブジェクトです。
 @param error Error object including failure reason.<br>
 失敗の理由を持つエラーオブジェクトです。
 @see StudyplusNSError.h
 */
- (void)studyplusDidFailToConnect:(SPLStudyplus*)studyplus withError:(NSError*)error;

@optional

/**
 Will be called after the SPLStudyplus#login or SPLStudyplus#auth was cancelled.<br>
 SPLStudyplus#auth または SPLStudyplus#login がキャンセルされた後に呼ばれます。
 
 @param studyplus SPLStudyplus object.<br>
 SPLStudyplusオブジェクトです。
 */
- (void)studyplusDidCancel:(SPLStudyplus*)studyplus;

/**
 Will be called after the SPLStudyplus#postStudyRecord was successful.<br>
 SPLStudyplus#postStudyRecord: が成功した後に呼ばれます。
 
 @param studyplus SPLStudyplus object.<br>
 SPLStudyplusオブジェクトです。
 */
- (void)studyplusDidPostStudyRecord:(SPLStudyplus*)studyplus;

/**
 Will be called after the SPLStudyplus#postStudyRecord was failure. If this method is called, study record was not posted.<br>
 SPLStudyplus#postStudyRecord: が失敗した後に呼ばれます。このメソッドが呼ばれた場合、勉強ログは投稿されていません。

 @param error Error object including failure reason.<br>
 失敗の理由を持つエラーオブジェクトです。
 @see SPLStudyplusError
 */
- (void)studyplusDidFailToPostStudyRecord:(SPLStudyplus*)studyplus withError:(NSError*)error;

@end
