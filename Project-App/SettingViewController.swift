//
//  SettingViewController.swift
//  Project-App
//
//  Created by Sophie Hsu on 05/05/2017.
//  Copyright © 2017 Erin Zhang. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBAction func BacktoHome(_ sender: UIButton) {
        if let vc2 = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc2,sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
