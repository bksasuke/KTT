//
//  L3sLeftMenuViewController.swift
//  Live3s
//
//  Created by phuc nguyen on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import RealmSwift

enum LeftMenu: Int {
    case Match = 0
    case Fixtures
    case Result
    case Search
    case Rate
    case Statistic
    case TVScheldule
    case liveTv
    case Tips
    case Favorite
    case Setting
    case Related
    case Share
    case Review
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class L3sLeftMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var matchViewController: UINavigationController!
    var isLogin = false {
        didSet {
            live3sAccount = Live3sAccount.getAccount()
            tableView.reloadData()
        }
    }
    var live3sAccount: Live3sAccount!
    /**
     Private variable
     */
    
    private let menus = [
        kLeftMenu_Match,
        kLeftMenu_Fixtures,
        kLeftMenu_Result,
        kLeftMenu_Search,
        kLeftMenu_Rate,
        kLeftMenu_Statistic,
        kLeftMenu_Scheldule,
        kLeftMenu_LiveTv,
        kLeftMenu_Tips,
        kLeftMenu_Favorite,
        kLeftMenu_Setting,
        kLeftMenu_Related,
        kLeftMenu_Share,
        kLeftMenu_Review]
    private var searchViewController: UINavigationController!
    private var rateViewController: UINavigationController!
    private var statisticViewController: UINavigationController!
    private var tvSchelduleViewController: UINavigationController!
    private var liveTvViewController: UINavigationController!
    private var tipsViewController: UINavigationController!
    private var favoriteViewController: UINavigationController!
    private var settingViewController: UINavigationController!
    private var relatedViewController: UINavigationController!
    private var shareViewController: UINavigationController!
    private var reviewViewController: UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // create search ViewController
        let searchVC = storyboard!.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        
        searchViewController = UINavigationController(rootViewController: searchVC)
        
        // create rate Viewcontroller
        let rateVC =  storyboard!.instantiateViewControllerWithIdentifier("RateViewController") as! RateViewController
        rateViewController = UINavigationController(rootViewController: rateVC)
        
        // create statistic ViewController
        let statisticVC =  storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController = UINavigationController(rootViewController: statisticVC)
        
        // create tvScheldule ViewController
        let tvSchelduleVC =  storyboard!.instantiateViewControllerWithIdentifier("TVSchelduleViewController") as! TVSchelduleViewController
        tvSchelduleViewController = UINavigationController(rootViewController: tvSchelduleVC)
        
        // create liveTv View Controller
        let liveTvVC = L3sLiveTvViewController(nibName: "L3sLiveTvViewController", bundle: nil)
        liveTvViewController = UINavigationController(rootViewController: liveTvVC)
        
        // create tips ViewController
        let tipsVC =  L3sTipsViewController(nibName: "L3sTipsViewController", bundle: nil)
        tipsViewController = UINavigationController(rootViewController: tipsVC)
        
        // create favorite ViewController
        let favoriteVC = storyboard!.instantiateViewControllerWithIdentifier("FavoriteViewController") as! FavoriteViewController
        favoriteViewController = UINavigationController(rootViewController: favoriteVC)
        
        // create setting ViewController
        let settingVc = storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        settingViewController = UINavigationController(rootViewController: settingVc)
        
        // create related ViewController
        let relatedVc = storyboard!.instantiateViewControllerWithIdentifier("RelatedViewController") as! RelatedViewController
        relatedViewController = UINavigationController(rootViewController: relatedVc)
        
        // create share ViewController
        let shareVC = storyboard!.instantiateViewControllerWithIdentifier("ShareViewController") as! ShareViewController
        shareViewController = UINavigationController(rootViewController: shareVC)
        
