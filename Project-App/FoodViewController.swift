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
    
    fileprivate var foods = [Food(foodId: "Paris001",country: "France", featuredImage: UIImage(named: "paris"), price: 2000, isLiked: false),
                         Food(foodId: "Rome001",country: "Italy", featuredImage: UIImage(named: "rome"), price: 800, isLiked: false),
                         Food(foodId: "Istanbul001", country: "Turkey", featuredImage: UIImage(named: "istanbul"), price: 2200, isLiked: false),
                         Food(foodId: "London001", country: "United Kingdom", featuredImage: UIImage(named: "london"), price: 3000, isLiked: false),
                         Food(foodId: "Sydney001", country: "Australia", featuredImage: UIImage(named: "sydney"), price: 2500, isLiked: false),
                         Food(foodId: "Santorini001",country: "Greece", featuredImage: UIImage(named: "santorini"), price: 1800, isLiked: false),
                         Food(foodId: "NewYork001", country: "United States", featuredImage: UIImage(named: "newyork"), price: 900, isLiked: false),
                         Food(foodId: "Kyoto001", country: "Japan", featuredImage: UIImage(named: "kyoto"), price: 1000, isLiked: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "foodbackground")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        collectionView.backgroundColor = UIColor.clear
        
        // Change the height for 3.5-inch screen
        /*
        if UIScreen.main.bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 300.0)
        }*/
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
