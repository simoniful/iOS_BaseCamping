//
//  SeoulViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import FSPagerView
import RealmSwift

class HomeSubViewController: UIViewController {
    let localRealm = try! Realm()
    var placeDataList: [PlaceInfo]?
    var placeName: String?
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
   
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.isInfinite = true
            self.pagerView.automaticSlidingInterval = 6.0
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.delegate = self
        pagerView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.hidesForSinglePage = true
        pageControl.contentHorizontalAlignment = .right
        if let placeDataList = placeDataList {
            let adjustCount = placeDataList.count < 6 ? 6 : placeDataList.count
            let evenCal = 175 * (floor(Double(adjustCount / 2))) + 10
            let oddCal = 175 * (floor(Double(adjustCount / 2)) + 1) + 10
            let height = adjustCount % 2 == 0 ? evenCal : oddCal
            collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        let nibName = UINib(nibName: HomeViewSubCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: HomeViewSubCollectionViewCell.identifier)
    }
    
    @IBAction func moreBtnClicked(_ sender: UIButton) {
        guard let tabBarController = tabBarController else { return }
        tabBarController.selectedViewController = tabBarController.viewControllers![1]
    }
}

extension HomeSubViewController: FSPagerViewDelegate,FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        pageControl.numberOfPages = placeDataList!.count
        return placeDataList!.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let item = placeDataList![index]
        let url = URL(string: item.imageURL!)
        cell.imageView?.kf.setImage(with: url)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.textLabel?.text = item.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        pageControl.currentPage = index
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pagerView {
            let page = scrollView.contentOffset.x / scrollView.frame.width
            pageControl.currentPage = Int(page)
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let item = placeDataList![index]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.placeInfo = item
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension HomeSubViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = placeDataList else { return 0 }
        
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewSubCollectionViewCell.identifier, for: indexPath) as? HomeViewSubCollectionViewCell else { return UICollectionViewCell() }
        let item = placeDataList![indexPath.row]
        cell.layer.cornerRadius = 10
        if let urlString = item.imageURL {
            let url = URL(string: urlString)
            cell.itemImageView.kf.setImage(with: url)
        }
        cell.nameLabel.text = item.name
        let slicedAddress = item.address.components(separatedBy: " ")
        cell.addressLabel.text = "\(slicedAddress[0]) \(slicedAddress[1]) \(slicedAddress[2])"
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let item = placeDataList![indexPath.row]
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.placeInfo = item
            let nav =  UINavigationController(rootViewController: vc)
            nav.modalTransitionStyle = .coverVertical
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight: CGFloat = 165
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}


