//  Copyright (c) 2013年 studyplus.jp. All rights reserved.

#import "Kiwi.h"
#import "SPLStudyplus.h"

SPEC_BEGIN(SPLStudyplusTest)

describe(NSStringFromClass([SPLStudyplus class]), ^{
    
    describe(@"studyplusWithConsumerKey:consumerSecret:", ^{
        
        context(@"consumerKey and consumerSecret are specified", ^{
            SPLStudyplus *sp = [SPLStudyplus studyplusWithConsumerKey:@"cKey" andConsumerSecret:@"cSecret"];

            it(@"returns Studyplus object with specified values", ^{
                [[sp should] beKindOfClass:[SPLStudyplus class]];
                [[sp.consumerKey should] equal:@"cKey"];
                [[sp.consumerSecret should] equal:@"cSecret"];
            });
        });
        
        context(@"consumerKey is not specified", ^{
            SPLStudyplus *sp = [SPLStudyplus studyplusWithConsumerKey:nil andConsumerSecret:@"cSecret"];
            
            it(@"returns Studyplus object with nil consumerKey", ^{
                [[sp should] beKindOfClass:[SPLStudyplus class]];
                [[sp.consumerKey should] beNil];
                [[sp.consumerSecret should] equal:@"cSecret"];
            });
        });
        
        context(@"consumerSecret is not specified", ^{
            SPLStudyplus *sp = [SPLStudyplus studyplusWithConsumerKey:@"cKey" andConsumerSecret:nil];
            
            it(@"returns Studyplus object with nil consumerSecret", ^{
                [[sp should] beKindOfClass:[SPLStudyplus class]];
                [[sp.consumerKey should] equal:@"cKey"];
                [[sp.consumerSecret should] beNil];
            });
        });

    });
});

SPEC_END
