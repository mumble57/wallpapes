//
//  MainViewController.swift
//  WP
//
//  Created by user on 03/12/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import StoreKit

private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    
    var notfirstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
    //var noFeedback = UserDefaults.standard.bool(forKey: "Feedback")
    
    @IBOutlet weak var imageCollection : UICollectionView!
    var customImageFlowLayout: CollectionViewFlowLayout!
    var images = [imageItems]()
    var DBRef : DatabaseReference! = nil
    var furl = String()
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollection.prefetchDataSource = self
        DBRef = Database.database().reference().child("images")
        loadDB()
        setupParallaxController()
        setupNavigationBar()
        
        customImageFlowLayout = CollectionViewFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        
//        if notfirstLaunch == true{
//            print("Nice. Not firt launch")
//        } else {
//            notfirstLaunch = false
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("no feedback = ",UserDefaults.standard.bool(forKey: "Feedback"))
        if (Int(UserDefaults.standard.integer(forKey: "launches"))==4){
            let secondsFromNow = DispatchTime.now() + 6.0
            DispatchQueue.main.asyncAfter(deadline: secondsFromNow) {
                if #available( iOS 10.3,*){
                    SKStoreReviewController.requestReview()
                }
            }
        }
//        //let showAlertNumber = 4
//
//        if (UserDefaults.standard.integer(forKey: "launches")==2) && UserDefaults.standard.bool(forKey: "Feedback") == true{
//            let twoSecondsFromNow = DispatchTime.now() + 5.5
//            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
//                //print("no feedback = ",self.noFeedback)
//            let alert = UIAlertController(title: "Review BCKGRNG", message: "Please, take a moment to review our app", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                //self.noFeedback = false
//                if #available( iOS 10.3,*){
//                    SKStoreReviewController.requestReview()
//                } else {
//                    let url = URL(string: "https://apps.apple.com/us/app/bckgrnd-unusual-wallpapers/id1489460696?ls=1")
//                    UIApplication.shared.open(url!)
//                }
//                UserDefaults.standard.set(false,forKey: "Feedback")
//            }))
//            alert.addAction(UIAlertAction(title: "Not now", style: .default, handler: { action in
//                print("эхх")
//                //self.noFeedback = true
//            }))
//                self.present(alert, animated: true, completion: nil)}
//        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //Refreh collection view when rotate
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        self.imageCollection.collectionViewLayout.invalidateLayout()
    //        //imageCollection.reloadData()
    //    }
    //first launch
    func setupParallaxController() {
        if notfirstLaunch  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            
            let item1 = RMParallaxItem(image: UIImage(named: "png")!, text: "")
            let item2 = RMParallaxItem(image: UIImage(named: "png2")!, text: "")
            let item3 = RMParallaxItem(image: UIImage(named: "png3")!, text: "")
            
            let rmParallaxViewController = RMParallax(items: [item1, item2, item3], motion: true)
            rmParallaxViewController.completionHandler = {
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    rmParallaxViewController.view.alpha = 0.0
                })
            }
            // Adding parallax view controller.
            self.addChild(rmParallaxViewController)
            self.view.addSubview(rmParallaxViewController.view)
            rmParallaxViewController.didMove(toParent: self)
            
            UserDefaults.standard.set(true, forKey: "Feedback")

        }
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    
    func loadDB(){
        DBRef.observe(DataEventType.value, with: { (snapshot) in var newImages = [imageItems]()
            for imageItemsSnapshot in snapshot.children {
                let imageItemsObject = imageItems(snapshot: imageItemsSnapshot as! DataSnapshot)
                newImages.append(imageItemsObject)
            }
            self.images = newImages
            self.imageCollection.reloadData()})
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let image = images[indexPath.row]
        //SDWebImagePrefetcher.shared().prefetchURLs(url)
        DispatchQueue.main.async { [weak self] in
            //guard let weakSelf = self else { return }
            cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "paoazur"))
        }
        //        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "paoazur"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]){
        for indexPath in indexPaths {
            //let model = images[indexPath.row]
            //imageCollection?.fetch(model.id)
            imageCollection.prefetchDataSource = self
            print(indexPaths)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC  = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! ViewController
        detailVC.stringUrl = images[indexPath.row].url
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
