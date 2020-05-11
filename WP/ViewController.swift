//
//  ViewController.swift
//  WP
//
//  Created by user on 17/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import FirebaseStorage
import Photos

class ViewController: UIViewController {
    
    var stringUrl = String()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
//    func downloadImageUserFromFirebase() {
//        let storage = Storage.storage()
//        var reference: StorageReference!
//        //all I did here was remove self before storage
//        reference = storage.reference(forURL: "gs://wallpapers-hd-fire.appspot.com/Assets/telebubby.png")
//        reference.downloadURL { (url, error) in
//            let data = NSData(contentsOf: url!)
//            //self.profileImage.image = image
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        profileImage?.sd_setImage(with: URL(string: stringUrl), placeholderImage: UIImage(named: "paoazur"))
        profileImage.isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        profileImage.addGestureRecognizer(pinchGesture)
        
        downloadButton.setBackgroundImage(UIImage(named: "download"), for: .normal)

    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer){
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
        
    }

    @objc func savedImage(_ im:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        if let err = error {
            print(err)

            let alert = UIAlertController(title: "Please allow access", message: "BCKGRND needs access to your library to save photos and videos.                          Please go to Settings > Privacy > Photos and set BCKGRND to ON.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            let okAction = UIAlertAction(title: "Later", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.addAction(settingsAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            print("success")
            let alert = UIAlertController(title: "Success", message: "Wallpaper successfully saved to Camera Roll", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Nice!", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            downloadButton.setBackgroundImage(UIImage(named: "mark"), for: .normal)
        }
//        let status = PHPhotoLibrary.authorizationStatus()
//        
//        switch status {
//            
//        case .authorized:
//            print("authorized")
//            return
//        case .notDetermined:
//            print("not determined")
//        case .denied, .restricted:
//            print("denied or restricted")
//            //please go to settings and allow access
//
//        }
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        let imageData = profileImage.image!.pngData()
        let compressedImg = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImg!,self, #selector(savedImage), nil)
        }
}


