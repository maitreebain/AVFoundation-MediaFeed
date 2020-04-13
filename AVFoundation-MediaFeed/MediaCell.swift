//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Maitree Bain on 4/13/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var postView: UIImageView!
    
    func configureCell(for mediaObject: MediaObject) {
        if let imageData = mediaObject.imageData {
            postView.image = UIImage(data: imageData)
        }
        
        if let videoURL = mediaObject.videoURL {
            let image = videoURL.videoPreviewThumbnail()
            postView.image = image
        }
    }
}
