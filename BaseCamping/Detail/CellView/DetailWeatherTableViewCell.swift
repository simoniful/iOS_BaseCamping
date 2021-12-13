//
//  DetailWeatherTableViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/02.
//

import UIKit

class DetailWeatherTableViewCell: UITableViewCell {
    static let identifier = "DetailWeatherTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
