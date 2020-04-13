//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Maitree Bain on 4/13/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

extension URL{
    
    public func videoPreviewThumbnail() -> UIImage? {
        
        //refers to mediaObject.videoURl...
        let asset = AVAsset(url: self)
        
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        assetGenerator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        var image: UIImage?
        
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch {
            
        }
        
        return image
    }
}
