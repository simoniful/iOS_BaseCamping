//
//  ReviewCollectionViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/28.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReviewCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doLabel: UILabel!
    @IBOutlet weak var sigunguLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
