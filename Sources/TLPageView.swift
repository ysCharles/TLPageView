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
    private var oldIndex: Int = 0
    private var currentIndex: Int = 0
    private var startOffsetX : CGFloat = 0
    
    var titles: [String]?
    
    var childControllers: [UIViewController]? {
        willSet {
            if let vcs = newValue {
                let vc = vcs[currentIndex]
                vc.view.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: collectionView.frame.size.height)
                collectionView.reloadData()
            }
        }
    }
    
    private lazy var menuView: TLMenuView = {
        let menuView = TLMenuView(configuration: configuration)
        menuView.delegate = self
        menuView.titles = self.titles
        menuView.leftItem = configuration.leftItem
        menuView.rightItem = configuration.rightItem
        return menuView
    }()
    
    // 使用 collectionView作为容器
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: String(describing: TLCollectionViewCell.self), bundle: Bundle(for: TLPageView.self)), forCellWithReuseIdentifier: String(describing: TLCollectionViewCell.self))
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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


// MARK: - 配置 && 布局
extension TLPageView {
    private func setupUI() {
        backgroundColor = UIColor.clear
        addSubview(menuView)
        addSubview(collectionView)
        
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
        collectionView.frame = CGRect(x: 0, y: configuration.menuHeight, width: self.frame.size.width, height: self.frame.size.height - configuration.menuHeight)
    }
}


// MARK: - 数据源
extension TLPageView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childControllers?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TLCollectionViewCell.self), for: indexPath) as! TLCollectionViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        if let childVC = childControllers?[indexPath.item] {
            childVC.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(childVC.view)
        }
        
        return cell
    }
}


// MARK: - UIScrollViewDelegate
extension TLPageView : UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
        scrollView.isScrollEnabled = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        } else {
            scrollView.isScrollEnabled = false
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    
    private func contentEndScroll() {
        // 获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        // 通知titleView进行调整
        tlPageViewDelegate?.pageView(self, targetIndex: currentIndex)
    }

}

// MARK: - 遵守 TLMenuViewDelegate
extension TLPageView: TLMenuViewDelegate {
    func menuView(_ menuView: TLMenuView, targetIndex: Int) {
        currentIndex = targetIndex
        //滚动到对应的 index
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}
