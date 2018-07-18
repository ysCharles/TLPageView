//
//  TLMenuView.swift
//  PageMenuCustom
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 江苏天下网商科技有限公司. All rights reserved.
//

import UIKit

protocol TLMenuViewDelegate : class {
    func menuView(_ menuView: TLMenuView, targetIndex: Int)
}

class TLMenuView: UIView {
    weak var delegate : TLMenuViewDelegate?
    
    var configuration : TLPageViewConfiguration
    
    var titles: [String]? {
        didSet {
            if titles?.count ?? 0 > 0 {
                // 将titleLabel添加到UIScrollView中
                setupTitleLabels()
            }
        }
    }
    
    private lazy var currentIndex : Int = 0
    
    /// 标题数组
    private lazy var titleLabels = [TLMenuLabel]()
    /// 滚动视图
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    
    /// 底部滚动指示器
    private lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        return bottomLine
    }()
    
    /// 底部分割线
    fileprivate lazy var bottomSeparatorLine: UIView = {
        let bottomLineView = UIView()
        return bottomLineView
    }()
    
    
    /// 左边 item
    var leftItem : UIView? {
        willSet {
            if let v = newValue {
                addSubview(v)
            }
        }
    }
    
    ///  右边 item
    var rightItem : UIView? {
        willSet {
            if let v = newValue {
                addSubview(v)
            }
        }
    }
    
    func refresh(titles: [String]?) {
        
        self.titles = titles
        setupTitleLabelsFrame()
        
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = configuration.menuItemSelectedColor
        sourceLabel.currentScale = 1.03
        
        var bottomLineFrame = self.bottomLine.frame
        bottomLineFrame.size.width = sourceLabel.frame.size.width - 10
        self.bottomLine.frame = bottomLineFrame
        
        var ct = self.bottomLine.center
        ct.x = sourceLabel.center.x
        self.bottomLine.center = ct
        
        // 4.调整位置
        // 当前偏移量
        var offsetX = sourceLabel.center.x - scrollView.frame.size.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        // 最大偏移量
        var maxOffsetX = scrollView.contentSize.width - scrollView.frame.size.width
        
        if maxOffsetX < 0 {
            maxOffsetX = 0
        }
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // MARK: -  初始化
    override init(frame: CGRect) {
        self.configuration = TLPageViewConfiguration()
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.configuration = TLPageViewConfiguration()
        super.init(coder: aDecoder)
        setupUI()
    }
    
    init(configuration: TLPageViewConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
    }
    
}

// MARK: - 布局 && 配置
extension TLMenuView {
    private func setupUI() {
        addSubview(scrollView)
        addSubview(bottomSeparatorLine)
        // 添加滚动指示条
        scrollView.addSubview(bottomLine)
        bottomLine.backgroundColor = configuration.menuBottomLineColor
    }
    
    /// 将titleLabel添加到UIScrollView中
    private func setupTitleLabels() {
        for label in titleLabels {
            label.removeFromSuperview()
        }
        titleLabels.removeAll()
        
        if let ts = titles {
            for (index, title) in ts.enumerated() {
                let titleLabel = TLMenuLabel()
                titleLabel.text = title
                titleLabel.font = configuration.menuItemFont
                titleLabel.tag = index
                titleLabel.textColor = configuration.menuItemColor
                titleLabel.textAlignment = .center
                
                scrollView.addSubview(titleLabel)
                titleLabels.append(titleLabel)
                
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
                titleLabel.addGestureRecognizer(tapGes)
                titleLabel.isUserInteractionEnabled = true
            }
        }
    }
    
    private func setupTitleLabelsFrame() {
        for (i, label) in titleLabels.enumerated() {
            var w : CGFloat = 0
            let h : CGFloat = configuration.menuHeight
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            let title = titles![i]
            w = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : configuration.menuItemFont], context: nil).width
            
            if i == 0 {
                x = configuration.menuItemMargin * 0.5
                var lineFrame = bottomLine.frame
                lineFrame.origin.x = x + 5
                lineFrame.size.width = w
                bottomLine.frame = lineFrame
            } else {
                let preLabel = titleLabels[i - 1]
                x = preLabel.frame.maxX + configuration.menuItemMargin
            }
            
            label.frame = CGRect(x: x, y: y, width: w + 10, height: h)
        }
        scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + configuration.menuItemMargin * 0.5, height: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - configuration.menuBottmonLineHeight, width: 0, height: configuration.menuBottmonLineHeight)
        
        var leftWidth : CGFloat = 0
        if let left = leftItem {
            var leftFrame = left.frame
            leftFrame.size.height = self.frame.size.height
            leftFrame.origin = CGPoint(x: 0, y: 0)
            leftWidth = leftFrame.size.width
            left.frame = leftFrame
        }
        
        var rightWidth : CGFloat = 0
        if let right = rightItem {
            var rightFrame = right.frame
            rightFrame.size.height = self.frame.size.height
            rightFrame.origin = CGPoint(x: self.frame.size.width - rightFrame.size.width, y: 0)
            rightWidth = rightFrame.size.width
            right.frame = rightFrame
        }
        
        scrollView.frame = CGRect(x: leftWidth, y: 0, width: self.frame.size.width - leftWidth - rightWidth, height: self.frame.size.height)
        setupTitleLabelsFrame()
    }
}

// MARK: - 监听事件
extension TLMenuView {
    @objc private func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 取出用户点击的View
        let targetLabel = tapGes.view as! TLMenuLabel
        
        // 调整title
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        // 调整bottomLine
        UIView.animate(withDuration: 0.25, animations: {
            var bottomLineFrame = self.bottomLine.frame
            bottomLineFrame.size.width = targetLabel.frame.size.width - 10
            self.bottomLine.frame = bottomLineFrame
            
            var ct = self.bottomLine.center
            ct.x = targetLabel.center.x
            self.bottomLine.center = ct
        })
        
        // 通知代理
        delegate?.menuView(self, targetIndex: currentIndex)
    }
    
    private func adjustTitleLabel(targetIndex : Int) {
        // 1.取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        if targetIndex == currentIndex {
            if targetIndex == 0 {
                targetLabel.textColor = configuration.menuItemSelectedColor
                targetLabel.currentScale = 1.03
            }
            return
        }
        
        
        
        // 2.切换文字的颜色
        targetLabel.textColor = configuration.menuItemSelectedColor
        sourceLabel.textColor = configuration.menuItemColor
        sourceLabel.currentScale = 1.0
        targetLabel.currentScale = 1.03
        
        // 调整bottomLine
        UIView.animate(withDuration: 0.25, animations: {
            var bottomLineFrame = self.bottomLine.frame
            bottomLineFrame.size.width = targetLabel.frame.size.width - 10
            self.bottomLine.frame = bottomLineFrame
            
            var ct = self.bottomLine.center
            ct.x = targetLabel.center.x
            self.bottomLine.center = ct
        })
        
        // 3.记录下标值
        currentIndex = targetIndex
        
        // 4.调整位置
        // 当前偏移量
        var offsetX = targetLabel.center.x - scrollView.frame.size.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        // 最大偏移量
        var maxOffsetX = scrollView.contentSize.width - scrollView.frame.size.width
        
        if maxOffsetX < 0 {
            maxOffsetX = 0
        }
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

// MARK: - 遵守 TLPageViewDelegate
extension TLMenuView: TLPageViewDelegate {
    func pageView(_ pageView: TLPageView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
}
