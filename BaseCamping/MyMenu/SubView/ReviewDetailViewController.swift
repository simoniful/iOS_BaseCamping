//
//  ReviewDetailViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/28.
//

import UIKit
import RealmSwift
import Cosmos

class ReviewDetailViewController: UIViewController {

    let localRealm = try! Realm()
    var reviewData: Review?
    var reviewImage: UIImage?
    var btnActionHandler: (() -> ())?
    
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
    @IBOutlet weak var reviewContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        reviewContentTextView.text = reviewData.content
        reviewContentTextView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4);
    }
    
    func deleteImageInDocuments(imageName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageURL = documentDirectory.appendingPathComponent("images").appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지 삭제 실패")
            }
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "리뷰를 삭제하시겠습니까?", message: "삭제된 리뷰는 복구할 수 없습니다", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction!) in
            guard let reviewData = self.reviewData else { return }
            guard let btnActionHandler = self.btnActionHandler else { return }
            self.deleteImageInDocuments(imageName: "\(reviewData._id).jpg")
            try! self.localRealm.write {
                self.localRealm.delete(reviewData)
            }
            btnActionHandler()
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
