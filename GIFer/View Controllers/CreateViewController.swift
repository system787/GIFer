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
import MobileCoreServices

class CreateViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var photoImageView: UIView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var livePhoto: PHLivePhoto?
    var imagePicker = UIImagePickerController()
    
    var images: [PHLivePhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        fetchLivePhotos()
    }
    
    // MARK: - Photo CollectionView
    private func fetchLivePhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchOptions.predicate = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
        
        let fetchResults = PHAsset.fetchAssets(with: fetchOptions)
        fetchResults.enumerateObjects({ asset, _, _ in
            self.getAssetThumbnail(asset)
        })
    }
    
    private func getAssetThumbnail(_ asset: PHAsset){
        let options = PHLivePhotoRequestOptions()
        let manager = PHImageManager.default()
        
        manager.requestLivePhoto(for: asset,
                             targetSize: CGSize(width: 80.0, height: 80.0),
                             contentMode: .aspectFit,
                             options: options,
                             resultHandler: { (result, info) -> Void in
                                
                                if let result = result {
                                    DispatchQueue.main.async {
                                        self.images.append(result)
                                        self.collectionView.reloadData()
                                    }
                                }
        })
        
    }
    
    // MARK: - Photo CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCell", for: indexPath) as! CreateCollectionViewCell
        
        let selectedImage = images[indexPath.item]
        
        cell.setLivePhoto(livePhoto: selectedImage)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count > 20 ? 20 : images.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let image = images[indexPath.item]
        
        for view in photoImageView.subviews {
            view.removeFromSuperview()
        }
        
        let livePhotoView = PHLivePhotoView.init(frame: photoImageView.bounds)
        livePhotoView.livePhoto = image
        
        livePhotoView.contentMode = .scaleAspectFit
        livePhotoView.isMuted = true
        
        photoImageView.addSubview(livePhotoView)
    }
    
    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func collectionViewCellTapped(_ sender: UICollectionView) {
//        print("Tap")
//        guard let indexPath = sender.indexPathsForSelectedItems else {
//            print("tap failed")
//            return
//        }
//        
//        print("tap success")
//        
//        if let index = indexPath.first {
//            let image = images[index.item]
//            
//            photoImageView.livePhoto = image
//        }
//    }

    // MARK: - PhotoKit
    
    
}
