//
//  NavigationTitleExampleViewController.swift
//  Example
//
//  Created by zzk on 06/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKPageViewController

class CustomPageTitleItem: ZKPageTitleItem {
    
    override var sliderInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: icon.frame.minX, bottom: 0, right: bounds.maxX - label.frame.maxX)
    }
    
    let icon = UIButton(type: .infoLight)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.right.equalTo(label.snp.left)
            make.centerY.equalToSuperview()
        }
        label.snp.remakeConstraints { (remake) in
            remake.centerY.equalToSuperview()
            remake.centerX.equalToSuperview().offset(10)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NavigationTitleExampleViewController: ZKPageViewController, ZKPageViewControllerDelegate, ZKPageViewControllerDataSource {
    
    var titleItems = [ZKPageTitleItem]()
    var viewControllers = [ViewController(), ViewController(), ViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTitleItems()
        navigationItem.titleView = titleView
        
        titleView.snp.remakeConstraints { (make) in
            make.height.equalTo(titleHeight)
            make.top.equalToSuperview()
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
        
        collectionView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleView.setCurrentIndex(index: currentIndex, animated: false)
    }
    
    private func prepareTitleItems() {
        for i in 0..<3 {
            let item = CustomPageTitleItem()
            item.normalColor = .darkGray
            item.selectedColor = UIColor.random()
            item.label.text = "Title \(i)"
            if i == 2 {
                item.label.text = "LongTitle 2"
            }
            titleItems.append(item)
        }
    }
    
    func numberOfPages(_ pageViewController: ZKPageViewController) -> Int {
        return 3
    }
    
    func pageViewController(_ pageViewController: ZKPageViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: ZKPageViewController, titleItemFor index: Int) -> ZKPageTitleItem {
        return titleItems[index]
    }
    
    func pageViewController(_ pageViewController: ZKPageViewController, willShow viewController: UIViewController) {
        
    }
    
    
}

