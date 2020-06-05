//
//  TLPageViewConfiguration.swift
//  PageMenuCustom
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 江苏天下网商科技有限公司. All rights reserved.
//

import UIKit

public class TLPageViewConfiguration {
    open var menuHeight : CGFloat = 34.0
    open var menuMargin : CGFloat = 10.0
    
    open var menuItemFont :UIFont = UIFont.systemFont(ofSize: 15)
    open var menuItemColor : UIColor = UIColor.black
    open var menuItemSelectedColor : UIColor = .red
    open var menuItemMargin : CGFloat = 5.0
    
    open var menuBottomLineWidth: CGFloat? = nil
    open var menuBottomLineHeight : CGFloat = 2
    open var menuBottomLineColor : UIColor = .red
    
    open var leftItem :UIView? = nil
    open var rightItem : UIView? = nil
    
    
    open var separatorLineColor : UIColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
    open var separatorLineHeight : CGFloat = 1
    open var menuBackgroundColor: UIColor = .white
    public init() { }
}

public enum TLPageMenuAlignment : Int {
    case left = 1
    case spaceArround = 2
}
