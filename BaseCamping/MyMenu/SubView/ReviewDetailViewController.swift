//
//  ReviewDetailViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/28.
//

import UIKit
import Cosmos

class ReviewDetailViewController: UIViewController {

    var reviewData: Review?
    var reviewImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var facilityRate: CosmosView!
    @IBOutlet weak var serviceRate: CosmosView!
    @IBOutlet weak var accessRate: CosmosView!
    @IBOutlet weak var revisitRate: CosmosView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoView()
    }
    
    func setInfoView() {
        guard let reviewData = self.reviewData else { return }
        guard let reviewImage = self.reviewImage else { return }
        imageView.image = reviewImage
        placeNameLabel.text = reviewData.placeInfo?.name
        placeTypeLabel.text = reviewData.placeInfo?.inDuty
        guard let doName = reviewData.placeInfo?.doName else { return }
        guard let sigunguName = reviewData.placeInfo?.sigunguName else { return }
        addressLabel.text = "\(doName) \(sigunguName)"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yy.MM.dd"
        let convertedDate = dateFormatter.string(from: reviewData.regDate)
        dateLabel.text = convertedDate
        facilityRate.rating = reviewData.facilitySatisfaction
        serviceRate.rating = reviewData.serviceSatisfaction
        accessRate.rating = reviewData.accessibility
        revisitRate.rating = reviewData.revisitWill
        reviewTitleLabel.text = reviewData.title
        reviewContentLabel.text = reviewData.content
    }
    

    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        // 얼럿 띄우고
        // 삭제
        
        self.dismiss(animated: true, completion: nil)
    }
}
