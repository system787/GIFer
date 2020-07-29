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
    
//    var livePhoto: PHLivePhoto? {
//        didSet {
//            setLivePhotoView()
//        }
//    }
//
//    private func setLivePhotoView() {
//
//        let livePhotoView: PHLivePhotoView = PHLivePhotoView(frame: self.contentView.bounds)
//        livePhotoView.contentMode = .scaleAspectFill
//        livePhotoView.livePhoto = livePhoto
//
//        contentView.addSubview(livePhotoView)
//    }
    
    func setLivePhoto(livePhoto: PHLivePhoto) {
        let livePhotoView: PHLivePhotoView = PHLivePhotoView(frame: self.contentView.bounds)

        livePhotoView.contentMode = .scaleAspectFill
        livePhotoView.livePhoto = livePhoto
        
        self.contentView.addSubview(livePhotoView)
        self.contentView.sendSubviewToBack(livePhotoView)
    }
}
