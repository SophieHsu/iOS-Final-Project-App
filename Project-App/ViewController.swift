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
    let formatter = DateFormatter()
    var calendars: [EKCalendar]?
    var events: [EKEvent]?
    
    @IBOutlet weak var needPermissionView: UIView!
    
    @IBAction func Todo(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TodoViewController"){
            show(vc,sender: self)
        }
    }
    @IBAction func FoodPickerButton(_ sender: UIButton) {
        if let vc2 = storyboard?.instantiateViewController(withIdentifier: "FoodViewController"){
            show(vc2,sender: self)
        }
    }
    
    @IBAction func CalendarBtn(_ sender: UIButton) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCalendars()
        loadEvents(date: Date())
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
                    self.loadCalendars()
                    print("in")
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
    
    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
    }
    
    func loadEvents(date: Date) {
        // Create a date formatter instance to use for converting a string to a date
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        // Create start and end date NSDate instances to build a predicate for which events to select
        let today = formatter.string(from: date)
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let tomorrow = formatter.string(from: tomorrowDate!)
        let startDate = formatter.date(from: today)
        let endDate = formatter.date(from: tomorrow)
        if let startDate = startDate, let endDate = endDate {
            let eventStore = EKEventStore()
            
            // Use an event store instance to create and properly configure an NSPredicate
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
            
            // Use the configured NSPredicate to find and return events in the store that match
            self.events = eventStore.events(matching: eventsPredicate).sorted(){
                (e1: EKEvent, e2: EKEvent) -> Bool in
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
        }
    }
    
    @IBAction func speechBtn(sender: UIButton)
    {
        textToSpeech()
    }
    
    @IBAction func textToSpeech(sender: UIButton)
    {
        textToSpeech()
    }
    
    func textToSpeech() {
        formatter.dateFormat = "hh:mm"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        var textStr = GreetingText.text!
        let zero = 0
        textStr = textStr + "You have \((events?.count)!) events today, starting with "
        for var i in zero..<(events?.count)! {
            let eventTitle = (events?[i].title)!
            let eventStartDate = (events?[i].startDate)!
            let eventStartTime = formatter.string(from: eventStartDate)
            textStr = textStr + eventTitle + " at " + eventStartTime + ", "
        }
        utterance = AVSpeechUtterance(string: textStr)
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }

    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(openSettingsUrl!)
    }
    
}
