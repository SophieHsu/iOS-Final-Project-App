//
//  FoodCollectionViewCell.swift
//  Project-App
//
//  Created by erin on 2017/5/22.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit

protocol FoodCollectionCellDelegate {
    func didLikeButtonPressed(_ cell: FoodCollectionCell)
}

class FoodCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var countryLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    
    @IBOutlet weak var likeButton:UIButton!
    
    var delegate:FoodCollectionCellDelegate?
    
    var isLiked:Bool = false  {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage(named: "heartfull"), for: UIControlState())
            } else {
                likeButton.setImage(UIImage(named: "heart"), for: UIControlState())
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: AnyObject) {
        delegate?.didLikeButtonPressed(self)
    }

}
