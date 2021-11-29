//
//  ReviewListViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/28.
//

import UIKit
import RealmSwift
import Kingfisher
import Toast

class ReviewListViewController: UIViewController {
    let localRealm = try! Realm()
    var reviewList: Results<Review>?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: ReviewCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reviewList = localRealm.objects(Review.self)
        collectionView.reloadData()
    }
    
    func loadImageFromDocuments(imageName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent("images").appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        return nil
    }
}

extension ReviewListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reviewData = reviewList else { return 0 }
        return reviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        guard let reviewData = reviewList else { return UICollectionViewCell() }
        let row = reviewData[indexPath.row]
        cell.imageView.image = loadImageFromDocuments(imageName: "\(row._id).jpg")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yy.MM.dd"
        let convertedDate = dateFormatter.string(from: row.regDate)
        
        cell.dateLabel.text = convertedDate
        cell.nameLabel.text = row.placeInfo?.name
        cell.doLabel.text = row.placeInfo?.doName
        cell.sigunguLabel.text = row.placeInfo?.sigunguName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reviewData = reviewList else { return }
        let row = reviewData[indexPath.row]
        let storyboard = UIStoryboard(name: "MyMenu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReviewDetailViewController") as! ReviewDetailViewController
        vc.reviewData = row
        vc.reviewImage = loadImageFromDocuments(imageName: "\(row._id).jpg")
        vc.btnActionHandler = {
            self.collectionView.reloadData()
            self.view.makeToast("삭제 완료!")
        }
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 3 - 2.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
