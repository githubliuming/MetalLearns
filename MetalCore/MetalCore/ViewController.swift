//
//  ViewController.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    public lazy var dataSoure:[String] = {
        let array:Array<String> = ["BrightnessFilter","Stretch"];
        return array
    }()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
}
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.row {
        case 0:
            print(indexPath.row)
            let filter:ColorFilterViewController = storyBoard.instantiateViewController(withIdentifier: "ColorFilterViewController") as! ColorFilterViewController
            self.present(filter, animated: true) {
                
            }
        case 1:
            print(indexPath.row)
        case 2:
            print(indexPath.row)
        case 3:
            print(indexPath.row)
        default:do {
            break
            }
        }
    }
    
}
extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.dataSoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
        cell.textLabel?.text = self.dataSoure[indexPath.row]
        return cell
        
    }
    
    
}

