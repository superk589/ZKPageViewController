//
//  ZKPageTitleItem.swift
//  ZKPageViewController
//
//  Created by zzk on 05/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import DynamicColor

open class ZKPageTitleItem: UIView {
    
    public let label = UILabel()
    
    open var normalColor: UIColor = .darkGray
    
    open var selectedColor: UIColor = .blue
    
    open var sliderInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: label.frame.minX, bottom: 0, right: bounds.maxX - label.frame.maxX)
    }
    
    /// 0 present fully out, 1 present fully in
    open var inoutProgress: CGFloat = 0 {
        didSet {
            label.textColor = normalColor.mixedRGB(withColor: selectedColor, weight: inoutProgress)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 16)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
