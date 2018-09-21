//
//  ZKPageCollectionView.swift
//  ZKPageViewController
//
//  Created by zzk on 05/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

open class ZKPageCollectionView: UICollectionView {
    
    var layout: UICollectionViewFlowLayout {
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        backgroundColor = UIColor.white
        isPagingEnabled = true
    }

    @available(iOS 11.0, *)
    open override func adjustedContentInsetDidChange() {
        super.adjustedContentInsetDidChange()
        collectionViewLayout.invalidateLayout()
    }
}
