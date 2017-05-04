//
//  ViewController.swift
//  Project-App
//
//  Created by erin on 2017/4/30.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func Todo(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TodoViewController"){
            show(vc,sender: self)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

