//
//  CoreDataManager.swift
//  AVFoundation-MediaFeed
//
//  Created by Maitree Bain on 4/14/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private init() { }
    static let shared = CoreDataManager()
    
    private var mediaObjects = [CDMediaObject]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func create(_ imageData: Data, videoURL: URL?) -> CDMediaObject {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        mediaObject.createdDate = Date()
        mediaObject.id = UUID().uuidString
        mediaObject.videoData = imageData
        if let videoURL = videoURL {
            do{
                mediaObject.imageData = try Data(contentsOf: videoURL)
            } catch {
                print("failed to convert data to url: \(error)")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("failed to save newly created media object with error: \(error)")
        }
        
        return mediaObject
    }
    
    func fetchMediaObjects() -> [CDMediaObject]{
        do {
            mediaObjects = try context.fetch(CDMediaObject.fetchRequest())
            
        } catch {
            
        }
        
        return mediaObjects
    }
    
}
