//
//  HomeViewSubCollectionViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/19.
//

import UIKit

class HomeViewSubCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeViewSubCollectionViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.layer.cornerRadius = 7.5
    }

}
