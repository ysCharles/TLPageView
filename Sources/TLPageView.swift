//
//  TLPageView.swift
//  PageMenuCustom
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 江苏天下网商科技有限公司. All rights reserved.
//

import UIKit

protocol TLPageViewDelegate: class {
    func pageView(_ pageView: TLPageView, targetIndex: Int)
}

public class TLPageView: UIView {
    weak var tlPageViewDelegate: TLPageViewDelegate?
    
    // MARK: - Configuration
    var configuration  = TLPageViewConfiguration()
    
    // MARK: - 属性
    var currentIndex: Int = 0
    var pengdingViewController : UIViewController?
    
    var titles: [String] = []
    
    var childControllers: [UIViewController] = []
    
    private lazy var menuView: TLMenuView = {
        let menuView = TLMenuView(configuration: configuration)
        menuView.delegate = self
        menuView.titles = self.titles
        menuView.leftItem = configuration.leftItem
        menuView.rightItem = configuration.rightItem
        return menuView
    }()
    
    private lazy var pageViewController : UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 2])
        pageVC.dataSource = self
        pageVC.delegate = self
        return pageVC
    }()
    
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public init(viewControllers: [UIViewController], pageViewOptions: [TLPageViewOption]?) {
        super.init(frame: .zero)
        
        if let options = pageViewOptions {
            configurePageView(options: options)
        }
        
        self.childControllers = viewControllers
        var ts = [String]()
        for vc in viewControllers {
            ts.append(vc.title ?? "标题")
        }
        titles = ts
        
        setupUI()
    }
    
    
    
}

// MARK: - 公开方法
extension TLPageView {
    /// 替换某个位置的控制器
    ///
    /// - Parameters:
    ///   - viewController: new controller
    ///   - index: position
    public func replace(viewController: UIViewController, at index: Int) {
        if index > childControllers.count - 1 {
            return
        }
        childControllers[index] = viewController
        titles[index] = viewController.title ?? ""
        menuView.refresh(titles: titles)
        
        if index == currentIndex {
            moveTo(index: index, animated: false)
        }
    }
    
    public func moveTo(index : Int, animated : Bool) {
        if currentIndex == index {
            pengdingViewController = childControllers[index]
            pageViewController.setViewControllers([pengdingViewController!], direction: .forward, animated: false, completion: nil)
            return
        }
        
        if index < 0 || index > childControllers.count - 1{
            return
        }
        
        let direction :UIPageViewControllerNavigationDirection =  index > currentIndex ? .forward : .reverse
        pengdingViewController = childControllers[index]
        pageViewController.setViewControllers([pengdingViewController!], direction: direction, animated: animated, completion: nil)
        currentIndex = index
    }
}


// MARK: - 配置 && 布局
extension TLPageView {
    private func setupUI() {
        backgroundColor = UIColor.clear
        addSubview(menuView)
        addSubview(pageViewController.view)
        
        tlPageViewDelegate = menuView
    }
    
    private func configurePageView(options: [TLPageViewOption]) {
        for option in options {
            switch option {
            case let .menuHeight(value):
                configuration.menuHeight = value
            case let .menuItemFont(value):
                configuration.menuItemFont = value
            case let .menuBottmonLineHeight(value):
                configuration.menuBottmonLineHeight = value
            case let .menuBottomLineColor(value):
                configuration.menuItemSelectedColor = value
            case let .menuItemColor(value):
                configuration.menuItemColor = value
            case let .menuItemSelectedColor(value):
                configuration.menuItemSelectedColor = value
            case let .menuItemMargin(value):
                configuration.menuItemMargin = value
            case let .leftItem(value):
                configuration.leftItem = value
            case let .rightItem(value):
                configuration.rightItem = value
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        menuView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: configuration.menuHeight)
        
        pageViewController.view.frame = CGRect(x: 0, y: configuration.menuHeight, width: self.frame.size.width, height: self.frame.size.height - configuration.menuHeight)
        moveTo(index: 0, animated: false)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let vc = viewController()
        vc.addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: vc)
    }
    
    
    func viewController() -> UIViewController {
        var nextRes : UIResponder?
        nextRes = next
        
        repeat {
            if let vc = nextRes as? UIViewController {
                return vc
            } else {
                nextRes = nextRes?.next
            }
        } while nextRes != nil
        
        return UIViewController()
    }
}

// MARK: - 遵守 TLMenuViewDelegate
extension TLPageView: TLMenuViewDelegate {
    func menuView(_ menuView: TLMenuView, targetIndex: Int) {
        
        moveTo(index: targetIndex, animated: true)
    }
}
