//
//  CreateViewController.swift
//  GIFer
//
//  Created by Vincent Hoang on 7/27/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class CreateViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: PHLivePhotoView!
    
    var livePhoto: PHLivePhoto?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - PhotoKit
    private func initLivePhotoView() {
        
    }
    
    private func updateLivePhotoView() {
        
    }
    
}
