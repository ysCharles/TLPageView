//
//  TLPageViewOption.swift
//  PageMenuCustom
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 江苏天下网商科技有限公司. All rights reserved.
//

import UIKit

public enum TLPageViewOption {
    case menuHeight(CGFloat)
    
    case menuBottmonLineHeight(CGFloat)
    case menuBottomLineColor(UIColor)
    
    case menuItemFont(UIFont)
    case menuItemColor(UIColor)
    case menuItemSelectedColor(UIColor)
    case menuItemMargin(CGFloat)
    
    case leftItem(UIView)
    case rightItem(UIView)
    
    case separatorLineColor(UIColor)
    case separatorLineHeight(CGFloat)
    
    case menuBackgroundColor(UIColor)
}
