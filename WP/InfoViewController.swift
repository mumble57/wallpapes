//
//  InfoViewController.swift
//  WP
//
//  Created by user on 14/11/2019.
//  Copyright © 2019 user. All rights reserved.
// app ca-app-pub-9701951385094123~9197456684
// banner ca-app-pub-9701951385094123/9692280709
//test ca-app-pub-3940256099942544/2934735716

import UIKit
import GoogleMobileAds

class InfoViewController: UIViewController {
    
    @IBOutlet weak var bannerView : GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //remove test id
        bannerView.adUnitID = "ca-app-pub-9701951385094123/9692280709"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
}
