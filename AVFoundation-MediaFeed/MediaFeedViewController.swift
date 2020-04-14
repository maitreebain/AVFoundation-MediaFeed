//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Maitree Bain on 4/13/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MediaFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoLibrary: UIBarButtonItem!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObject](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoButton.isEnabled = false
        }
    }

    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    @IBAction func photoLibraryPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func playRandomVideo(in view: UIView){
        let videoURLS = mediaObjects.compactMap{ $0.videoURL }
        
        if let videoURL = videoURLS.randomElement() {
            let player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = .resizeAspect
            
            view.layer.sublayers?.removeAll()
            
            view.layer.addSublayer(playerLayer)
            player.play()
        }
    
    }
    
}

extension MediaFeedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("could not downcast to MediaCell")
        }
        
        let media = mediaObjects[indexPath.row]
        cell.configureCell(for: media)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("could not dequeue a HeaderView")
        }
        playRandomVideo(in: headerView)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerController = AVPlayerViewController()
        let media = mediaObjects[indexPath.row]
        guard let videoURL = media.videoURL else { return}
        let player = AVPlayer(url: videoURL)
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.4
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.4)
    }
}

extension MediaFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else  {
            return
        }
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let data = originalImage.jpegData(compressionQuality: 1.0){
                let mediaObject = MediaObject(imageData: data, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject)
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                let mediaObject = MediaObject(imageData: nil, videoURL: mediaURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("unsupported media type")
        }
        
        print(mediaType)
        
        dismiss(animated: true)
    }
}
