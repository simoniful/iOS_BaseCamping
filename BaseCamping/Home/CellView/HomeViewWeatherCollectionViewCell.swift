//
//  HomeViewWeatherCollectionViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/19.
//

import UIKit

class HomeViewWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeViewWeatherCollectionViewCell"
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    // @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
