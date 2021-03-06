//
//  CreateCollectionViewCell.swift
//  GIFer
//
//  Created by Vincent Hoang on 7/28/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class CreateCollectionViewCell: UICollectionViewCell {
    
//    var livePhoto: PHLivePhoto?
    
    func setLivePhoto(livePhoto: PHLivePhoto) {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let livePhotoView: PHLivePhotoView = PHLivePhotoView(frame: self.contentView.bounds)

        livePhotoView.contentMode = .scaleAspectFill
        livePhotoView.livePhoto = livePhoto
        livePhotoView.isUserInteractionEnabled = false

        self.contentView.addSubview(livePhotoView)
    }
}
