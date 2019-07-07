//
//  VideoCapturePreviewView.swift
//  videoCapture
//
//  Created by kostis stefanou on 4/13/19.
//  Copyright © 2019 silonk. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCapturePreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    // Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    func hide() {
        UIView.animate(withDuration: 0.4) {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.4) {
            self.transform = .identity
            self.alpha = 1
        }
    }
}
