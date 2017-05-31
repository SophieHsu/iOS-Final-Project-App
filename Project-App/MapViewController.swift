//
//  LocationViewController.swift
//  Project-App
//
//  Created by erin on 2017/5/22.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
//import GooglePlaces
//import GoogleMaps
//import GooglePlacePicker

class MapViewController: UIViewController,MKMapViewDelegate {
        
    @IBOutlet weak var myMap: MKMapView!
    
    var locationManager:CLLocationManager!
    @IBAction func BackButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        myMap.delegate = nil
        myMap.removeFromSuperview()
        myMap = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 產生CLLocationManager，並要求授權
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        // 得到座標
        let coordinate = locationManager.location?.coordinate
        
        
        // 經緯度
        //let latitude:CLLocationDegrees = 48.858532
        //let longitude:CLLocationDegrees = 2.294481
        
        // 從經緯度產生座標
        //let coordinate = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
        
        // 直向縮放
        let latDelta:CLLocationDegrees = 0.01
        // 橫向縮放
        let lonDelta:CLLocationDegrees = 0.01
        // 從直向縮放與橫向縮放產生縮放範圍
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        // 讓地圖秀出區域
        if coordinate != nil{
            // set region
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate!, span)
            myMap.setRegion(region, animated: true)
            
            // 設定大頭針
            let annotation = MKPointAnnotation()    //產生大頭針
            annotation.coordinate = coordinate!     //設定大頭針座標
            annotation.title = "Current Location"   //設定大頭針標題
            myMap.addAnnotation(annotation)         //將大頭針新增至地圖
            
        }
        
        
    }
    
    // 長按放置大頭針
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer){
        let touchPoint = sender.location(in: self.myMap)    //的到碰觸點
        let coordinate = myMap.convert(touchPoint, toCoordinateFrom: self.myMap)    //碰觸點轉為座標
        // 設定大頭針
        let annotation = MKPointAnnotation()    //產生大頭針
        annotation.coordinate = coordinate     //設定大頭針座標
        myMap.addAnnotation(annotation)        //將大頭針新增至地圖

    }
    
    
    // 設定大頭針顏色
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //判斷大頭針是否為別的類別
            //如果不是KMPointAnnotation而是MKUserLocation的話
            //就retern離開
            return nil
        }
        
        let identifier = "MyPin"    //新建一個之後來判斷可否回收的標記
        // 試著看看是否有可重複使用的大頭針，如果有的話，存在變數result中
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if result == nil {
            // 如果沒有重複使用的大頭針，則新建一個大頭針並顯示文字
            result = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }else{
            // 如果有的話，設定顯示文字
            result?.annotation = annotation
            
        }
        
        //設定點選可以秀出資訊
        result?.canShowCallout = true

        
        //設定大頭針顏色
        (result as! MKPinAnnotationView).pinTintColor = UIColor.green
        //設定大頭針是否掉下動畫
        (result as! MKPinAnnotationView).animatesDrop = true
        
        // Calloutk的右邊，設定成按鈕
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(MapViewController.buttonPressed(button:)), for: .touchUpInside)
        
        result?.rightCalloutAccessoryView = button
        
        //回傳大頭針
        return result
        
    }
    
    func buttonPressed(button:UIButton){
        myMap.removeAnnotations(myMap.annotations)
    }
    
    func mapView(_ mapView: MKMapView,annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        self.performSegue(withIdentifier: "showDirection", sender: view)
    }
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    @IBOutlet weak var searchText: UITextField!
    @IBAction func searchButton(_ sender: UIButton) {
        _ = sender.resignFirstResponder()
        myMap.removeAnnotations(myMap.annotations)
        self.performSearch()

    }
    
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = myMap.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
          
                    self.myMap.addAnnotation(annotation)
                }
            }
        })
        
    }
    
    
    
    @IBAction func NearbyButton(_ sender: UIButton) {
        //產生一個request
        let request = MKLocalSearchRequest()
        // 設定要搜尋的單詞
        request.naturalLanguageQuery = searchText.text
        // 設定搜尋區域
        request.region = myMap.region
        // 產生MKLocalSearch型別的物件
        let search = MKLocalSearch(request: request)
        // 開使搜尋
        search.start {
            (response: MKLocalSearchResponse?, error: Error?) -> Void in
            if error == nil && response != nil {
                //如果沒有錯誤而且搜尋有結果的話...
                for item in response!.mapItems{
                    //把結果的位置加上大頭針
                    self.myMap.addAnnotation(item.placemark)
                    
                }
            }
        }
    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
