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
import Accelerate

protocol LivePhotoConverterDelegate {
    func videoToGIFComplete(_ url: URL?)
}

class LivePhotoConverter {
    typealias LivePhotoContents = (photo: URL, video: URL)
    
    static let DOMAIN_NAME = "com.vincenthoang.GIFer"
    static let shared = LivePhotoConverter()
    
    var delegate: LivePhotoConverterDelegate?
    
    // MARK: - Computed Properties
    private lazy var cacheURL: URL? = {
        if let cacheURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let domainURL = cacheURL.appendingPathComponent("com.vincenthoang.GIFer", isDirectory: true)
            
            if !FileManager.default.fileExists(atPath: domainURL.absoluteString) {
                try? FileManager.default.createDirectory(at: domainURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            return domainURL
        }
        
        return nil
    }()
    
    private static let queue = DispatchQueue(label: "\(DOMAIN_NAME)Queue", attributes: .concurrent)

    // MARK: - initializer/deinitializer
    private init() {
        // TODO
    }
    
    deinit {
        clearCache()
    }
    
    // MARK: - Public Functions
    public class func getContents(from livePhoto: PHLivePhoto, completion: @escaping (LivePhotoContents?) -> Void) {
        queue.async {
            shared.getContents(from: livePhoto, completion: completion)
        }
    }
    
    func convertVideoToGIF(videoURL: URL) {

//        NSGIF.create(NSGIFRequest(sourceVideo: videoURL.absoluteURL), completion: { result in
//            if let url = result {
//                self.delegate?.videoToGIFComplete(url)
//            }
//        })
        
        print("videoURL: \(videoURL.absoluteString)")
        
        let request = NSGIFRequest(sourceVideoForLivePhoto: videoURL)
        request.sourceVideoFile = videoURL
        
        NSGIF.create(request, completion: { result in
            print(result?.absoluteString ?? "Test")
        })
    }
    
    // MARK: - Private Functions
    private func getContents(from livePhoto: PHLivePhoto, to directoryURL: URL, completion: @escaping (LivePhotoContents?) -> Void) {
        let resources = PHAssetResource.assetResources(for: livePhoto)
        var keyPhotoURL: URL?
        var videoURL: URL?
        
        let dispatchGroup = DispatchGroup()
        
        for resource in resources {
            let buffer = NSMutableData()
            let requestOptions = PHAssetResourceRequestOptions()
            requestOptions.isNetworkAccessAllowed = true
            
            dispatchGroup.enter()
            PHAssetResourceManager.default().requestData(for: resource,
                                                         options: requestOptions,
                                                         dataReceivedHandler: { data in buffer.append(data) }) { error in
                                                            if error == nil {
                                                                if resource.type == .pairedVideo {
                                                                    videoURL = self.saveAsset(resource: resource, to: directoryURL, data: buffer as Data)
                                                                } else {
                                                                    keyPhotoURL = self.saveAsset(resource: resource, to: directoryURL, data: buffer as Data)
                                                                }
                                                            } else {
                                                                NSLog("\(error ?? NSError())")
                                                            }
                                                            dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            guard let pairedPhotoURL = keyPhotoURL, let pairedVideoURL = videoURL else {
                NSLog("photoURL and videoURL were found to be nil")
                completion(nil)
                return
            }
            completion((pairedPhotoURL, pairedVideoURL))
        }
    }
    
    private func getContents(from livePhoto: PHLivePhoto, completion: @escaping (LivePhotoContents?) -> Void) {
        if let cache = cacheURL {
            getContents(from: livePhoto, to: cache, completion: completion)
        } else {
            NSLog("Cache invalid")
        }
    }
    
    // MARK: - Utility
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func saveAsset(resource: PHAssetResource, to directoryURL: URL, data: Data) -> URL? {
        let fileExtension = UTTypeCopyPreferredTagWithClass(resource.uniformTypeIdentifier as CFString,kUTTagClassFilenameExtension)?.takeRetainedValue()
        
        guard let unwrappedExtension = fileExtension else {
            return nil
        }
        
        var fileURL = directoryURL.appendingPathComponent(UUID().uuidString)
        fileURL = fileURL.appendingPathExtension(unwrappedExtension as String)
        
        do {
            try data.write(to: fileURL, options: [Data.WritingOptions.atomicWrite])
        } catch {
            NSLog("Error writing data to file path \(fileURL.absoluteString)")
            return nil
        }
        
        return fileURL
    }
    
    private func clearCache() {
        if let cache = cacheURL {
            try? FileManager.default.removeItem(at: cache)
        }
    }
    
}
