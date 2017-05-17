//
//  MainViewController.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2016-12-18.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var _pageViewController: UIPageViewController?
    
    private var _controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        _pageViewController?.delegate = self
        _pageViewController?.dataSource = self
        _pageViewController?.view.frame = self.view.bounds
        
        populateControllersArray()
        
        if !_controllers.isEmpty {
            _pageViewController?.setViewControllers([_controllers[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        self.view.addSubview((_pageViewController!.view)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
    
    func populateControllersArray() {
        var controller: PageItemViewController = storyboard!.instantiateViewController(withIdentifier: "Logo") as! PageItemViewController
        controller.itemIndex = 0
        controller.view.backgroundColor = UIColor.clear
        _controllers.append(controller)
        
        controller = storyboard!.instantiateViewController(withIdentifier: "CurveGraphs") as! CurveGraphsViewController
        controller.itemIndex = 1
        controller.view.backgroundColor = UIColor.clear
        _controllers.append(controller)
        
        controller = storyboard!.instantiateViewController(withIdentifier: "LineGraphs") as! LineGraphsViewController
        controller.itemIndex = 2
        controller.view.backgroundColor = UIColor.clear
        _controllers.append(controller)
        
        controller = storyboard!.instantiateViewController(withIdentifier: "BarGraphs") as! BarGraphsViewController
        controller.itemIndex = 3
        controller.view.backgroundColor = UIColor.clear
        _controllers.append(controller)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? PageItemViewController {
            if controller.itemIndex > 0 {
                return _controllers[controller.itemIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? PageItemViewController {
            if controller.itemIndex < _controllers.count - 1 {
                return _controllers[controller.itemIndex + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return _controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
