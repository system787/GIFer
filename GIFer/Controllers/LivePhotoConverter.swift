//
//  LivePhotoConverter.swift
//  GIFer
//
//  Created by Vincent Hoang on 7/29/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import Photos
import NSGIF2

protocol LivePhotoConverterDelegate {
    func videoToGIFComplete(_ url: URL)
}

class LivePhotoConverter {
    
    typealias LivePhotoContents = (photo: URL, video: URL)
    
    static let DOMAIN_NAME = "com.vincenthoang.GIFer"
    static let shared = LivePhotoConverter()
    
    var delegate: LivePhotoConverterDelegate?
    
    // MARK: - Computed Properties
    private lazy var cacheDir: URL? = {
        if let cacheURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let domainURL = cacheURL.appendingPathComponent("com.vincenthoang.GIFer", isDirectory: true)
            
            if !FileManager.default.fileExists(atPath: domainURL.absoluteString) {
                try? FileManager.default.createDirectory(at: domainURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            return domainURL
        }
        
        return nil
    }()
    
    // MARK: - Async Queue
    private let queue = DispatchQueue(label: "\(DOMAIN_NAME)Queue")
    
    // MARK: - initializer/deinitializer
    private init() {
        // TODO
    }
    
    deinit {
        // TODO
    }
    
    // MARK: - Private Functions
    
    /*
        Step 1 - Convert LivePhoto to Video (.MOV)
     */
    private func convertLivePhotoToGIF(livePhoto: PHLivePhoto) {
        
    }
    
    private func extractVideo(from livePhoto: PHLivePhoto, to directoryURL: URL, completion: @escaping (LivePhotoContents?) -> Void) {
        
    }
    
    /*
        Step 2 - Convert Video (.MOV) to GIF
     */
    private func convertVideoToGIF(fileName: String) {
        let videoURL = URL(fileURLWithPath: "\(fileName).MOV", relativeTo: getDocumentsDirectory())
        
        NSGIF.create(NSGIFRequest(sourceVideo: videoURL), completion: { url in
                //gifURL is set to nil if failed or stopped
        })
        
        
        let gifURL = URL(fileURLWithPath: "\(fileName).gif", relativeTo: getDocumentsDirectory())
        delegate?.videoToGIFComplete(gifURL)
    }
    
    // MARK: - Utility
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
