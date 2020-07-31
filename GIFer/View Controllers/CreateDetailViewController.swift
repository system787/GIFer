//
//  CreateDetailViewController.swift
//  GIFer
//
//  Created by Vincent Hoang on 7/29/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class CreateDetailViewController: UIViewController, LivePhotoConverterDelegate {
    
    let converter = LivePhotoConverter.shared
    
    var livePhoto: PHLivePhoto? {
        didSet {
            setUpView()
        }
    }
    
    var asset: PHAsset?
    
    // MARK: - LivePhotoConverterDelegate
    func videoToGIFComplete(_ url: URL?) {
        let alert = generateAlert(alertTitle: "Complete", alertMessage: "GIF creation complete.", actionTitle: "Done")
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: { () in
                NSLog("Done converting")
            })
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var photoImageView: UIView!
    @IBOutlet var createButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func createButtonPressed(_ sender: UIButton) {
        guard let livePhoto = livePhoto else {
            let alert = generateAlert(alertTitle: "Error", alertMessage: "LivePhoto is not properly loaded", actionTitle: "Dismiss")
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        convertLivePhoto(livePhoto: livePhoto)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        converter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenWidth = UIScreen.main.bounds.width
        
        let rect = CGRect(x: 0, y: 10.0, width: screenWidth, height: ((screenWidth * 3.0)/4.0))
        let livePhotoView = PHLivePhotoView.init(frame: rect)
        livePhotoView.livePhoto = livePhoto
        livePhotoView.contentMode = .scaleAspectFit
        
        livePhotoView.startPlayback(with: .full)
        
        photoImageView = UIView(frame: rect)
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.addSubview(livePhotoView)
        
        view.addSubview(photoImageView)
    }
    
    
    // MARK: - LivePhotoConverter
    private func convertLivePhoto(livePhoto: PHLivePhoto) {
        LivePhotoConverter.getContents(from: livePhoto) { livePhotoContents in
            guard let contents = livePhotoContents else {
                let alert = self.generateAlert(alertTitle: "Error", alertMessage: "Unable to get contents of live photo", actionTitle: "Dismiss")
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.converter.convertVideoToGIF(videoURL: contents.video)
        }
    }
    
    // MARK: - Utility
    private func setUpView() {
        if let _ = livePhoto {
            viewWillAppear(true)
            
            createButton.isEnabled = true
        }
    }
    
    private func generateAlert(alertTitle: String, alertMessage: String, actionTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
}
