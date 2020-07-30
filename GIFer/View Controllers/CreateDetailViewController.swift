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

class CreateDetailViewController: UIViewController {

    var livePhoto: PHLivePhoto? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var photoImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenWidth = UIScreen.main.bounds.width
        
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: ((screenWidth * 3.0)/4.0))
        let livePhotoView = PHLivePhotoView.init(frame: rect)
        livePhotoView.livePhoto = livePhoto
        livePhotoView.contentMode = .scaleAspectFill

        
        livePhotoView.startPlayback(with: .full)
        
        photoImageView = UIView(frame: rect)
        photoImageView.contentMode = .scaleToFill
        photoImageView.addSubview(livePhotoView)
        
        view.addSubview(photoImageView)
    }
    
    
    private func setUpView() {
        if let _ = livePhoto {
            viewWillAppear(true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
