//
//  TLMenuLabel.swift
//  PageMenuCustom
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 江苏天下网商科技有限公司. All rights reserved.
//

import UIKit

class TLMenuLabel: UILabel {
    /// 用来记录当前 label 的缩放比例
    var currentScale: CGFloat = 1.0 {
        didSet {
            transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        }
    }
}
