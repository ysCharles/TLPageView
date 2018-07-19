//
//  DemoController.swift
//  Exampel
//
//  Created by Charles on 2018/7/12.
//  Copyright © 2018 Charles. All rights reserved.
//

import UIKit

class DemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let desc = UILabel()
        desc.text = self.title
        desc.frame = CGRect(x: 50, y: 200, width: 100, height: 30)
        view.addSubview(desc)
        
        
        let btn = UIButton(type: .custom)
        btn.setTitle("点击 push", for: .normal)
        btn.addTarget(self, action: #selector(pushClick), for: .touchUpInside)
        btn.frame = CGRect(x: 50, y: 100, width: 90 , height: 60)
        view.addSubview(btn)

        // Do any additional setup after loading the view.
    }

    @objc private func pushClick() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        vc.navigationItem.title = "push title"
        navigationController?.show(UIViewController(), sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear == " + (navigationItem.title ?? ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear == " + (navigationItem.title ?? ""))

    }

}
