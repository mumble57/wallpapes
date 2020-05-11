//
//  GridViewController.swift
//  WP
//
//  Created by user on 02/11/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class GridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    let notfirstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC  = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC") as! ViewController
        detailVC.stringUrl = images[indexPath.row].url
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//extension GridViewController : UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        imageCollection.preloadImagesForIndexPaths(indexPaths) // happens on a background queue
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        imageCollection.cancelPreloadImagesForIndexPaths(indexPaths) // again, happens on a background queue
//    }
//}







//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! ViewController
//        if (segue.identifier == "Sega"){
//            if  let index =
//                imageCollection.indexPathsForSelectedItems?.first {
//                furl = images[index.row].url
//                vc.stringUrl = furl
//            }
//
//            //vc.stringUrl = furl
//        }
//    }
//    func jopa(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
////        let imageData = URL(string: images[indexPath.row].url)
////        let data = try? Data(contentsOf: imageData!)
////        let compressedImg = UIImage(data: data as! Data)
////        UIImageWriteToSavedPhotosAlbum(compressedImg!, nil, nil, nil)
////
////        let alert = UIAlertController(title: "Saved", message: "Yees", preferredStyle: .alert)
////        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
////        alert.addAction(okAction)
////        self.present(alert, animated: true, completion: nil)
////        return nil
//        if let url = URL(string: images[indexPath.row].url),
//            let data = try? Data(contentsOf: url),
//            let image = UIImage(data: data) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
//        return CGSize(width:(collectionView.frame.height-90)/2, height: 100)

//    }
    
    
//    @IBAction func savePhoto(_ sender: Any) {
//    }



//extension GridViewController  : UICollectionViewDataSourcePrefetching{
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("Prefetched \(indexPaths)")
//    }
//}


