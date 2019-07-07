//
//  VideoCaptureSession.swift
//  videoCapture
//
//  Created by kostis stefanou on 4/13/19.
//  Copyright © 2019 silonk. All rights reserved.
//

import Foundation
import AVFoundation

class VideoCaptureSession: AVCaptureSession {
    
    var videoOutput: AVCaptureMovieFileOutput? = nil
    var videoOutputURL: URL? = nil
    
    override init() {
        super.init()
        configure()
    }

    private func configure() {
        beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { print("unable to create capture device") ; return }
        guard let audioDevice = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified) else { print("unable to create capture device") ; return }
        
        //Input - video, audio
        do {
            let videoDeviceInput = try AVCaptureDeviceInput.init(device: videoDevice)
            let audioDeviceInput = try AVCaptureDeviceInput.init(device: audioDevice)
            guard canAddInput(videoDeviceInput), canAddInput(audioDeviceInput) else { print("unable to add this device to capture session") ; return }
            
            addInput(videoDeviceInput)
            addInput(audioDeviceInput)
        } catch {
            print(error)
        }
        
        //Output - video
        videoOutput = AVCaptureMovieFileOutput()
        guard canAddOutput(videoOutput!) else { print("unable to add video output in this capture sessions") ; return }
        
        sessionPreset = .high // Change this value in order to adjust output quality
        addOutput(videoOutput!)

        commitConfiguration()
    }
}
