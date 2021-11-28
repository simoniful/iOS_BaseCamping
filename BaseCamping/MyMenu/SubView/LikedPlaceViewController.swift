//
//  LikedPlaceViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/28.
//

import UIKit
import RealmSwift
import Kingfisher

class LikedPlaceViewController: UIViewController {
    let localRealm = try! Realm()
    var likedPlaceList: Results<PlaceInfo>?
    let sectionInsets = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: LikedPlaceCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: LikedPlaceCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedPlaceList = localRealm.objects(PlaceInfo.self).filter("isLiked == true")
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension LikedPlaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataList = likedPlaceList else { return 0 }
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataList = likedPlaceList else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedPlaceCollectionViewCell.identifier, for: indexPath) as? LikedPlaceCollectionViewCell else { return UICollectionViewCell() }
        
        let item = dataList[indexPath.row]
        if let urlString = item.imageURL {
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
        }
        cell.titleLabel.text = item.name
        let slicedAddress = item.address.components(separatedBy: " ")
        cell.addressLabel.text = "\(slicedAddress[0]) \(slicedAddress[1]) \(slicedAddress[2])"
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataList = likedPlaceList else { return }
        let item = dataList[indexPath.row]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.placeInfo = item
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight: CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
