//
//  ZKPageViewController.swift
//  ZKPageViewController
//
//  Created by zzk on 05/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

public extension UIViewController {
    public var pageViewController: ZKPageViewController? {
        var vc = parent
        while vc != nil {
            if vc is ZKPageViewController {
                return vc as? ZKPageViewController
            } else {
                vc = vc?.parent
            }
        }
        return nil
    }
}


public protocol ZKPageViewControllerDataSource: class {
    func numberOfPages(_ pageViewController: ZKPageViewController) -> Int
    func pageViewController(_ pageViewController: ZKPageViewController, viewControllerAt index: Int) -> UIViewController
    func pageViewController(_ pageViewController: ZKPageViewController, titleItemFor index: Int) -> ZKPageTitleItem
}

public protocol ZKPageViewControllerDelegate: class {
    func pageViewController(_ pageViewController: ZKPageViewController, willShow viewController: UIViewController)
}

open class ZKPageViewController: UIViewController, ZKPageTitleViewDelegate, ZKPageTitleViewDataSource {
    
    open var titleView: ZKPageTitleView = ZKPageTitleView()
    open var collectionView: ZKPageCollectionView = ZKPageCollectionView()
    
    open var titleHeight: CGFloat = 40 {
        didSet {
            titleView.snp.updateConstraints { (update) in
                update.height.equalTo(titleHeight)
            }
        }
    }
    
    open weak var delegate: ZKPageViewControllerDelegate?
    open weak var dataSource: ZKPageViewControllerDataSource? {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
            titleView.reloadItems()
        }
    }
        
    open var currentIndex: Int {
        set {
            titleView.currentIndex = newValue
            collectionView.contentOffset.x = collectionView.bounds.size.width * CGFloat(newValue)
        }
        get {
            return titleView.currentIndex
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PageCell")
        view.addSubview(collectionView)
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.equalToSuperview()
        }
        titleView.delegate = self
        titleView.dataSource = self
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private var needsAdjustIndex = false
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let index = self.currentIndex
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.performBatchUpdates(nil, completion: nil)
            self.collectionView.contentOffset.x = CGFloat(index) * size.width
            self.titleView.currentIndex = index
            self.needsAdjustIndex = true
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if needsAdjustIndex {
            navigationController?.view.layoutIfNeeded()
            view.layoutIfNeeded()
            needsAdjustIndex = false
            collectionView.layout.invalidateLayout()
            collectionView.contentOffset.x = CGFloat(currentIndex) * collectionView.bounds.width
            titleView.currentIndex = currentIndex
        }
    }
    
    open func reloadData() {
        collectionView.reloadData()
        titleView.reloadItems()
    }
    
    open func pageTitleView(_ pageTitleView: ZKPageTitleView, didSelect index: Int) {
        collectionView.setContentOffset(CGPoint(x: CGFloat(index) * collectionView.bounds.size.width, y: collectionView.contentOffset.y), animated: true)
        pageTitleView.setCurrentIndex(index: index, animated: true)
    }
    
    open func numberOfItems(_ pageTitleView: ZKPageTitleView) -> Int {
        return dataSource?.numberOfPages(self) ?? 0
    }
    
    open func pageTitleView(_ pageTitleView: ZKPageTitleView, itemFor index: Int) -> ZKPageTitleItem {
        return (dataSource?.pageViewController(self, titleItemFor: index))!
    }
}

// MARK: UICollectionViewDelagte & DataSource
extension ZKPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.frame.size
        size.height = size.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        if #available(iOS 11.0, *) {
            size.height -= collectionView.adjustedContentInset.top + collectionView.adjustedContentInset.bottom
        }
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfPages(self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath)
        if let vc = dataSource?.pageViewController(self, viewControllerAt: indexPath.item) {
            self.addChild(vc)
            cell.contentView.addSubview(vc.view)
            vc.view.snp.remakeConstraints { (remake) in
                remake.edges.equalTo(cell.contentView)
            }
            vc.didMove(toParent: self)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let vc = dataSource?.pageViewController(self, viewControllerAt: indexPath.item) {
            vc.beginAppearanceTransition(true, animated: false)
            vc.endAppearanceTransition()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: UIScrollViewDelegate
extension ZKPageViewController {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.size.width
        titleView.currentIndex = Int(index)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating {
            let offsetX = scrollView.contentOffset.x
            let index = offsetX / scrollView.bounds.size.width
            titleView.floatIndex = index
        }
    }
}
