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

#import "SPLStudyplusRecordAmount.h"

@interface SPLStudyplusRecordAmount()
@property (nonatomic, readonly) NSDictionary *requestParameter;
@end

@implementation SPLStudyplusRecordAmount

+ (instancetype)amount:(NSUInteger)amount
{
    return [[[self class] alloc] initAsAmount:amount];
}

- (instancetype)initAsAmount:(NSUInteger)amount
{
    if (self = [super init]) {
        _requestParameter = @{
                              @"amount": [NSNumber numberWithUnsignedInteger:amount],
                              };
    }
    return self;
}

+ (instancetype)amountAsRangeWithFrom:(NSUInteger)from to:(NSUInteger)to
{
    return [[[self class] alloc] initAsRangeWithFrom:from to:to];
}

- (instancetype)initAsRangeWithFrom:(NSUInteger)from to:(NSUInteger)to
{
    if (self = [super init]) {
        _requestParameter = @{
                              @"start_position": [NSNumber numberWithUnsignedInteger:from],
                              @"end_position": [NSNumber numberWithUnsignedInteger:to],
                              };
    }
    return self;
}

+ (instancetype)amountAsNone
{
    return [[[self class] alloc] initAsNone];
}

- (instancetype)initAsNone
{
    if (self = [super init]) {
        _requestParameter = @{};
    }
    return self;
}

- (NSDictionary*)toRequestParameter
{
    return _requestParameter;
}

@end
