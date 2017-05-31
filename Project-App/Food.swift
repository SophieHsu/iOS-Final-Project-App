//
//  Food.swift
//  Project-App
//
//  Created by erin on 2017/5/22.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import Foundation
import UIKit

class Food {
    var foodId = ""
    var country = ""
    var featuredImage:UIImage?
    var price:Int = 0
    var isLiked = false
    
    init(foodId: String, country: String, featuredImage: UIImage!, price: Int, isLiked: Bool) {
        self.foodId = foodId
        self.country = country
        self.featuredImage = featuredImage
        self.price = price
        self.isLiked = isLiked
    }
}
