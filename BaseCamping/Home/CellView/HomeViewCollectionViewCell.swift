//
//  HomeViewCollectionViewCell.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/17.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuTitleLabel.font = UIFont.systemFont(ofSize: 20)
        menuTitleLabel.textColor = .systemGray3
    }
    func setStatus(name : String, isTouched : Bool) {
        menuTitleLabel.textColor = isTouched ? .white : .systemGray3
        menuTitleLabel.font = isTouched ? UIFont.boldSystemFont(ofSize: 20) : UIFont.systemFont(ofSize: 20)
        menuTitleLabel.text = name
    }
}

