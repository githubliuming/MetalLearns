//
//  ViewController.swift
//  demo1
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var disPlayView:QYDisplayView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.disPlayView = QYDisplayView.init(frame: self.view.frame)
        self.view.addSubview(self.disPlayView!)
    }


}

