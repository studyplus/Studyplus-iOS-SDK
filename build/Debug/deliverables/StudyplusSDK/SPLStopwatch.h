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

/**
 Simple stopwatch with [start/stop/reset] functions. Useful for measuring the learning duration.<br>
 シンプルなストップウォッチです。学習時間(duration)を計測するのに便利です。
 */
@interface SPLStopwatch : NSObject

/**
 Begin or resume measuring.<br>
 測定を開始または再開します。
 */
-(void)start;

/**
 Pause measuring. Elapsed seconds will not be reset.<br>
 測定を一時停止します。経過秒数はリセットされません。
 */
-(void)pause;

/**
 Reset elapsed seconds. Elapsed seconds will be 0, and measuring will not stop.<br>
 経過秒数を0にリセットします。測定中の場合、測定は止まりません。
 */
-(void)reset;

/**
 Returns total elapsed seconds.<br>
 現時点の累計経過秒数を返します。
 */
-(NSUInteger)elapsedSeconds;

@end
