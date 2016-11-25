//
//  L3sRightViewController.swift
//  Live3s
//
//  Created by phuc on 1/25/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sRightViewController: L3sViewController {

    
    @IBOutlet weak var btnBuy1: UIButton!
    @IBOutlet weak var btnBuy2: UIButton!
    @IBOutlet weak var btnBuy3: UIButton!
    @IBOutlet weak var btnBuy4: UIButton!
    
//    let storeKitHelper = StoreKitHelper.shareHelper
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        storeKitHelper.requestProducts { (success, products) in
//            debugPrint(products)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyButtonPress(sender: UIButton) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
