//
//  VCLLoggingViewController.swift
//
//  Created by CS193p Instructor.
//  Copyright © 2015-17 Stanford University. All rights reserved.
//

import UIKit

open class VCLLoggingViewController : UIViewController
{
    private struct LogGlobals {
        var prefix = ""
        var instanceCounts = [String: Int]()
        var lastLogTime = Date()
        var indentationInterval: TimeInterval = 1
        var indentationString = "__"
    }
    private static var logGlobals = LogGlobals()
    private static func logPrefix(for className: String) -> String {
        if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval {
            logGlobals.prefix += logGlobals.indentationString
            print("")
        }
        logGlobals.lastLogTime = Date()
        return logGlobals.prefix + className
    }
    private static func bumpInstanceCount(for className: String) -> Int {
        logGlobals.instanceCounts[className] = (logGlobals.instanceCounts[className] ?? 0) + 1
        return logGlobals.instanceCounts[className]!
    }
    private var instanceCount: Int!
    private func logVCL(_ msg: String) {
        let className = String(describing: type(of: self))
        if instanceCount == nil {
            instanceCount = VCLLoggingViewController.bumpInstanceCount(for: className)
        }
        print("\(VCLLoggingViewController.logPrefix(for: className))(\(instanceCount!)) \(msg)")
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logVCL("init(coder:) - created via InterfaceBuilder ")
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logVCL("init(nibName:bundle:) - create in code")
    }
    deinit {
        logVCL("left the heap")
    }
    override open func awakeFromNib() {
        logVCL("awakeFromNib()")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        logVCL("viewDidLoad()")
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewWillAppear(animated = \(animated))")
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logVCL("viewDidAppear(animated = \(animated))")
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL("viewWillDisappear(animated = \(animated))")
    }
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL("viewDidDisappear(animated = \(animated))")
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logVCL("didReceiveMemoryWarning()")
    }
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logVCL("viewWillTransition(to: \(size), with: coordinator)")
        coordinator.animate(alongsideTransition: {
            (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logVCL("begin animate(alongsideTransition:completion:)")
        }, completion: { context -> Void in
            self.logVCL("end animate(alongsideTransition:completion:)")
        })
    }
}

