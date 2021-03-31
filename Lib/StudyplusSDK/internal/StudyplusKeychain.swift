//
//  StudyplusKeychain.swift
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

import Foundation

internal struct StudyplusKeychain {
    private static let accessTokenStoreKey: String = "accessToken"

    static internal func accessToken(serviceName: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecAttrAccount: accessTokenStoreKey
        ] as CFDictionary

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    static internal func set(serviceName: String,
                             accessToken: Data,
                             completion: (Result<Void, StudyplusLoginError>) -> Void) {
        // delete previous keys
        deleteAll(serviceName: serviceName)

        // add new token and username
        let statusAccessToken = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny,
            kSecAttrAccount: accessTokenStoreKey,
            kSecValueData: accessToken
        ] as CFDictionary, nil)

        if statusAccessToken != noErr {
            completion(.failure(.keychainError))
            return
        }

        completion(.success(Void()))
    }

    static func deleteAll(serviceName: String) {
        SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrSynchronizable: kSecAttrSynchronizableAny
        ] as CFDictionary)
    }
}
