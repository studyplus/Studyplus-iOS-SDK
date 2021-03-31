//
//  StudyplusRecord.swift
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

public struct StudyplusRecord {
    private var duration: Int
    private var amount: Int?
    private var startPosition: Int?
    private var endPosition: Int?
    private var comment: String?
    private var recordDatetime: Date

    /// 勉強記録
    ///
    /// - Parameters:
    ///   - duration: 学習時間(s), MAX 86400 (24h)
    ///   - comment: 学習に関するコメント
    ///   - recordDatetime: 学習を終えた日時
    public init(duration: Int,
                comment: String?,
                recordDatetime: Date = Date()) {
        self.init(duration: duration,
                  amount: nil,
                  startPosition: nil,
                  endPosition: nil,
                  comment: comment,
                  recordDatetime: recordDatetime)
    }

    /// 勉強記録
    ///
    /// - Parameters:
    ///   - duration: 学習時間(s), MAX 86400 (24h)
    ///   - amount: 学習量(単位はAPI申請時に指定したもの)
    ///   - comment: 学習に関するコメント
    ///   - recordDatetime: 学習を終えた日時
    public init(duration: Int,
                amount: Int,
                comment: String?,
                recordDatetime: Date = Date()) {
        self.init(duration: duration,
                  amount: amount,
                  startPosition: nil,
                  endPosition: nil,
                  comment: comment,
                  recordDatetime: recordDatetime)
    }

    /// 勉強記録
    ///
    /// - Parameters:
    ///   - duration: 学習時間(s), MAX 86400 (24h)
    ///   - from: 学習範囲の始点
    ///   - to: 学習範囲の終点
    ///   - comment: 学習に関するコメント
    ///   - recordDatetime: 学習を終えた日時
    public init(duration: Int,
                startPosition: Int,
                endPosition: Int,
                comment: String?,
                recordDatetime: Date = Date()) {
        guard startPosition <= endPosition else {
            assert(true, "endPosition must be greater than startPosition")
            self.init(duration: duration,
                      comment: comment,
                      recordDatetime: recordDatetime)
            return
        }

        self.init(duration: duration,
                  amount: nil,
                  startPosition: startPosition,
                  endPosition: endPosition,
                  comment: comment,
                  recordDatetime: recordDatetime)
    }

    private init(duration: Int, amount: Int?,
                 startPosition: Int?,
                 endPosition: Int?,
                 comment: String?,
                 recordDatetime: Date) {
        self.duration = duration
        self.amount = amount
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.comment = comment
        self.recordDatetime = recordDatetime
    }
}

extension StudyplusRecord {
    var isValidDuration: Bool {
        return 0...(24 * 60 * 60) ~= Int(duration)
    }
}

extension StudyplusRecord: Encodable {}
