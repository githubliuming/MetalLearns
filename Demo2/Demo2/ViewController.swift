//
//  ViewController.swift
//  Demo2
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var displayView :QYDisplayView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.displayView = QYDisplayView.init(frame: self.view.bounds)
        self.view.addSubview(self.displayView!)
    }


}

