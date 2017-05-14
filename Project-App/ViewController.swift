//
//  ViewController.swift
//  Project-App
//
//  Created by erin on 2017/4/30.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit
import EventKit
import AVFoundation

class ViewController: UIViewController {
    let eventStore = EKEventStore()
    let speechSynthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    
    @IBOutlet weak var needPermissionView: UIView!
    
    @IBAction func Todo(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TodoViewController"){
            show(vc,sender: self)
        }
    }
    
    @IBAction func Calendar(_ sender: UIButton) {
        if let vc3 = storyboard?.instantiateViewController(withIdentifier: "CalendarVC"){
            show(vc3,sender: self)
        }
    }
    
    @IBAction func Setting(_ sender: UIButton) {
        if let vc5 = storyboard?.instantiateViewController(withIdentifier: "SettingVC"){
            show(vc5,sender: self)
        }
    }
    
    @IBOutlet weak var GreetingText: UILabel!
    
    @IBAction func speechBtn(sender: UIButton)
    {
        utterance = AVSpeechUtterance(string: GreetingText.text!)
        utterance.rate = 0.3
        speechSynthesizer.speak(utterance)
    }

    @IBAction func textToSpeech(sender: UIButton)
    {
        utterance = AVSpeechUtterance(string: GreetingText.text!)
        utterance.rate = 0.3
        speechSynthesizer.speak(utterance)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
//            loadCalendars()
//            refreshTableView()
            break
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            needPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
//                    self.loadCalendars()
//                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
//    func loadCalendars() {
//        self.calendars = eventStore.calendars(for: EKEntityType.event)
//    }
//    
//    func refreshTableView() {
//        calendarsTableView.isHidden = false
//        calendarsTableView.reloadData()
//    }
    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(openSettingsUrl!)
    }
    
}
