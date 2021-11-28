//
//  LikedPlaceCollectionViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/28.
//

import UIKit

class LikedPlaceCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LikedPlaceCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
