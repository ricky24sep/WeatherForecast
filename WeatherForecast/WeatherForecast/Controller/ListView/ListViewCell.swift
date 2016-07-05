//
//  ListViewCell.swift
//  WeatherForecast
//
//  Created by rikky.chavhan on 01/07/16.
//  Copyright © 2016 globallogic. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var descriptionLabel : UILabel?
    @IBOutlet weak var dateLabel : UILabel?
    @IBOutlet weak var posterImageView : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
