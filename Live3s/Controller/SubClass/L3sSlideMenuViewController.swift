//
//  L3sSlideMenuViewController.swift
//  Live3s
//
//  Created by phuc on 12/7/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class L3sSlideMenuViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // setup option
        SlideMenuOptions.animationDuration = 0.25
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.simultaneousGestureRecognizers = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
