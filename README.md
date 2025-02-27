# StudyplusSDK

## Requirements

 * iOS 11.0以上
 * Swift 5.1以上

## Install

### [Swift Package Manager](https://github.com/apple/swift-package-manager/)

<https://github.com/studyplus/Studyplus-iOS-SDK>を追加してください。

### [CocoaPods](https://cocoapods.org/)

Podfileに `StudyplusSDK` を追加してください。

```ruby
use_frameworks!
pod 'StudyplusSDK'
```

## Usage

<https://form.run/@studyplusapi>よりStudypluAPIの申請を最初に行ってください。
審査後、`consumer key`と`consumer secret`の2つをメールにて送付いたします。

### custom URL schemeの設定

__studyplus-*{consumer key}*__ を URL Typesに追加してください。

![xcode](https://github.com/studyplus/Studyplus-iOS-SDK/blob/main/docs/set_url_scheme.png)

### `consumer key`と`consumer secret`の追加

Info.plistに`consumer key`と`consumer secret`を追加してください。

```txt
<key>StudyplusSDK</key>
<dict>
  <key>consumerKey</key>
  <string>set_your_consumerKey</string>
  <key>consumerSecret</key>
  <string>set_your_consumerSecret</string>
</dict>
```

### LSApplicationQueriesSchemes

Studyplusアプリがインストールされているかチェックできるようにするため、Info.plistの`LSApplicationQueriesSchemes`に`studyplus`を追加してください。

```txt
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>studyplus</string>
</array>
```

### Initialize

```swift
import StudyplusSDK

class ViewController: UIViewController, StudyplusLoginDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        Studyplus.shared.delegate = self
    }
}
```

### Login

```swift
import StudyplusSDK

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return Studyplus.shared.handle(url)
    }
}
```

```swift
import StudyplusSDK

class ViewController: UIViewController, StudyplusLoginDelegate {
    func login() {
        Studyplus.shared.login()
    }

    func studyplusLoginSuccess() {
        // on success
    }

    func studyplusLoginFail(error: StudyplusLoginError) {
        // on failed
    }
}
```

### 学習記録の投稿

```swift
let record = StudyplusRecord(duration: Int(duration),
                                amount: 10,
                                comment: "Today, I studied like anything.",
                                recordDatetime: Date())

Studyplus.shared.post(record, completion: { result in
    switch result {
    case .failure(let error):
        // handle error
    case .success:
        // finish post
    }
})
```

## Demo app

![demo](https://github.com/studyplus/Studyplus-iOS-SDK/blob/main/docs/demoapp.jpg)

- Set __studyplus-*{your consumer key}*__ to URL Types in Demo.
- Set __consumerKey__ and __consumerSecret__ in Info.plist of Demo.
- Select Demo Scheme and Run.

## License

```txt
The MIT License (MIT)

Copyright (c) 2021 Studyplus inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
