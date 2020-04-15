//
//  Data+convertToURL.swift
//  AVFoundation-MediaFeed
//
//  Created by Maitree Bain on 4/15/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import Foundation

extension Data {
    
    //let url = mediaOBject.videoData.convertToURL()
    //url = mediaOBject.self.convertToURL
    public func convertToURL() -> URL? {
        
        // create a temporary URL
        //NSTemporaryDirectory() - stores temporary files
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        
        do {
            try self.write(to: tempURL, options: [.atomic])
            return tempURL
        } catch {
            print("failed to write data to temp file: \(error)")
        }
        
        return nil
    }
    
}
