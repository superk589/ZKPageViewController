//
//  ZKPageTitleView.swift
//  ZKPageViewController
//
//  Created by zzk on 05/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import DynamicColor

public protocol ZKPageTitleViewDelegate: class {
    func pageTitleView(_ pageTitleView: ZKPageTitleView, didSelect index: Int)
}

public protocol ZKPageTitleViewDataSource: class {
    func pageTitleView(_ pageTitleView: ZKPageTitleView, itemFor index: Int) -> ZKPageTitleItem
    func numberOfItems(_ pageTitleView: ZKPageTitleView) -> Int
}

open class ZKPageTitleView: UIView {
    
    var currentIndex: Int {
        get {
            return Int(round(floatIndex))
        }
        set {
            floatIndex = CGFloat(newValue)
        }
        
    }
    
    open func setCurrentIndex(index: Int, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.currentIndex = index
            })
        } else {
            currentIndex = index
        }
    }
    
    var floatIndex: CGFloat = 0 {
        didSet {
            let items = titleStackView.arrangedSubviews as! [ZKPageTitleItem]
            let leftIndex = Int(floor(floatIndex))
            let rightIndex = Int(ceil(floatIndex))
            
            guard rightIndex < items.count else {
                return
            }
            
            let leftItem = items[leftIndex]
            let rightItem = items[rightIndex]
            
            let offset = floatIndex - floor(floatIndex)
            let left1 = leftItem.frame.minX + leftItem.sliderInset.left
            let left2 = rightItem.frame.minX + rightItem.sliderInset.left
            
            let width1 = leftItem.frame.width - leftItem.sliderInset.left - leftItem.sliderInset.right
            let width2 = rightItem.frame.width - rightItem.sliderInset.left - rightItem.sliderInset.right
            
            sliderView.bounds.size.width = width1 + (width2 - width1) * offset
            sliderView.frame.origin.x = left1 + (left2 - left1) * offset
            sliderView.backgroundColor = leftItem.selectedColor.mixedRGB(withColor: rightItem.selectedColor, weight: offset)
            
            rightItem.inoutProgress = offset
            leftItem.inoutProgress = 1 - offset
        }
    }
    
    open let sliderView = UIView(frame: CGRect.init(x: 0, y: 0, width: 10, height: 2))
    
    open let titleStackView = UIStackView()
    
    weak var delegate: ZKPageTitleViewDelegate?
    weak var dataSource: ZKPageTitleViewDataSource?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 0
        addSubview(titleStackView)
        titleStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        sliderView.backgroundColor = UIColor.black
        addSubview(sliderView)
    }
    
    private func removeAllItems() {
        for subView in titleStackView.arrangedSubviews {
            titleStackView.removeArrangedSubview(subView)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        sliderView.frame.origin.y = self.bounds.maxY - 2
        setCurrentIndex(index: currentIndex, animated: false)
    }
    
    func reloadItems() {
        removeAllItems()
        guard let dataSource = self.dataSource else {
            return
        }
        for i in 0..<dataSource.numberOfItems(self) {
            let view = dataSource.pageTitleView(self, itemFor: i)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickAction(tap:)))
            view.addGestureRecognizer(tap)
            view.inoutProgress = 0
            titleStackView.addArrangedSubview(view)
        }
        layoutIfNeeded()
        if titleStackView.arrangedSubviews.count > 0 {
            setCurrentIndex(index: 0, animated: false)
        }
    }
    
    @objc func clickAction(tap: UITapGestureRecognizer) {
        if let view = tap.view, let index = titleStackView.arrangedSubviews.index(of: view) {
            delegate?.pageTitleView(self, didSelect: index)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

