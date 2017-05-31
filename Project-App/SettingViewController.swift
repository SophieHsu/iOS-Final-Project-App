//
//  SettingViewController.swift
//  Project-App
//
//  Created by Sophie Hsu on 05/05/2017.
//  Copyright © 2017 Erin Zhang. All rights reserved.
//

import UIKit
class SettingViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var speakingSpeed: UISlider!
    @IBAction func BacktoHome(_ sender: UIButton) {
        if let vc2 = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc2,sender: self)
        }
    }
    @IBAction func Done(_ sender: UIButton) {
        defaults.set(userName.text, forKey: "username")
        defaults.set(speakingSpeed.value, forKey: "speakingSpeed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = defaults.string(forKey: "username") {
            userName.text = name;
        }
        if let speed = defaults.string(forKey: "speakingSpeed") {
            speakingSpeed.value = Float(speed)!;
        }
        // Do any additional setup after loading the view.
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        URLCache.shared.removeAllCachedResponses()
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
