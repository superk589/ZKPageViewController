//
//  NormalPageTitleViewController.swift
//  Example
//
//  Created by zzk on 06/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKPageViewController

class NormalPageTitleViewController: ZKPageViewController, ZKPageViewControllerDelegate, ZKPageViewControllerDataSource {

    var titleItems = [ZKPageTitleItem]()
    var viewControllers = [UITableViewController(), ViewController(), ViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTitleItems()
        self.dataSource = self
        self.delegate = self
    }
    
    private func prepareTitleItems() {
        for i in 0..<3 {
            let item = ZKPageTitleItem()
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
