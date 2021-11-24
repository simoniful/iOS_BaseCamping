//
//  DetailViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/17.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import FSPagerView
import RealmSwift
import MapKit

class DetailViewController: UIViewController {
    var placeInfo: PlaceInfo?
    var downloadedImageURLs: [String] = [] {
        didSet {
            pagerView.reloadData()
        }
    }
    let locationManager = CLLocationManager()
    var isInfoOpened: Bool = true

    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.isInfinite = true
            self.pagerView.automaticSlidingInterval = 6.0
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var informationStack: UIStackView!
    @IBOutlet weak var insuranceLabel: UILabel!
    @IBOutlet weak var petLabel: UILabel!
    @IBOutlet weak var operatingPeriod: UILabel!
    @IBOutlet weak var operatingDayLabel: UILabel!
    @IBOutlet weak var facilityLabel: UILabel!
    @IBOutlet weak var primsnDeLabel: UILabel!
    @IBOutlet weak var showerCountLabel: UILabel!
    @IBOutlet weak var toiletCountLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var subAddrLabel: UILabel!
    @IBOutlet weak var socialTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "상세정보"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnClicked))
        
        fetchDetailImages()
        
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.hidesForSinglePage = true
        locationManager.delegate = self
        
        nameLabel.text = placeInfo?.name
        addressLabel.text = placeInfo?.address
        typeLabel.text = placeInfo?.inDuty
        telLabel.text = placeInfo?.tel
        homepageLabel.text = placeInfo?.homepage
        
        insuranceLabel.text = placeInfo?.insurance == "Y" ? "가입" : "미가입"
        petLabel.text = placeInfo?.petAccess
        operatingPeriod.text = placeInfo?.operatingPeriod
        operatingDayLabel.text = placeInfo?.operatingDay
        showerCountLabel.text = "\(String(describing: placeInfo!.showerCount))개"
        toiletCountLabel.text = "\(String(describing: placeInfo!.toiletCount))개"
        facilityLabel.text = placeInfo?.facility
        primsnDeLabel.text = placeInfo?.prmisnDe
        
        let location = CLLocationCoordinate2D(latitude: placeInfo!.latitude, longitude: placeInfo!.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = placeInfo?.name
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        subAddrLabel.text = placeInfo?.address
        
        fetchNaverBlogData()
        fetchYoutubeData()
        
        scrollView.updateContentSize()
        
//        socialTableView.delegate = self
//        socialTableView.dataSource = self
    }
    
    @objc func closeBtnClicked () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleBtnClicked(_ sender: UIButton) {
        isInfoOpened = !isInfoOpened
        if isInfoOpened == true {
            toggleBtn.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
            informationStack.isHidden = false
            infoContainerView.heightAnchor.constraint(equalToConstant: 510).isActive = true
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1863)
            
        } else {
            toggleBtn.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
            informationStack.isHidden = true
            infoContainerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1433)
        }
    }
    
    
    @objc func fetchDetailImages() {
        guard let placeInfo = placeInfo else {return}
        let url = "\(Endpoint.goCampingImageURL)?serviceKey=\(APIKey.goCamping)&MobileOS=IOS&MobileApp=BaseCamping&contentId=\(placeInfo.contentId)&_type=json"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["response"]["body"]["items"]["item"].arrayValue.map({
                    $0["imageUrl"].stringValue
                })
                self.downloadedImageURLs = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func fetchNaverBlogData() {
        guard let placeInfo = placeInfo else {return}
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.navetBlogId,
            "X-Naver-Client-Secret": APIKey.naverBlogSecret
        ]
        
        let urlString = "\(Endpoint.naverBlogURL)?query=\(placeInfo.name)&display=3"
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodedURL, method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func fetchYoutubeData() {
        guard let placeInfo = placeInfo else {return}
        let urlString = "\(Endpoint.youtubeURL)?part=snippet&key=\(APIKey.youtube)&q=\(placeInfo.name)&maxResults=3&type=video&videoEmbeddable=true"
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodedURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json, "youtube data")
            case .failure(let error):
                print(error, "youtube data")
            }
        }
    }
    
    @objc func goSetting() {
        let alert = UIAlertController(title: "위치 권한 설정이 되어 있지 않습니다.", message: "앱 설정 화면으로 이동하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: {(action: UIAlertAction!) -> Void in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(ok)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
}

extension DetailViewController: FSPagerViewDelegate,FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        pageControl.numberOfPages = downloadedImageURLs.count
        return downloadedImageURLs.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let item =  downloadedImageURLs[index]
        let url = URL(string: item)
        cell.imageView?.kf.setImage(with: url)
        cell.imageView?.contentMode = .scaleAspectFill
        pageControl.currentPage = index
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
}

extension DetailViewController : CLLocationManagerDelegate {
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요")
            goSetting()
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("Denied, 설정 유도")
            goSetting()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            print("Always")
        @unknown default:
            print("Default")
        }
        
        if #available(iOS 14.0, *) {
            let accurancyState = locationManager.accuracyAuthorization
            switch accurancyState {
            case .fullAccuracy:
                print("Full")
            case .reducedAccuracy:
                print("Reduce")
            @unknown default:
                print("Default")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("여기있어요!")
    }
}



