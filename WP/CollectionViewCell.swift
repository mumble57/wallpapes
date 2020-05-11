//
//  CollectionViewCell.swift
//  WP
//
//  Created by user on 02/11/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var  imageView : UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
