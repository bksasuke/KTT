//
//  BadgeButton.swift
//  Live3s
//
//  Created by phuc on 12/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {
    private var badgeLabel: UILabel
    var badgeString: String? {
        didSet {
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    var badgeBackgroundColor = UIColor.redColor() {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    var badgeTextColor = UIColor.whiteColor() {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    override init(frame: CGRect) {
        badgeLabel = UILabel()
        super.init(frame: frame)
        // Initialization code
        setupBadgeViewWithString(badgeText: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        badgeLabel = UILabel()
        super.init(coder: aDecoder)
        setupBadgeViewWithString(badgeText: "")
    }
    
    func initWithFrame(frame frame: CGRect, withBadgeString badgeString: String, withBadgeInsets badgeInsets: UIEdgeInsets) -> AnyObject {
        
        badgeLabel = UILabel()
        badgeEdgeInsets = badgeInsets
        setupBadgeViewWithString(badgeText: badgeString)
        return self
    }
    
    private func setupBadgeViewWithString(badgeText badgeText: String?) {
        badgeLabel.clipsToBounds = true
        badgeLabel.text = badgeText
        badgeLabel.font = UIFont.systemFontOfSize(9)
        badgeLabel.textAlignment = .Center
        badgeLabel.sizeToFit()
        let badgeSize = badgeLabel.frame.size
    
        let width = 18.0
        let height = 18.0
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = CGRectGetWidth(self.frame) - CGFloat((width / 1.5))
            let y = CGFloat((height/2))
            badgeLabel.frame = CGRectMake(x, y, CGFloat(width), CGFloat(height))
        }
        
        setupBadgeStyle()
        addSubview(badgeLabel)
        
        badgeLabel.hidden = badgeText != nil ? false : true
    }
    
    private func setupBadgeStyle() {
        badgeLabel.textAlignment = .Center
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.textColor = badgeTextColor
        badgeLabel.layer.cornerRadius = 5
    }
}
