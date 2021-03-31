//
//  Studyplus.swift
//  StudyplusSDK
//
//  The MIT License (MIT)
//
//  Copyright (c) 2021 Studyplus inc.
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

import UIKit

final public class Studyplus {

    private init() {
        guard let data = Bundle.main.infoDictionary?["StudyplusSDK"] as? [String: String],
              let consumerKey = data["consumerKey"],
              let consumerSecret = data["consumerSecret"] else {
            assert(false, "StudyplusSDK: *** Please set consumerKey and consumerSecret in your Info.plist. ***")

            self.consumerKey = ""
            self.consumerSecret = ""
            return
        }

        if consumerKey == "set_your_consumerKey" || consumerSecret == "set_your_consumerSecret" {
            assert(false, "StudyplusSDK: *** Please set consumerKey and consumerSecret in Info.plist. ***")

            self.consumerKey = ""
            self.consumerSecret = ""
            return
        }

        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }

    public static let shared: Studyplus = Studyplus()

    public private(set) var consumerKey: String
    public private(set) var consumerSecret: String
    public weak var delegate: StudyplusLoginDelegate?

    private var serviceName: String {
        return "Studyplus_iOS_SDK_\(consumerKey)"
    }

    /// Studyplusアプリを経由して、Studyplusアカウントにログインします。
    /// Studyplusアプリがインストールされていない場合、AppStoreへ遷移します。
    /// ログイン処理の完了後にStudyplusLoginDelegateを呼び出します。
    public func login() {
        let customScheme = URL(string: "studyplus://")!
        guard UIApplication.shared.canOpenURL(customScheme) else {
            if let store = URL(string: "https://apps.apple.com/jp/app/id505410049?mt=8") {
                UIApplication.shared.open(store)
            }

            return
        }

        if let url = URL(string: "\(customScheme)external_app/auth/\(consumerKey)/\(consumerSecret)") {
            UIApplication.shared.open(url)
        }
    }

    /// Studyplusアプリとの連携を解除します。
    public func logout() {
        StudyplusKeychain.deleteAll(serviceName: serviceName)
    }

    /// Studyplusアプリと連携されているか否かを返します。
    public func isConnected() -> Bool {
        return StudyplusKeychain.accessToken(serviceName: serviceName) != nil
    }

    /// Studyplusに学習記録を投稿
    ///
    /// - Parameters:
    ///   - record: 学習記録
    ///   - completion: 投稿完了後のコールバック
    public func post(_ record: StudyplusRecord, completion: @escaping (Result<Void, StudyplusPostError>) -> Void) {
        guard let accessToken = StudyplusKeychain.accessToken(serviceName: serviceName) else {
            completion(.failure(.loginRequired))
            return
        }

        guard record.isValidDuration else {
            completion(.failure(.invalidDuration))
            return
        }

        StudyplusAPI(accessToken: accessToken).post(record, completion: { result in
            switch result {
            case .failure(let error):
                switch error {
                case .loginRequired:
                    // clear invalid access token
                    StudyplusKeychain.deleteAll(serviceName: self.serviceName)
                default:
                    break
                }
            case .success: break
            }

            completion(result)
        })
    }

    /// Studyplusアプリの認可・ログイン画面から戻ってきた時のカスタムURLスキーム処理を担当します。
    /// AppDelegateでopenURLをハンドリングしてから、このメソッドにurlを渡して委譲してください。
    /// Studyplusアプリ関連のURLであれば、delegateオブジェクトのコールバックメソッドを呼び出します。
    ///
    /// - Parameter url:
    ///     AppDelegate#openURLメソッドで受け取ったurlパラメータをそのまま渡して下さい。
    /// - Returns:
    ///     渡されたurlがStudyplusSDKで対応すべきURLであれば true、それ以外は false を返します。
    ///     __[studyplus-{consumerKey}]__と正しいpathComponentsを持つことを確認してください。
    public func handle(_ url: URL) -> Bool {
        guard isAcceptableURL(url: url) else {
            delegate?.studyplusLoginFail(error: .unknownUrl(url))
            return false
        }

        switch url.pathComponents[1] {
        case "success":
            let accessToken: Data = url
                .pathComponents[2]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .data(using: .utf8, allowLossyConversion: false)!

            StudyplusKeychain.set(serviceName: serviceName, accessToken: accessToken) { result in
                switch result {
                case .failure(let error):
                    self.delegate?.studyplusLoginFail(error: error)
                case .success:
                    self.delegate?.studyplusLoginSuccess()
                }
            }
        case "fail":
            delegate?.studyplusLoginFail(error: .applicationError)
        case "cancel":
            delegate?.studyplusLoginFail(error: .cancel)
        default:
            return false
        }

        return true
    }

    /// StudyplusAPI用のConsumer Key と Secret を変更します。
    /// このメソッドを呼ぶとStudyplusにログイン、ログアウト、勉強記録を投稿するときなどに、別の Consumer Key と Secret に切り替えることができます。
    /// 複数のアプリケーションがStudyplusと連携している場合は、このメソッドを呼ぶ必要があります。
    /// 連携されたアプリケーションが1つしかない場合は、このメソッドを呼ぶ必要はありません。
    /// 複数のアプリケーションがStudyplusと連携している場合は、カスタムURLスキーマの設定を忘れないように注意してください。
    ///
    /// - Parameter
    ///   - consumerKey: consumer key
    ///   - consumerSecret: consumer secret
    public func change(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }

    private func isAcceptableURL(url: URL) -> Bool {
        guard let host = url.host else { return false }
        guard host == "auth-result" || host == "login-result" else { return false }

        guard let scheme = url.scheme else { return false }
        guard scheme == "studyplus-\(consumerKey)" else { return false }

        if url.pathComponents.isEmpty {
            return false
        }

        return true
    }
}
