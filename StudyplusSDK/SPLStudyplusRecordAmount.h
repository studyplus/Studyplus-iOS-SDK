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

/**
 The class that represents the amount of learning. <br>
 学習量を表すクラスです。
 */
@interface SPLStudyplusRecordAmount : NSObject

/**
 Creates and returns the Amount object with only the total amount of learning.<br>
 合計の学習量のみを持つAmountオブジェクトを生成して返します。
 
 @param amount 学習量。
 @result SPLStudyplusRecordAmount* 生成したAmountオブジェクトです。
 */
+ (instancetype)amount:(NSUInteger)amount;

/**
 Creates and returns the Amount object with a range of learning amount.<br>
 学習量を範囲で持つAmountオブジェクトを生成して返します。
 
 @param from 学習量の起点。
 @param to 学習量の終点。
 @result SPLStudyplusRecordAmount* 生成したAmountオブジェクトです。
 */
+ (instancetype)amountAsRangeWithFrom:(NSUInteger)from to:(NSUInteger)to;

/**
 Creates and returns the Amount object that has no learning amount.<br>
 学習量を持たないAmountオブジェクトを生成して返します。
 @result SPLStudyplusRecordAmount* 生成したAmountオブジェクトです。
 */
+ (instancetype)amountAsNone;

/**
 @result Returns the parameters of the study record for posting API
 */
- (NSDictionary*)toRequestParameter;

NS_ASSUME_NONNULL_END

@end
