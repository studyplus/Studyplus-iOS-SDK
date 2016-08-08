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

#import "SPLStudyplusDelegate.h"
#import "SPLStudyplusRecord.h"
#import "SPLStudyplusRecordAmount.h"
#import "SPLStopwatch.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The class for using Studyplus.<br>
 For example, you can authenticate in Studyplus account, de-authentication, and post study record.
 
 Studyplusの各機能を使うためのクラスです。<br>
 Studyplusアカウントとの連携、連携解除、勉強記録の投稿ができます。
 */
@interface SPLStudyplus : NSObject

/**
 The version of the StudyplusAPI. Default value is 1.<br>
 StudyplusAPI のバージョンを指定します。デフォルトは 1 です。
 
 https://external-api.studyplus.jp/v{apiVersion}/endpoint_name
 */
@property (nonatomic) NSInteger apiVersion;

/**
 Debug mode switch.<br>
 When set to YES, then call back to the delegate without posting the actual processing.<br>
 Default value is NO.
 
 StudyplusAPI のバージョンを指定します。<br>
 debug=YESの場合、勉強記録の投稿時に実際の通信は行わずdelegateのコールバックメソッドを呼び出して処理を終了します。
 */
@property (nonatomic) BOOL debug;

/**
 StudyplusAPI用のConsumer Keyです。<br>
 Consumer Key for Studyplus API.
 */
@property (nonatomic, copy, readonly) NSString *consumerKey;

/**
 StudyplusAPI用のConsumer Secretです。<br>
 Consumer Secret for Studyplus API.
 */
@property (nonatomic, copy, readonly) NSString *consumerSecret;

/**
 @see SPLStudyplusDelegate protocol
 */
@property (nonatomic, weak, nullable) id<SPLStudyplusDelegate> delegate;

/**
 When set to YES, if Studyplus is not installed, AppStore application starts when auth/login methods are called. Default value is YES.<br>
 YESに設定すると、auth、loginメソッドを呼び出したとき、StudyplusアプリがインストールされていなければAppStoreを起動します。デフォルトは YES です。
 */
@property (nonatomic) BOOL openAppStoreIfNotInstalled;

/**
 Username of Studyplus account. It is set when the auth or login is successful. Default value is nil.<br>
 Studyplusアカウントのユーザ名です。login または authが成功したとき設定されます。設定されるまではnilです。
 */
@property (nonatomic, copy, readonly, nullable) NSString *username;

/**
 Access token of Studyplus API. It is set when the auth or login is successful. Default value is nil.<br>
 StudyplusAPIのアクセストークンです。login または authが成功したとき設定されます。設定されるまではnilです。
 */
@property (nonatomic, copy, readonly, nullable) NSString *accessToken;

/**
 @see SPLStopwatch class
 */
@property (nonatomic, readonly, nullable) SPLStopwatch *stopwatch;

/**
 The convenience constructor of SPLStudyplus class.
 
 SPLStudyplusクラスのオブジェクトを生成して返します。
 
 @param consumerKey Specify a Consumer Key for StudyplusAPI.<br>
 StudyplusAPI用のコンシューマキーを指定してください。
 
 @param consumerSecret  Specify a Consumer Secret for StudyplusAPI.<br>
 StudyplusAPI用のコンシューマシークレットを指定してください。
 
 @return SPLStudyplus object. <br>
 SPLStudyplusオブジェクト。
 */
+ (SPLStudyplus*)studyplusWithConsumerKey:(NSString*)consumerKey
                        andConsumerSecret:(NSString*)consumerSecret;

/**
 Opens the auth screen by invoking the Studyplus application.
 
 Studyplusアプリを起動して連携許可画面を開きます。
 
 If Studyplus app is not installed and openAppStoreIfNotInstalled is YES, then open the Studyplus page in AppStore. <br>
 If openAppStoreIfNotInstalled is NO, do nothing.<br>
 After the process has returned from Studyplus application, delegate method will be called back.
 
 Studyplusアプリがインストールされていない場合、 openAppStoreIfNotInstalled がYESであれば、AppStoreを起動してStudyplusページを開きます。<br>
 openAppStoreIfNotInstalled がNOであれば何もしません。<br>
 Studyplusアプリから操作が戻ってきた後、delegateオブジェクトのコールバックメソッドを呼び出します。
 
 @return It returns YES when you started Studyplus application. If Studyplus application is not installed, it returns NO.<br>
 Studyplusアプリが起動した時点でYESを返します。Studyplusアプリがインストールされていない場合、NOを返します。
 */
- (BOOL)auth;

/**
 Opens the login screen by invoking the Studyplus application.
 
 Studyplusアプリを起動してStudyplusログイン画面を開きます。
 
 If Studyplus app is not installed and openAppStoreIfNotInstalled is YES, then open the Studyplus page in AppStore. <br>
 If openAppStoreIfNotInstalled is NO, do nothing.<br>
 After the process has returned from Studyplus application, delegate method will be called back.
 
 Studyplusアプリがインストールされていない場合、 openAppStoreIfNotInstalled がYESであれば、AppStoreを起動してStudyplusページを開きます。<br>
 openAppStoreIfNotInstalled がNOであれば何もしません。<br>
 Studyplusアプリから操作が戻ってきた後、delegateオブジェクトのコールバックメソッドを呼び出します。
 
 @return It returns YES when you started Studyplus application. If Studyplus application is not installed, it returns NO.<br>
 Studyplusアプリが起動した時点でYESを返します。Studyplusアプリがインストールされていない場合、NOを返します。
 */
- (BOOL)login;

/**
 Posts new study record to Studyplus.<br>
 Studyplusに勉強記録を新規投稿します。
 
 @param studyRecord @see SPLStudyplusRecord
 */
- (void)postStudyRecord:(SPLStudyplusRecord*)studyRecord;

/**
 Cancels the cooperation with Studyplus application.<br>
 Studyplusアプリとの連携を解除します。
 */
- (void)logout;

/**
 Returns to whether or not it is in conjunction with Studyplus application.<br>
 Studyplusアプリと連携されているか否かを返します。
 */
- (BOOL)isConnected;

/**
 It is responsible for processing custom URL scheme when it came back from the authorization / login screen of Stuudyplus app.<br>
 After handling openURL method in AppDelegate, pass the url parameter to this method.<br>
 If the URL is passed by Studyplus application, calls the callback method of the delegate object.
 
 Studyplusアプリの認可・ログイン画面から戻ってきた時のカスタムURLスキーム処理を担当します。<br>
 AppDelegateでopenURLをハンドリングしてから、このメソッドにurlを渡して委譲してください。<br>
 Studyplusアプリ関連のURLであれば、delegateオブジェクトのコールバックメソッドを呼び出します。
 
 @param url The parameter of AppDelegate#openURL method.<br>
 AppDelegate#openURLメソッドで受け取ったurlパラメータをそのまま渡して下さい。
 
 @return If the url is supported by StudyplusSDK, returns YES. The valid URL has a "studyplus-{consumerKey}://" scheme, and right pathComponents and  host.<br>
 渡されたurlがStudyplusSDKで対応すべきURL（スキームが"studyplus-{consumerKey}"であり、host/pathComponentsが想定内であるもの）であればYES、それ以外はNOを返します。
 */
- (BOOL)openURL:(NSURL*)url;

NS_ASSUME_NONNULL_END

@end
