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
    @IBOutlet weak var usePhotoButton: UIBarButtonItem!
    
    var livePhoto: PHLivePhoto?
    var imagePicker = UIImagePickerController()
    
    var images: [PHLivePhoto] = []
    var fetchResults: PHFetchResult<PHAsset> = PHFetchResult()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        fetchLivePhotos()
    }
    
    // MARK: - Photo CollectionView
    private func fetchLivePhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaSubtype = %d", PHAssetMediaSubtype.photoLive.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let library = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLivePhotos, options: nil).firstObject
        
        fetchResults = PHAsset.fetchAssets(in: library!, options: fetchOptions)
    }
    
    private func getAssetThumbnail(_ asset: PHAsset, for cell: CreateCollectionViewCell) {
        let options = PHLivePhotoRequestOptions()
        let manager = PHImageManager.default()
        
        manager.requestLivePhoto(for: asset,
                             targetSize: CGSize(width: 80.0, height: 80.0),
                             contentMode: .aspectFit,
                             options: options,
                             resultHandler: { result, _ -> Void in
                                
                                if let result = result {
                                    cell.setLivePhoto(livePhoto: result)
                                }
        })
        
    }
    
    private func getAssetLarge(_ asset: PHAsset) {
        let options = PHLivePhotoRequestOptions()
        let manager = PHImageManager.default()
        
        manager.requestLivePhoto(for: asset,
                                 targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                 contentMode: .aspectFit,
                                 options: options,
                                 resultHandler: { result, _ -> Void in
                                    if let result = result {
                                        
                                        for view in self.photoImageView.subviews {
                                            view.removeFromSuperview()
                                        }
                                        
                                        let livePhotoView = PHLivePhotoView.init(frame: self.photoImageView.bounds)
                                        livePhotoView.livePhoto = result
                                        
                                        livePhotoView.contentMode = .scaleAspectFit
                                        livePhotoView.isMuted = false
                                        
                                        livePhotoView.startPlayback(with: .full)
                                        
                                        self.photoImageView.addSubview(livePhotoView)
                                        
                                        if !self.usePhotoButton.isEnabled {
                                            self.usePhotoButton.isEnabled = true
                                        }
                                    }
        })
    }
    
    // MARK: - Photo CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCell", for: indexPath) as! CreateCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let selectedAsset = fetchResults.object(at: indexPath.item)
//        DispatchQueue.global(qos: .userInteractive).async {
//            self.getAssetThumbnail(selectedAsset, for: cell as! CreateCollectionViewCell)
//        }
        
        getAssetThumbnail(selectedAsset, for: cell as! CreateCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = fetchResults.object(at: indexPath.item)
        
        getAssetLarge(selectedAsset)
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
