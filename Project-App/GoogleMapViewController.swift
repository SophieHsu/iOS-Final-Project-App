//
//  GoogleMapViewController.swift
//  Project-App
//
//  Created by erin on 2017/5/24.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class GoogleMapViewController: UIViewController,GMSAutocompleteViewControllerDelegate{
    var placesClient: GMSPlacesClient!
    
    @IBAction func BackButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
    }
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
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

