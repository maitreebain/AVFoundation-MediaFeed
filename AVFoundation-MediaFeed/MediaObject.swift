//
//  MediaObject.swift
//  AVFoundation-MediaFeed
//
//  Created by Maitree Bain on 4/13/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import Foundation

//mediaObject instance can be video or image content
struct MediaObject {
    let imageData: Data?
    let videoURL: String?
    let caption: String?
    let id = UUID().uuidString
    let createdDate = Date()
}
