//
//  DetailAttractionCollectionViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/12.
//

import UIKit

class DetailAttractionCollectionViewCell: UICollectionViewCell {

    static let identifier = "DetailAttractionCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

