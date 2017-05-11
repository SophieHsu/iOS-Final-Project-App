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
    let eventStore = EKEventStore()
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var calendarsTableView: UITableView!
    @IBAction func BacktoHome(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
    }
    
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
            refreshTableView()
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
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
    
    func refreshTableView() {
        calendarsTableView.isHidden = false
        calendarsTableView.reloadData()
    }
    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(openSettingsUrl!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "Unknown Calendar Name"
        }
        
        return cell
    }
}
extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2017 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let currentDateString = formatter.string(from: Date())
        let cellStateDateString = formatter.string(from: cellState.date)
        
        // Setup Cell text
        cell.dateLabel.text = cellState.text
        
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
}
