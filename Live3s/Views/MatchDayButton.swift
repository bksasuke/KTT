//
//  MatchDayButton.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit

enum MatchDayButtonType: Int, CustomStringConvertible {
    case SelectedType = 0, SemiSelectedType, NoneType
    private var colorType: String {
        switch self {
        case .SelectedType:
            return "#000000"
        case .SemiSelectedType:
            return "#FACC00"
        case .NoneType:
            return "#96948A"
        }
    }
    var description: String {
        switch self {
        case .SelectedType:
            return "#000000"
        case .SemiSelectedType:
            return "#FACC00"
        case .NoneType:
            return "#96948A"
        }
    }
}

class MatchDayButton: UIView {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var day_numLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    private var containerView: UIView?
    var type: MatchDayButtonType? {
        didSet {
            dayLabel.textColor = UIColor(rgba: type!.description)
            day_numLabel.textColor = UIColor(rgba: type!.description)
        }
    }
    var title: String? {
        didSet {
            if Int(title!.componentsSeparatedByString("-").first!) == DateManager.shareManager.currentDay {
                dayLabel.text = AL0604.localization(LanguageKey.today)
            } else  {
                dayLabel.text = DateManager.shareManager.weakDayFromString(title!)
            }
        }
    }
    var subTitle: String? {
        didSet {
            day_numLabel.text = subTitle
        }
    }
    var selected = false {
        didSet {
            backgroundImage.hidden = !selected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView = commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        containerView = commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let atitle = title
        title = atitle
    }
    
    
    func commonInit() -> UIView {
        func nibName() -> String {
            return self.dynamicType.description().componentsSeparatedByString(".").last!
        }
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        return view
    }
    
}