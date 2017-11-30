StudyplusSDK
=======

Studyplus iOS SDK for Objective-C.
[New Studyplus iOS SDK for Swift.](https://github.com/studyplus/Studyplus-iOS-SDK-V2)

## Requirements

 * iOS 8.0 or above
 * Xcode command line tools
 * ARC
 * [Studyplus iOS App 3.10.0 or adove](https://itunes.apple.com/jp/app/mian-qiangga-leshiku-xuku!/id505410049?mt=8)
 * CocoaPods (Optional, but recommended)
 
## Dependency
 * [AFNetworking](https://github.com/AFNetworking/AFNetworking)
 * [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore)

## Install

### CocoaPods (Recommended)

```ruby
# Edit your podfile
platform :ios, '8.0'
pod 'StudyplusSDK'
```
and run
```pod install ```

### Manual install

#### By library and headers 

1. Get StudyplusSDK.
  * ```git clone https://github.com/studyplus/Studyplus-iOS-SDK``` or download zip from [this page](https://github.com/studyplus/Studyplus-iOS-SDK/releases).
2. Copy ```build/Release/deliverables/StudyplusSDK``` to your project.
3. Install [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore) too.
4. Add required frameworks(i.e. ```Security.framework, SystemConfiguration.framework, MobileCoreServices, CoreGraphics``` etc). See [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore).

#### By source copy (iOS 8 required)

1. Get StudyplusSDK
  * ```git clone https://github.com/studyplus/Studyplus-iOS-SDK``` or download zip from [this page](https://github.com/studyplus/Studyplus-iOS-SDK/releases).
2. Copy Studyplus-iOS-SDK/StudyplusSDK directory to your project.
3. Install [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore) too.

## Usage

### Set up custom URL scheme

- set "studyplus-*{your consumer key}*" to URL Types.
(ex. studyplus-MIoh79q7pfMbTUVA3BNsSeTaZRcOK3yg )
- If you don't have consumerKey and consumerSecret, please contact https://info.studyplus.co.jp/contact/studyplus-api


![xcode](https://raw.github.com/studyplus/Studyplus-iOS-SDK/master/docs/set_url_scheme.png)

### Initialize

```Objective-C
#import "SPLStudyplusDelegate.h"

@interface YourClass<SPLStudyplusDelegate>
-(BOOL)openURL:(NSURL*)url;
@end
```

```Objective-C
#import "SPLStudyplus.h"

static NSString * const ConsumerKey = @"Your Studyplus consumer key";
static NSString * const ConsumerSecret = @"Your Studyplus consumer secret";

static SPLStudyplus *studyplus;

@implementation YourClass

-(id) init {

    if (self = [super init]) {
        studyplus = [SPLStudyplus studyplusWithConsumerKey:ConsumerKey
                                         andConsumerSecret:ConsumerSecret];
        studyplus.delegate = self;
    }
    return self;
}
```

### Auth or Login
```Objective-C
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [yourClassObject openURL:url];
}
```

```Objective-C
@interface YourClass
-(BOOL)openURL:(NSURL*)url;
@end
```

```Objective-C
@implementation YourClass

-(void) doAuth {
    [studyplus auth];
}

-(void) doLogin
{
    [studyplus login];
}

// Called by AppDelegate
-(BOOL) openURL:(NSURL*)url
{
    return [studyplus openURL:url];
}

// callback methods
-(void)studyplusDidConnect:(SPLStudyplus*)studyplus
{
    NSLog(@"Auth or Login succeeded");
}

-(void)studyplusDidFailToConnect:(SPLStudyplus*)studyplus withError:(NSError*)error
{
    NSLog(@"Auth or Login failed");
}

- (void)studyplusDidCancel:(SPLStudyplus*)studyplus
{
    NSLog(@"Auth or Login canceled");
} 
```

### Post study record to Studyplus

```Objective-C
-(void)post
{

    // Create new study record.
    SPLStudyplusRecord *studyplusRecord =
      [SPLStudyplusRecord
      
       /**
        @see SPLStopwatch
        */
       recordWithDuration:[studyplus.stopwatch elapsedSeconds]

       /** You can add optional info.
       options:@{
           // Time the learning is ended. 学習を終えた日時。
           @"recordedAt" : [NSDate date],
           // Studyplus timeline comment. Studyplusのタイムライン上で表示されるコメント。
           @"comment" : @"アプリ◯◯で勉強しました！！",
           // @see SPLStudyplusRecordAmount
           @"amount" : [SPLStudyplusRecordAmount amount:100],
       }
       */

      ];

    // post
    [studyplus postStudyRecord:studyplusRecord];

}

// callback methods
-(void)studyplusDidPostStudyRecord:(SPLStudyplus*)studyplus
{
    NSLog(@"Post to Studyplus succeeded");
}

-(void)studyplusDidFailToPostStudyRecord:(SPLStudyplus*)studyplus withError:(NSError*)error
{
    // see @SPLStudyplusError with error.code.
    NSLog(@"Post to Studyplus failed");
}
```

### More info about SDK interface

 * StudyplusSDK/SPLStudyplus.h
 * StudyplusSDK/SPLStudyplusDelegate.h
 * StudyplusSDK/SPLStudyplusRecord.h
 * StudyplusSDK/SPLStudyplusRecordAmount.h

## Demo app

![demo](https://raw.github.com/studyplus/Studyplus-iOS-SDK/master/docs/demoapp.png)

1. Run `pod try StudyplusSDK` or See Demo directory and open StudyplusSDKDemo/StudyplusSDKDemo.xcodeproj
2. Edit consumer key and consumer secret in Viewcontroller.m
3. Set URL Type with your consumer key
4. Run
5. Do "Auth" and "Post record", and see public timeline at http://studyplus.jp

## License

[MIT License.](http://opensource.org/licenses/mit-license.php)
