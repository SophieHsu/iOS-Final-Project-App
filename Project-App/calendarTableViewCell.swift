//
//  calendarTableViewCell.swift
//  Project-App
//
//  Created by Sophie Hsu on 12/05/2017.
//  Copyright © 2017 Erin Zhang. All rights reserved.
//

import UIKit

class calendarTableViewCell: UITableViewCell {
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
