//
//  WeatherDetailTVCell.swift
//  WeatherPS
//
//  Created by PS on 4/29/17.
//  Copyright © 2017 PS. All rights reserved.
//

import UIKit

class WeatherDetailTVCell: UITableViewCell {

  //  @IBOutlet weak var date: UIView!
    
    @IBOutlet weak var date: UILabel!

    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var conditions: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
