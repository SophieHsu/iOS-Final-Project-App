//
//  TripViewController.swift
//  Project-App
//
//  Created by erin on 2017/5/22.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,FoodCollectionCellDelegate{

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBAction func BackButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
    }
    @IBAction func mapButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GoogleMapViewController"){
            show(vc,sender: self)
        }
        
    }
    @IBAction func locationButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController"){
            show(vc,sender: self)
        }
        
    }
    fileprivate var foods = [Food(foodId: "韓式",country: "Korea", featuredImage: UIImage(named: "paris"), price: 2000, isLiked: false),
                         Food(foodId: "中式",country: "China", featuredImage: UIImage(named: "rome"), price: 800, isLiked: false),
                         Food(foodId: "日式", country: "Japan", featuredImage: UIImage(named: "istanbul"), price: 2200, isLiked: false),
                         Food(foodId: "美式", country: "US", featuredImage: UIImage(named: "london"), price: 3000, isLiked: false),
                         Food(foodId: "others", country: "Others", featuredImage: UIImage(named: "sydney"), price: 2500, isLiked: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "foodbackground")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        //backgroundImageView.addSubview(blurEffectView)
        
        collectionView.backgroundColor = UIColor.clear
        
        // Change the height for 3.5-inch screen
        
        if UIScreen.main.bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 300.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    

    
    // MARK: - UICollectionView Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FoodCollectionCell
        
        // Configure the cell
        cell.countryLabel.text = foods[indexPath.row].country
        cell.imageView.image = foods[indexPath.row].featuredImage
        cell.priceLabel.text = "$\(String(foods[indexPath.row].price))"
        cell.isLiked = foods[indexPath.row].isLiked
        cell.delegate = self
        
        // Apply round corner
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    
    // MARK: - FoodCollectionCellDelegate Methods
    
    func didLikeButtonPressed(_ cell: FoodCollectionCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            foods[indexPath.row].isLiked = foods[indexPath.row].isLiked ? false : true
            cell.isLiked = foods[indexPath.row].isLiked
        }
        
        
    }
}
