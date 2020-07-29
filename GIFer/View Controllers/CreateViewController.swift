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
    
    @IBOutlet weak var photoImageView: PHLivePhotoView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
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
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
                                    self.images.append(result)
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
        return images.count
    }
    
    // MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - PhotoKit
    
    
}