        // create review ViewController
        let reviewVC = ReviewViewController()
        reviewViewController = UINavigationController(rootViewController: reviewVC)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(L3sLeftMenuViewController.reloadMenu), name: MENU, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        live3sAccount = Live3sAccount.getAccount()
        if live3sAccount.userName == "" {
            isLogin = false
        }else{
            isLogin = true
        }
    }
    func reloadMenu(){
        self.tableView.reloadData()
    }
    
    func loginFB(btn: UIButton) {
        FaceBookManager.shareManage.loginFacebook(self){ [unowned self] bool in
            self.isLogin = bool
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeViewController(menu: String, name: String) {
        switch menu {
        case "livescore":
           
            slideMenuController()?.changeMainViewController(matchViewController, close: true)
            let matchVC = matchViewController.viewControllers[0] as! MatchViewController
            let currentIndex = middleItem
            matchVC.headerScroll.selectedIndex = currentIndex
            matchVC.stringType = "Match"
            matchVC.screenType = 0
            matchVC.isShowFull = true
            matchVC.isLive = false
            matchVC.isByTime = false
            matchVC.reloadData(MatchListType.All,isByTime:false)

            break
        case "live":
            
            slideMenuController()?.changeMainViewController(matchViewController, close: true)
            let matchVC = matchViewController.viewControllers[0] as! MatchViewController
            let currentIndex = middleItem
            matchVC.headerScroll.selectedIndex = currentIndex
            matchVC.stringType = "Live"
            matchVC.screenType = 3
            matchVC.isShowFull = true
            matchVC.isLive = true
            matchVC.isByTime = false
            matchVC.reloadData(MatchListType.Live,isByTime:false)
            break
        case "fixtures":
            
            slideMenuController()?.changeMainViewController(matchViewController, close: true)
            let matchVC = matchViewController.viewControllers[0] as! MatchViewController
            let currentIndex = middleItem
            matchVC.stringType = "Fixtures"
            matchVC.screenType = 1
            matchVC.isShowFull = true
            matchVC.isLive = false
            matchVC.isByTime = false
            matchVC.headerScroll.selectedIndex = currentIndex
            matchVC.reloadData(MatchListType.Future,isByTime:false)
            break
        case "results":
            slideMenuController()?.changeMainViewController(matchViewController, close: true)
            let matchVC = matchViewController.viewControllers[0] as! MatchViewController
            let currentIndex = middleItem
            matchVC.headerScroll.selectedIndex = currentIndex
            matchVC.stringType = "Result"
            matchVC.screenType = 2
            matchVC.isLive = false
            matchVC.isShowFull = true
            matchVC.isByTime = false
             matchVC.reloadData(MatchListType.Finish,isByTime: false)
            break
        case "search":
            slideMenuController()?.changeMainViewController(searchViewController, close: true)
            let controller = searchViewController.viewControllers[0] as! SearchViewController
            controller.isShowFull = true
            controller.title = name
            break
        case "odds":
            slideMenuController()?.changeMainViewController(rateViewController, close: true)
            let controller = rateViewController.viewControllers[0] as! RateViewController
            controller.isShowFull = true
            controller.title = name
            break
        case "standings":
            slideMenuController()?.changeMainViewController(statisticViewController, close: true)
            let controller = statisticViewController.viewControllers[0] as! StatisticViewController
            controller.isShowFull = true
            controller.title = name
            break
        case "matchtv":
            slideMenuController()?.changeMainViewController(tvSchelduleViewController, close: true)
            let controller = tvSchelduleViewController.viewControllers[0] as! TVSchelduleViewController
            controller.isShowFull = true
            controller.title = name
            break
        case "matchtv":
            slideMenuController()?.changeMainViewController(liveTvViewController, close: true)
            let controller = liveTvViewController.viewControllers[0] as! L3sLiveTvViewController
            controller.isShowFull = true
            controller.title = name
            break
        case "tips":
            slideMenuController()?.changeMainViewController(tipsViewController, close: true)
            let controller = tipsViewController.viewControllers[0] as! L3sTipsViewController
            controller.title = name
            controller.isShowFull = true
            break
        case "favourite":
            slideMenuController()?.changeMainViewController(favoriteViewController, close: true)
            let controller = favoriteViewController.viewControllers[0] as! FavoriteViewController
            controller.isShowFull = true
            controller.title = name
            break
        case "language":
            slideMenuController()?.changeMainViewController(settingViewController, close: true)
            let controller = settingViewController.viewControllers[0] as! SettingViewController
            controller.title = name
            break
        case "relatedapps":
            slideMenuController()?.changeMainViewController(relatedViewController, close: true)
            let controller = relatedViewController.viewControllers[0] as! RelatedViewController
            controller.title = name
            break
        case "share":
            slideMenuController()?.changeMainViewController(shareViewController, close: true)
            let controller = shareViewController.viewControllers[0] as! ShareViewController
            controller.title = name
            break
        case "review":
            let url = NSURL(string:L3sAppDelegate.linkRateApp)
            UIApplication.sharedApplication().openURL(url!)
        default:
            return
        }
    }
    
}

/// L3sLefMenuViewController Extensions

extension L3sLeftMenuViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let code = AL0604.currentLanguage
        guard let realm = try? Realm(),
            let menu = realm.objectForPrimaryKey(MenuList.self, key: code) else {return 0}
//        return menu.menuItem.count + 1
        return menu.menuItem.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftMenuCell") as! LefMenuTableViewCell
        let code = AL0604.currentLanguage
        cell.btnLogin.hidden = true
        cell.avatarImageView.hidden = false
        cell.detailLabel.hidden = false
//        let indexData = indexPath.row - 1
        let indexData = indexPath.row
//            if indexPath.row != 0 {
                cell.selectionStyle = .Default
                guard let realm = try? Realm(),
                    let menu = realm.objectForPrimaryKey(MenuList.self, key: code),
                    let item = menu.menuItem.filter({$0.index == indexData}).first else {return cell}
                cell.configCell(item)
//            }else{
//                cell.selectionStyle = .None
//                if isLogin{
//                    let url = NSURL(string: live3sAccount.imageUrl)
//                    cell.avatarImageView.af_setImageWithURL(url!)
//                    let myString = NSMutableAttributedString(string: "\(live3sAccount.userName)     ")
//                    let myAttributes1 = [ NSForegroundColorAttributeName: UIColor(rgba: "#fab719")]
//                    let stringGold = "\(live3sAccount.userGold) Gold"
//                    let attrString3 = NSAttributedString(string: stringGold, attributes: myAttributes1)
//                    myString.appendAttributedString(attrString3)
//                    cell.detailLabel.attributedText = myString
//                    cell.btnLogin.hidden = true
//                    cell.avatarImageView.hidden = false
//                    cell.detailLabel.hidden = false
//                }else{
//                    cell.btnLogin.hidden = false
//                    cell.avatarImageView.hidden = true
//                    cell.detailLabel.hidden = true
//                }
//                cell.btnLogin.addTarget(self, action: #selector(L3sLeftMenuViewController.loginFB(_:)), forControlEvents: .TouchUpInside)
//            }
        
        return cell
    }
}

extension L3sLeftMenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let code = AL0604.currentLanguage
        var indexData = 0
//            indexData = indexPath.row - 1
        indexData = indexPath.row
            //if indexPath.row == 0{return}
        guard let realm = try? Realm(),
            let menu = realm.objectForPrimaryKey(MenuList.self, key: code),
            let item = menu.menuItem.filter({$0.index == indexData}).first else {return}
            changeViewController(item.iconUrl, name: item.name)

    }
}

class LefMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    func configCell(menu: MenuModule) {
        avatarImageView.image = UIImage(named: menu.module)
        detailLabel.text = menu.name
    }
    func configCell(menu: Menu?) {
        guard let menu = menu else {return}
        avatarImageView.image = UIImage(named: menu.iconUrl)
        detailLabel.text = menu.name
        layoutSubviews()
    }
}
