//
//  ControlContainerViewController.swift
//  videoCapture
//
//  Created by kostis stefanou on 4/13/19.
//  Copyright © 2019 silonk. All rights reserved.
//

import UIKit

protocol ControlContainerViewControllerDelegate: class {
    func didPreviewPressed()
    func didSendPressed()
}

class ControlContainerViewController: UIViewController {

    weak var delegate: ControlContainerViewControllerDelegate?
    
    //Outlets
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUp()
    }
    
    private func setUp() {
        previewButton.layer.shadowColor = UIColor.darkGray.cgColor
        previewButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        previewButton.layer.shadowOpacity = 0.4
        previewButton.layer.cornerRadius = previewButton.bounds.width / 2
        
        sendButton.layer.cornerRadius = sendButton.bounds.width / 2
        sendButton.layer.shadowColor = UIColor.darkGray.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        sendButton.layer.shadowOpacity = 0.4
        
        hideControlls()
    }
    
    func showControlls() {
        UIView.animate(withDuration: 0.4) {
            self.view.alpha = 1
            self.previewButton.transform = .identity
            self.sendButton.transform = .identity
        }
    }
    
    func hideControlls() {
        UIView.animate(withDuration: 0.4) {
            self.previewButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.sendButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 0
        }
    }
    
    //Outlet Actions
    @IBAction private func previewButtonPressed(_ sender: UIButton) {
        delegate?.didPreviewPressed()
    }
    
    @IBAction private func sendButtonPressed(_ sender: UIButton) {
        delegate?.didSendPressed()
    }
}
