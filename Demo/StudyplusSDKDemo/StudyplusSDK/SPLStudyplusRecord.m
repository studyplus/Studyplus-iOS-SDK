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

#import "SPLStudyplusRecord.h"
#import "SPLStudyplusRecordAmount.h"

@interface NSDate(Formattable)
- (NSString*)toString:(NSString*)format;
@end

@interface NSDictionary(GetOrElse)
- (id)getKey:(NSString*)key orElse:(id)elseValue;
@end

@implementation SPLStudyplusRecord

+ (instancetype)recordWithDuration:(NSTimeInterval)duration
{
    return [self recordWithDuration:duration options:@{}];
}

+ (instancetype)recordWithDuration:(NSTimeInterval)duration options:(NSDictionary*)options
{
    return [[[self class] alloc] initWithDuration:duration options:options];
}

- (id)getKey:(NSString *)key from:(NSDictionary *)dict orElse:(id)elseValue
{
    id value = dict[key];
    if (value == [NSNull null] || value == nil) {
        value = elseValue;
    }
    return value;
}

- (id)initWithDuration:(NSTimeInterval)duration options:(NSDictionary*)options
{
    if (self = [super init]) {
        _duration = duration;
        _recordAmount = [options getKey:@"amount" orElse:[SPLStudyplusRecordAmount amountAsNone]];
        _recordedAt = [options getKey:@"recordedAt" orElse:[NSDate date]];
        _comment = [options getKey:@"comment" orElse:nil];
    }
    return self;
}

- (NSDictionary*)toRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"duration"] = [NSNumber numberWithDouble:self.duration];
    param[@"recorded_at"] = [self.recordedAt toString:@"yyyy-MM-dd HH:mm:ss"];
    if (self.comment != nil) {
        param[@"comment"] = self.comment;
    }    
    for (NSString *key in self.recordAmount.toRequestParameter) {
        param[key] = self.recordAmount.toRequestParameter[key];
    }
    return (NSDictionary*)param;
}

@end

@implementation NSDate(Formattable)
- (NSString*)toString:(NSString*)format
{
    NSDateFormatter *formatter   = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:format];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    return [formatter stringFromDate:self];
}
@end

@implementation NSDictionary(GetOrElse)
- (id)getKey:(NSString *)key orElse:(id)elseValue
{
    id value = self[key];
    if (value == [NSNull null] || value == nil) {
        value = elseValue;
    }
    return value;
}
@end