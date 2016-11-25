//
//  TimeManager.swift
//  Live3s
//
//  Created by phuc on 12/28/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation

let KEY_LIVE_SCORE_DID_UPDATE = "Applicatin did update live score"

class TimeManager:NSObject {
    static var shareManager = TimeManager()
    private var isPause = false
    private var timer: NSTimer!
    private var liveTimer: NSTimer!
    private var runningBlock: (()-> Void)?
    
    override init() {
        super.init()
        startLiveTimer()
    }
    
    func startLiveTimer() {
        liveTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "liveTimerRunning", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(liveTimer, forMode: NSDefaultRunLoopMode)
    }
    
    func liveTimerRunning() {
        NetworkService.getAllMatchs(.Live,isByTime: false) { (matchs, error) -> () in
            if error == nil {
                guard let aMatchs = matchs else {
                      NSNotificationCenter.defaultCenter().postNotificationName(KEY_LIVE_SCORE_DID_UPDATE, object: 0)
                    return
                }
                var count = 0
                    let  anonymous = aMatchs.first
                    if ((anonymous as? LeagueModule) != nil) {
                        for league in aMatchs{
                            let leag = league as! LeagueModule
                            count += Int(leag.matchs.count)
                        }
                    }
                    if  ((anonymous as? MatchModule) != nil) {
                        if aMatchs.count > 0{
                            count = aMatchs.count
                        }
                        
                        
                        
                    }

                
                
                NSNotificationCenter.defaultCenter().postNotificationName(KEY_LIVE_SCORE_DID_UPDATE, object: count)
            }
        }
    }
    
    func startwithblock(block: () -> Void) {
        runningBlock = block
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "running", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    func pause() {
        isPause = true
    }
    
    func resume() {
        isPause = false
    }
    
    func stop() {
        if timer == nil {return}
        timer.invalidate()
        timer = nil
    }
    @objc func running() {
        if isPause {return}
        runningBlock?()
    }
}