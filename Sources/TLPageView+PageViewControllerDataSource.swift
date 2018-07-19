//
//  TLPageView+PageViewControllerDataSource.swift
//  TLPageView
//
//  Created by Charles on 2018/7/19.
//  Copyright © 2018 Charles. All rights reserved.
//

import UIKit

extension TLPageView : UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // 如果没有 控制器  返回 nil
        if childControllers.isEmpty {
            return nil
        }
        
        let beforeIndex = currentIndex - 1
        if beforeIndex < 0 {
            return nil
        }
        
        return childControllers[beforeIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // 如果没有 控制器  返回 nil
        if childControllers.isEmpty {
            return nil
        }
        
        let afterIndex = currentIndex + 1
        if afterIndex > childControllers.count - 1 {
            return nil
        }
        
        return childControllers[afterIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return childControllers.count
    }
    //不要实现次方法 地下的UIPageControl就不会有了
//    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 2//currentIndex
//    }
    
}

extension TLPageView : UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pengdingViewController = pendingViewControllers.first
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            for (index, vc) in childControllers.enumerated() {
                if pengdingViewController == vc {
                    currentIndex = index
                    tlPageViewDelegate?.pageView(self, targetIndex: currentIndex)
                    break
                }
            }
        }
    }
}
