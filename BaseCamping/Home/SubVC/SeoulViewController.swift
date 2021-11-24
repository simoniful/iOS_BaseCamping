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

class SeoulViewController: UIViewController {
    let localRealm = try! Realm()
    var placeDataList: [PlaceInfo]?
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var weatherInFoData: [WeatherInfo] = [] {
        didSet {
            weatherCollectionView.reloadData()
        }
    }
   
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
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.delegate = self
        pagerView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.hidesForSinglePage = true
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        let height = 195 * (round(Double(placeDataList!.count / 2))) + 10
        collectionView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        let nibName = UINib(nibName: HomeViewSubCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: HomeViewSubCollectionViewCell.identifier)
        let weatherNibName = UINib(nibName: HomeViewWeatherCollectionViewCell.identifier, bundle: nil)
        weatherCollectionView.register(weatherNibName, forCellWithReuseIdentifier: HomeViewWeatherCollectionViewCell.identifier)
        fetchWeatherInfo()
    }
    
    @objc func fetchWeatherInfo() {
        let url = "\(Endpoint.weatherURL)?lat=\(String(describing: WeatherStation.locationDic["서울특별시"]![0]))&lon=\(String(describing: WeatherStation.locationDic["서울특별시"]![1]))&exclude=current,minutely,hourly,alerts&appid=\(APIKey.weather)&units=metric&lang=kr"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["daily"].arrayValue.map({
                    WeatherInfo(
                        date: $0["dt"].intValue,
                        minTemp: $0["temp"]["min"].doubleValue,
                        maxTemp: $0["temp"]["max"].doubleValue,
                        weatherIcon: $0["weather"].arrayValue[0]["icon"].stringValue,
                        weather: $0["weather"].arrayValue[0]["description"].stringValue)
                })
                self.weatherInFoData = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SeoulViewController: FSPagerViewDelegate,FSPagerViewDataSource {
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
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        pageControl.currentPage = index
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
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

extension SeoulViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = placeDataList else { return 0 }
        
        return collectionView == weatherCollectionView ? weatherInFoData.count : data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weatherCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewWeatherCollectionViewCell.identifier, for: indexPath) as? HomeViewWeatherCollectionViewCell else { return UICollectionViewCell() }
            let item = weatherInFoData[indexPath.row]
            let convertDate = Date(timeIntervalSince1970: TimeInterval(item.date))
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd"
            formatter.locale = Locale(identifier: "ko")
            cell.dayLabel.text = formatter.string(from: convertDate)
            let url = URL(string: "\(Endpoint.weatherIconURL)/\(item.weatherIcon)@2x.png")
            cell.iconImage.kf.setImage(with: url)
            // cell.tempLabel.text = "\(item.minTemp) / \(item.maxTemp)"
            cell.layer.cornerRadius = 4
            return cell
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == weatherCollectionView {
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 5
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            let cellWidth = (width - widthPadding) / itemsPerRow
            let cellHeight: CGFloat = 90
            return CGSize(width: cellWidth, height: cellHeight)
        }
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 2
            let widthPadding = sectionInsets.left * (itemsPerRow + 1)
            let cellWidth = (width - widthPadding) / itemsPerRow
            let cellHeight: CGFloat = 185
            return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}

