//
//  VideoCaptureAuthorizationHelper.swift
//  videoCapture
//
//  Created by kostis stefanou on 4/13/19.
//  Copyright © 2019 silonk. All rights reserved.
//

import Foundation
import AVFoundation

class VideoCaptureAuthorizationHelper {

    static func grantAll(completion: @escaping(Bool) -> Void) {
        grantVideo { (videoGranted) in
            grantAudio(completion: { (audioGranted) in
                completion(videoGranted && audioGranted)
            })
        }
    }
    
    static private func grantVideo(completion: @escaping(Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
            
        case .denied, .restricted: completion(false)
        }
    }
    
    static private func grantAudio(completion: @escaping(Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                completion(granted)
            }
            
        case .denied, .restricted: completion(false)
        }
    }
}
