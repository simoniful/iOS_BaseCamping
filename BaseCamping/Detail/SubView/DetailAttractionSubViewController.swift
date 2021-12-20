//
//  DetailAttractionSubViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/08.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class DetailAttractionSubViewController: UIViewController {
    var attractionData: [AttractionInfo] = []
    var typeName: String?
    var placeInfo: PlaceInfo?
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    @IBOutlet weak var attractionCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let typeName = typeName else { return }
        fetchAttractionData(attractionType: typeName) { list in
            guard let list = list else { return }
            self.attractionData = list
            self.attractionCollectionView.reloadData()
        }
        attractionCollectionView.delegate = self
        attractionCollectionView.dataSource = self
        let nibName = UINib(nibName: DetailAttractionCollectionViewCell.identifier, bundle: nil)
        attractionCollectionView.register(nibName, forCellWithReuseIdentifier: DetailAttractionCollectionViewCell.identifier)
    }
    
    func fetchAttractionData(attractionType: String, completionHnadler: @escaping (_ list: [AttractionInfo]?) -> ()) {
        
        guard let placeInfo = placeInfo else { return }
        guard let typeNum = AttractionType.attrationTypeDic[attractionType] else { return }
        let url = "\(Endpoint.attractionURL)?serviceKey=\(APIKey.attraction)&numOfRows=15&pageNo=1&MobileOS=IOS&MobileApp=BaseCamping&arrange=E&contentTypeId=\(typeNum)&mapX=\(placeInfo.longitude)&mapY=\(placeInfo.latitude)&radius=10000&listYN=Y&_type=json"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["response"]["body"]["items"]["item"].arrayValue.map {
                    AttractionInfo(
                        contentTypeId: $0["contenttypeid"].intValue,
                        contentId: $0["contentid"].intValue,
                        title: $0["title"].stringValue,
                        thumbImgUrl: $0["firstimage"].stringValue,
                        distance: $0["dist"].intValue
                    )
                }
                completionHnadler(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DetailAttractionSubViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attractionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAttractionCollectionViewCell.identifier, for: indexPath) as? DetailAttractionCollectionViewCell else { return UICollectionViewCell() }
        let item = attractionData[indexPath.row]
        let url = URL(string: item.thumbImgUrl)
        cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder"))
        cell.titleLabel.text = item.title
        let decimal = Double(item.distance) / 1000
        cell.distanceLabel.text = item.distance > 1000 ? String(format: "%.1f", decimal) + "km" : String(item.distance) + "m"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 2.5
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight: CGFloat = 145
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let typeName = typeName else { return }
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let item = attractionData[indexPath.row]
        let vc = storyboard.instantiateViewController(withIdentifier: "AttractionDetailViewController") as! AttractionDetailViewController
        vc.attractionInfo = item
        vc.typeName = typeName
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
}
