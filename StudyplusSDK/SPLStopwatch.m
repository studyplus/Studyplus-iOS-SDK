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

#import "SPLStopwatch.h"

typedef NS_ENUM(NSInteger, SPLStopwatchState) {
    SPLStopwatchStateStarted,
    SPLStopwatchStateStopped
};

@interface SPLStopwatch()
@property (nonatomic, assign) NSUInteger elapsedSeconds;
@property (nonatomic, assign) NSUInteger startedTimestamp;
@property (nonatomic, assign) SPLStopwatchState state;
@end

@implementation SPLStopwatch

-(instancetype)init
{
    if (self = [super init]) {
        self.elapsedSeconds = 0;
        self.startedTimestamp = 0;
        self.state = SPLStopwatchStateStopped;
    }
    return self;
}

-(void)start
{
    if (self.state == SPLStopwatchStateStarted) {
        return;
    }
    self.state = SPLStopwatchStateStarted;
    
    self.startedTimestamp = [[NSDate date] timeIntervalSince1970];
}

-(void)pause
{
    if (self.state == SPLStopwatchStateStopped) {
        return;
    }
    self.state = SPLStopwatchStateStopped;
    
    NSUInteger now = [[NSDate date] timeIntervalSince1970];
    self.elapsedSeconds += (now - self.startedTimestamp);
}

-(void)reset
{
    if (self.state == SPLStopwatchStateStarted) {
        self.startedTimestamp = [[NSDate date] timeIntervalSince1970];
    }
    self.elapsedSeconds = 0;
}

-(NSUInteger)elapsedSeconds
{
    if (self.state == SPLStopwatchStateStarted) {
        NSUInteger now = [[NSDate date] timeIntervalSince1970];
        NSUInteger elapsedSeconds = _elapsedSeconds + (now - self.startedTimestamp);
        return elapsedSeconds;
    } else {
        return _elapsedSeconds;
    }
}

@end
