//
//  ScrollerPage.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ScrollPagerDelegate: NSObjectProtocol {
    optional func scrollPager(scrollPager: ScrollPager, changedIndex: Int)
    optional func scrollPagerWillChange(scrollPager: ScrollPager, fromIndex: Int)
    optional func scrollPagerdidSelectItem(scrollPager: ScrollPager, index: Int)
}
class ScrollPager: UIView {
    var selectedIndex = 0 {
        willSet {
            delegate?.scrollPagerWillChange!(self, fromIndex: selectedIndex)
        } didSet {
            let width = scrollView.frame.width / 5
            if selectedIndex > 1 && selectedIndex < views.count - 2 {
                scrollView.setContentOffset(CGPoint(x: width * CGFloat(selectedIndex - 2), y: 0), animated: true)
            }
            if selectedIndex > views.count - 3 {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0), animated: true)
            }
            delegate?.scrollPager!(self, changedIndex: selectedIndex)
        }
    }
    var buttons = [UIButton]()
    var views = [UIView]()
    var scrollView: UIScrollView!
    private var delayTask: CancelableTask?
    @IBOutlet weak var delegate: ScrollPagerDelegate?
    
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    override func awakeFromNib() {
        setUpViews()
    }
    
    func setUpViews() {
        scrollView = UIScrollView(frame: frame)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        addSubview(scrollView)
    }

    func addSegmentWithViews(views:[UIView]) {
        setNeedsDisplay()
        addButton(views)
    }
    
    func addButton(aviews: [UIView]) {
        for button in buttons {
            button.removeFromSuperview()
        }
        for view in views {
            view.removeFromSuperview()
        }
        buttons.removeAll(keepCapacity: true)
        views.removeAll(keepCapacity: true)
        let width = frame.width / 5
        let height = frame.height
        for i in 0..<aviews.count {
            let btnframe = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            let view = aviews[i]
            view.frame = btnframe
            views.append(view)
            scrollView.addSubview(view)
            let button = UIButton(type: .Custom)
            button.frame = view.bounds
            button.backgroundColor = UIColor.clearColor()
            button.tag = i
            button.addTarget(self, action: "buttonSelected:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            view.addSubview(button)
            scrollView.addSubview(view)
        }
        scrollView.contentSize = CGSize(width: CGFloat(buttons.count) * width, height: height)
    }
    
    func buttonSelected(sender: UIButton) {
        if sender.tag == selectedIndex {
            return
        }
        selectedIndex = sender.tag
        delayTask = delay(0.25) {
         self.delegate?.scrollPagerdidSelectItem!(self, index: self.selectedIndex)
        }
    }
}

extension ScrollPager: UIScrollViewDelegate {

}
