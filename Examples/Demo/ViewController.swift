//
//  ViewController.swift
//  Demo
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
import StudyplusSDK

class ViewController: UIViewController {

    @IBOutlet weak var isConnectedLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    var duration: TimeInterval = TimeInterval(60)

    override func viewDidLoad() {
        super.viewDidLoad()
        Studyplus.shared.delegate = self
    }

    @IBAction func loginButton(_ sender: UIButton) {
        Studyplus.shared.login()
    }

    @IBAction func logoutButton(_ sender: UIButton) {
        Studyplus.shared.logout()
        updateIsConnected()
        resultLabel.text = "Logout"
    }

    @IBAction func connectedButton(_ sender: UIButton) {
        updateIsConnected()
        resultLabel.text = ""
    }

    @IBAction func postStudyRecordButton(_ sender: UIButton) {

        self.resultLabel.text = ""

        let record = StudyplusRecord(duration: Int(duration),
                                     amount: 10,
                                     comment: "Today, I studied like anything.",
                                     recordDatetime: Date())

        Studyplus.shared.post(record, completion: { result in
            switch result {
            case .failure(let error):
                self.resultLabel.text = "Error Code: \(error)"
            case .success:
                self.resultLabel.text = "Success to post your studyRecord to Studyplus App"
            }
        })
    }

    @IBAction func studyRecordDurationPicker(_ sender: UIDatePicker) {
        duration = sender.countDownDuration
    }

    private func updateIsConnected() {
        isConnectedLabel.text = Studyplus.shared.isConnected() ? "True" : "False"
    }
}

extension ViewController: StudyplusLoginDelegate {
    func studyplusLoginSuccess() {
        print("-- Called studyplusDidSuccessToLogin --")
        resultLabel.text = "Login succeeded"
        updateIsConnected()
    }

    func studyplusLoginFail(error: StudyplusLoginError) {
        print("-- Called studyplusDidFailToLogin --")
        resultLabel.text = "Error Code: \(error)"
        updateIsConnected()
    }
}
