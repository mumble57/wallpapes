//
//  CollectionViewFlowLayout.swift
//  WP
//
//  Created by user on 02/11/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        SetupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        SetupLayout()
    }
    override var itemSize: CGSize {
        set {}
        get{
            let numberOfColums: CGFloat = 3
            
            let itemWidth = (self.collectionView!.frame.width - (numberOfColums - 1)) // numberOfColums
            let itemHeight = (self.collectionView!.frame.height)
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    func SetupLayout(){
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0 
        scrollDirection = .vertical
        
    }
}
