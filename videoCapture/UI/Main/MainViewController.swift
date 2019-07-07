//
//  TalentInterviewViewController.swift
//  videoCapture
//
//  Created by kostis stefanou on 4/13/19.
//  Copyright © 2019 silonk. All rights reserved.
//

import UIKit

class TalentInterviewViewController: UIViewController {

    private var captureSession: VideoCaptureSession? = nil
    private var captureHandler: VideoCaptureHandler? = nil
    
    private weak var timer: Timer? = nil
    private let totalTime: Int = 60
    
    //Outlets
    @IBOutlet private weak var previewView: VideoCapturePreviewView!
    @IBOutlet private weak var recordingButton: UIButton!
    
    private var controlContainerViewController: ControlContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        VideoCaptureAuthorizationHelper.grantAll { (granted) in
            guard granted else { print("authorization for video capture denied") ; return }
            OperationQueue.main.addOperation { self.setupCaptureSession() }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        controlContainerViewController = (segue.destination as! ControlContainerViewController)
        controlContainerViewController.delegate = self
    }
    
    private func setUp() {
        recordingButton.layer.cornerRadius = recordingButton.frame.height/2
    }
    
    private func setupCaptureSession() {
        captureSession = VideoCaptureSession()
        previewView.videoPreviewLayer.session = captureSession
        
        captureHandler = VideoCaptureHandler()
        captureHandler?.delegate = self
        
        captureSession?.startRunning()
    }
    
    private func resetCaptureSession() {
        previewView.show()
        captureSession?.startRunning()
        recordingButton.isEnabled = true
        recordingButton.setTitle("\(totalTime)", for: .normal)
    }
    
    private func playPreview(_ fileURL: URL) {
        guard let playerViewController = self.captureHandler?.getPlayerViewController(fileURL) else { return }
        present(playerViewController, animated: true, completion: nil)
    }
    
    //Outlet Actions & Selectors
    @objc private func timerUpdated() {
        guard var timeLeft = Int(recordingButton.currentTitle ?? "") else { return }
        
        if timeLeft == 0 {
            guard let videoOutput = captureSession?.videoOutput else { return }
            videoOutput.stopRecording()
        } else {
            timeLeft -= 1
            recordingButton.setTitle("\(timeLeft)", for: .normal)
        }
    }
    
    @IBAction private func recordingButtonPressed(_ sender: UIButton) {
        controlContainerViewController.hideControlls()
        previewView.show()
        if !(captureSession?.isRunning ?? false) { captureSession?.startRunning() }
        guard let videoOutput = captureSession?.videoOutput, let captureHandler = captureHandler, let url = captureHandler.getOutputURL() else { return }
        videoOutput.startRecording(to: url, recordingDelegate: captureHandler)
    }
}

// MARK: Video Capture Handler Delegate
extension TalentInterviewViewController: VideoCaptureHandlerDelegate {    
    func errorOccured(_ error: String) {
        captureSession?.videoOutput?.stopRecording()
    }
    
    func didStartRecording() {
        recordingButton.isEnabled = false
        recordingButton.setTitle("\(totalTime)", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdated), userInfo: nil, repeats: true)
    }
    
    func didFinishRecording(outputData: Data?, fileURL: URL, error: Error?) {
        recordingButton.isEnabled = true
        recordingButton.setTitle("REC", for: .normal)
        captureSession?.videoOutputURL = fileURL
        timer?.invalidate()
        captureSession?.stopRunning()
        previewView.hide()
        controlContainerViewController.showControlls()
    }
}

extension TalentInterviewViewController: ControlContainerViewControllerDelegate {
    func didPreviewPressed() {
        guard let fileURL = captureSession?.videoOutputURL else { return }
        playPreview(fileURL)
    }
    
    func didNewPressed() {
        controlContainerViewController.hideControlls()
        resetCaptureSession()
    }
    
    func didSendPressed() { }
}
