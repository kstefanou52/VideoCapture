//
//  VideoCaptureHandler.swift
//  videoCapture
//
//  Created by kostis stefanou on 4/13/19.
//  Copyright © 2019 silonk. All rights reserved.
//

import Foundation
import AVKit

protocol VideoCaptureHandlerDelegate: class {
    func errorOccured(_ error: String)
    func didStartRecording()
    func didFinishRecording(outputData: Data?, fileURL: URL, error: Error?)
}

class VideoCaptureHandler: NSObject {
    
    weak var delegate: VideoCaptureHandlerDelegate?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted), name: .AVCaptureSessionWasInterrupted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionEnded), name: .AVCaptureSessionInterruptionEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionRuntimeError), name: .AVCaptureSessionRuntimeError, object: nil)
    }
    
    func getOutputURL() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let filename = NSUUID().uuidString + ".mov"
        let filePath = url.appendingPathComponent(filename)
        
        return filePath
    }
    
    func getPlayerViewController(_ videoURL: URL) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let viewController = AVPlayerViewController()
        viewController.player = player
        
        return viewController
    }
    
    // Notification Selectors
    @objc private func sessionWasInterrupted(_ sender: Notification) {
        let reason = sender.object as? AVCaptureSession.InterruptionReason
        delegate?.errorOccured(reason.debugDescription)
    }
    
    @objc private func sessionInterruptionEnded(_ sender: Notification) { }
    
    @objc private func sessionRuntimeError(_ sender: Notification) {
        let error = sender.object as? NSError
        delegate?.errorOccured(error.debugDescription)
    }
}

extension VideoCaptureHandler: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        delegate?.didStartRecording()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let data = try? Data(contentsOf: outputFileURL)
        delegate?.didFinishRecording(outputData: data, fileURL: outputFileURL, error: error)
    }
}
