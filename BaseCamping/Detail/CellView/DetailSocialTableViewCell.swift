//
//  DetailSocialTableViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/24.
//

import UIKit

class DetailSocialTableViewCell: UITableViewCell {
    static let identifier = "DetailSocialTableViewCell"
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
