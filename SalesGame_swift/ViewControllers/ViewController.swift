//
//  ViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 11/16/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit

//class ViewController: UIViewController, UIPageViewControllerDataSource {
//    
//    var pageViewController: UIPageViewController!
//    var pageTitle: NSArray!
//    var pageImage: NSArray!
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    
//    
//    func viewControllerAtIndex(index: Int) -> NewUserProfileViewController {
//        
//        if(self.pageTitle.count == 0) || (index >= self.pageTitle.count) {
//            return NewUserProfileViewController()
//        }
//        
//        var vc: NewUserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("") as! NewUserProfileViewController
//        
//        vc.pageIndex = index
//        
//    }
//    
//    
//    //==========================================================================================================================
//    
//    // MARK: PageViewController DataSource
//    
//    //==========================================================================================================================
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        
//        let vc = viewController as! NewUserProfileViewController
//        var index = vc.pageIndex as Int
//        
//        if (index == 0) || (index == NSNotFound) {
//            return nil
//        }
//        
//        index--
//        return self.viewControllerAtIndex(index)
//        
//    }
//    
//    
//    //==========================================================================================================================
//    
//    // MARK: Buttons IBAction
//    
//    //==========================================================================================================================
//    
//    @IBAction func restartButtonTap(sender: AnyObject) {
//   
//    }
//    
//    
//    
//    //==========================================================================================================================
//    
//    // MARK: Progress hud display methods
//    
//    //==========================================================================================================================
//    
//    func showhud() {
//        showHud(self.view)
//    }
//
//}
