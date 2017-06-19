//
//  TemperatureViewController.swift
//  Project-App
//
//  Created by erin on 2017/5/24.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController, UISearchBarDelegate,MKMapViewDelegate {
    
    
    
    @IBAction func DoneButton(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var degree: Int!
    var condition: String!
    var imgURL: String!
    var city: String!
    var defaltStr:String!

    
    var exists: Bool = true

    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 產生CLLocationManager，並要求授權
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        defaultWeather()
        searchBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultWeather (){
        defaltStr = "Taipei"
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=3c4b229e07cf47f2b8e172349172405&q=\(defaltStr.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let current = json["current"] as? [String : AnyObject] {
                        
                        if let temp = current["temp_c"] as? Int {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String : AnyObject] {
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imgURL = "http:\(icon)"
                        }
                    }
                    if let location = json["location"] as? [String : AnyObject] {
                        self.city = location["name"] as! String
                    }
                    
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    
                    DispatchQueue.main.async {
                        if self.exists{
                            self.degreeLbl.isHidden = false
                            self.conditionLbl.isHidden = false
                            self.imgView.isHidden = false
                            self.degreeLbl.text = "\(self.degree.description)°C"
                            self.cityLbl.text = self.city
                            self.conditionLbl.text = self.condition
                            self.imgView.downloadImage(from: self.imgURL!)
                        }else {
                            self.degreeLbl.isHidden = true
                            self.conditionLbl.isHidden = true
                            self.imgView.isHidden = true
                            self.cityLbl.text = "No matching city found"
                            self.exists = true
                        }
                    }
                    
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        
        task.resume()

    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=3c4b229e07cf47f2b8e172349172405&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let current = json["current"] as? [String : AnyObject] {
                        
                        if let temp = current["temp_c"] as? Int {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String : AnyObject] {
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imgURL = "http:\(icon)"
                        }
                    }
                    if let location = json["location"] as? [String : AnyObject] {
                        self.city = location["name"] as! String
                    }
                    
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    
                    DispatchQueue.main.async {
                        if self.exists{
                            self.degreeLbl.isHidden = false
                            self.conditionLbl.isHidden = false
                            self.imgView.isHidden = false
                            self.degreeLbl.text = "\(self.degree.description)°C"
                            self.cityLbl.text = self.city
                            self.conditionLbl.text = self.condition
                            self.imgView.downloadImage(from: self.imgURL!)
                        }else {
                            self.degreeLbl.isHidden = true
                            self.conditionLbl.isHidden = true
                            self.imgView.isHidden = true
                            self.cityLbl.text = "No matching city found"
                            self.exists = true
                        }
                    }
                    
                    
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
            }
        }
        
        task.resume()
        
    }
    
    
    
}


