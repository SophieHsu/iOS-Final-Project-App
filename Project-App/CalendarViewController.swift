//
//  CalendarViewController.swift
//  Project-App
//
//  Created by Sophie Hsu on 04/05/2017.
//  Copyright © 2017 Erin Zhang. All rights reserved.

import UIKit
import JTAppleCalendar
import EventKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let formatter = DateFormatter()
    var calendars: [EKCalendar]?
    var events: [EKEvent]?
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func BacktoHome(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCalendarView()
        loadCalendars()
        loadEvents(date: Date())
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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
            loadCalendars()
            loadEvents(date: Date())
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            needPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    self.loadEvents(date: Date())
                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
    }
    
    func refreshTableView() {
        tableView.isHidden = false
        tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //formatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! calendarTableViewCell
        
        //title of calendar event
        cell.eventTitle?.text = events?[(indexPath as NSIndexPath).row].title
        
        //start date of calendar event
        let cellStartDate = events?[(indexPath as NSIndexPath).row].startDate
        var newDateFormate = formatter.string(from: cellStartDate!)
        cell.startTime?.text = newDateFormate
        
        //end date of calendar event
        let cellEndDate = events?[(indexPath as NSIndexPath).row].endDate
        newDateFormate = formatter.string(from: cellEndDate!)
        cell.endTime?.text = newDateFormate
        
        //location of calendar event
        cell.eventLocation?.text = events?[(indexPath as NSIndexPath).row].structuredLocation?.title
        
        return cell
    }
    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.openURL(openSettingsUrl!)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2017 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday)
        
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let currentDateString = formatter.string(from: Date())
        let cellStateDateString = formatter.string(from: cellState.date)
        
        // Setup Cell text
        cell.dateLabel.text = cellState.text
        
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        }else{
            cell.selectedView.isHidden = true
        }
        
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
            if currentDateString == cellStateDateString {
                cell.dateLabel.textColor = UIColor.blue
            }
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
        switch cellState.dateSection().month {
        case 1:
            monthLabel.text = "January"
            break
        case 2:
            monthLabel.text = "February"
            break
        case 3:
            monthLabel.text = "March"
            break
        case 4:
            monthLabel.text = "April"
            break
        case 5:
            monthLabel.text = "May"
            break
        case 6:
            monthLabel.text = "June"
            break
        case 7:
            monthLabel.text = "July"
            break
        case 8:
            monthLabel.text = "Augest"
            break
        case 9:
            monthLabel.text = "September"
            break
        case 10:
            monthLabel.text = "October"
            break
        case 11:
            monthLabel.text = "November"
            break
        case 12:
            monthLabel.text = "December"
            break
        default:
            break
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = false
        let selectedDate = cellState.date
        loadEvents(date: selectedDate)
        refreshTableView()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = true
    }
}
