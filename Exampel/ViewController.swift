//
//  ViewController.swift
//  Exampel
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 Charles. All rights reserved.
//

import UIKit
import TLPageView

class ViewController: UIViewController {
    
    var colors : [UIColor] = [UIColor.yellow,UIColor.red,UIColor.brown,UIColor.blue]
    var titles : [String] = ["不仅仅是喜欢", "歌在飞", "小情歌", "回忆总想哭", "遥远的歌", "双节棍", "叶子", "天空中最亮的星", "稻香", "花桥流水"]
    lazy var rightItem: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        btn .addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.setImage(UIImage(named: "More"), for: .normal)
        btn.setImage(UIImage(named: "More"), for: .highlighted)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        var controllers = [UIViewController]()
        for i in 0..<10{
            let controller = DemoController()
            controller.title = titles[i]//"测试中哈哈哈\(i)"
            controller.view.backgroundColor = colors[i % 4]
            controllers.append(controller)
        }
        
        let pageView = TLPageView(viewControllers: controllers, pageViewOptions: [.menuHeight(50),.menuItemMargin(5), .rightItem(rightItem)])
        view.addSubview(pageView)
        pageView.frame = CGRect(x: 0, y: 88, width: view.frame.size.width, height: view.frame.size.height - 88)
    }

    @objc private func btnClick() {
        print("More button clicked")
    }


}

