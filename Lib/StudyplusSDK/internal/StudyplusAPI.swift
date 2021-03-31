//
//  StudyplusAPI.swift
//  StudyplusSDK
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Studyplus inc.
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

private struct StudyplusURL {
    private static let scheme: String = "https"
    private static let host: String = "external-api.studyplus.jp"
    private static let version: String = "v1"

    static var records: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/\(version)/study_records"

        return components.url!
    }
}

internal struct StudyplusAPI {

    private let accessToken: String
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601

        return encoder
    }

    internal init(accessToken: String) {
        self.accessToken = accessToken
    }

    internal func post(_ record: StudyplusRecord, completion: @escaping (Result<Void, StudyplusPostError>) -> Void) {
        exec(record, completion: { result in
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }

    private func exec(_ record: StudyplusRecord, completion: @escaping (Result<Void, StudyplusPostError>) -> Void) {
        var request = URLRequest(url: StudyplusURL.records)
        request.httpMethod = "POST"
        request.addValue("application/json; charaset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("OAuth \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? encoder.encode(record)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                if let error = error as NSError?,
                   error.domain == NSURLErrorDomain,
                   error.code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(.offline))
                    return
                }

                completion(.failure(.badRequest))
                return
            }

            guard data != nil, let response = response as? HTTPURLResponse else {
                completion(.failure(.badRequest))
                return
            }

            guard (200...204).contains(response.statusCode) else {
                let studyplusError = StudyplusPostError.responseError(response.statusCode)
                completion(.failure(studyplusError))
                return
            }

            completion(.success(Void()))
        }

        task.resume()
    }
}
