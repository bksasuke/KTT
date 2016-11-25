//
//  Live3sAccount.swift
//  Live3s
//
//  Created by ATCOMPUTER on 09/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation

let live3sUserName = "username"
let live3sUserImage = "userImage"
let live3sUserGold = "usergold"
let live3sAccount = "live3sAccount"
class Live3sAccount: NSObject, NSCoding {
    
   // let getInstance:Live3sAccount = Live3sAccount(userName: "", gold: "0")
    var userName:String = ""
    var userGold:String = ""
    var imageUrl:String = ""
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userName, forKey: live3sUserName)
        aCoder.encodeObject(self.userGold, forKey: live3sUserGold)
        aCoder.encodeObject(self.imageUrl, forKey: live3sUserImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userName = aDecoder.decodeObjectForKey(live3sUserName) as! String
        self.userGold = aDecoder.decodeObjectForKey(live3sUserGold) as! String
        self.imageUrl = aDecoder.decodeObjectForKey(live3sUserImage) as! String
    }
    
    override init() {
        super.init()
    }
    
    init(userName:String, gold:String) {
        self.userName = userName
        self.userGold = gold
    }

    func saveAccount() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: live3sAccount)
    }
    
    static func getAccount() -> Live3sAccount  {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(live3sAccount) as? NSData {
            return (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Live3sAccount)!
        }
        return Live3sAccount()
    }
}