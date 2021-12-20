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
import Toast

class DetailViewController: UIViewController {
    let localRealm = try! Realm()
    var placeInfo: PlaceInfo?
    var downloadedImageURLs: [String] = [] {
        didSet {
            if downloadedImageURLs.count == 0 {
                pagerView.isHidden = true
                bannerPlaceholderImageView.isHidden = false
            } else {
                pagerView.isHidden = false
                bannerPlaceholderImageView.isHidden = true
            }
            pagerView.reloadData()
        }
    }
    var socialMediaDataList: [SocialMediaInfo] = []
    let locationManager = CLLocationManager()
    var weatherInFoData: [WeatherInfo] = [] {
        didSet {
            weatherTableView.reloadData()
        }
    }
    var isInfoOpened: Bool = true
    var socialTableHeightAnchor:NSLayoutConstraint!
    var isLiked = false

    @IBOutlet weak var bannerPlaceholderImageView: UIImageView!
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
    @IBOutlet weak var telTextView: UITextView!
    @IBOutlet weak var homepageTextView: UITextView!
    @IBOutlet weak var insuranceLabel: UILabel!
    @IBOutlet weak var petLabel: UILabel!
    @IBOutlet weak var operatingPeriod: UILabel!
    @IBOutlet weak var operatingDayLabel: UILabel!
    @IBOutlet weak var facilityLabel: UILabel!
    @IBOutlet weak var primsnDeLabel: UILabel!
    @IBOutlet weak var showerCountLabel: UILabel!
    @IBOutlet weak var toiletCountLabel: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var subAddrLabel: UILabel!
    @IBOutlet weak var socialTableView: UITableView!
    @IBOutlet weak var attractionView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "attractionContainer" {
            let containerVC = segue.destination as! DetailAttractionTabmanViewController
            containerVC.placeInfo = self.placeInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetailImages()
        
        title = "상세정보"
        guard let likeData = placeInfo?.isLiked else { return }
        isLiked = likeData
        let likeBtnImage = isLiked == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeBtn.setImage(likeBtnImage, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.hidesForSinglePage = true
        pageControl.contentHorizontalAlignment = .right
        locationManager.delegate = self
        
        nameLabel.text = placeInfo?.name
        addressLabel.text = placeInfo?.address
        typeLabel.text = placeInfo?.inDuty
        telTextView.text = placeInfo?.tel == "" ? "검색필요" : placeInfo?.tel
        telTextView.textContainerInset = UIEdgeInsets(top: 7, left: 5, bottom: 4, right: 4)
        homepageTextView.text = placeInfo?.homepage == "" ? "검색필요" : placeInfo?.homepage
        homepageTextView.textContainerInset = UIEdgeInsets(top: 6, left: 5, bottom: 4, right: 4)
        
        insuranceLabel.text = placeInfo?.insurance == "Y" ? "가입" : "미가입"
        petLabel.text = placeInfo?.petAccess
        operatingPeriod.text = placeInfo?.operatingPeriod
        operatingDayLabel.text = placeInfo?.operatingDay
        showerCountLabel.text = "\(String(describing: placeInfo!.showerCount))개"
        toiletCountLabel.text = "\(String(describing: placeInfo!.toiletCount))개"
        facilityLabel.text = placeInfo?.facility == "" ? "연락문의" : placeInfo?.facility
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
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        let weatherNibName = UINib(nibName: DetailWeatherTableViewCell.identifier, bundle: nil)
        weatherTableView.register(weatherNibName, forCellReuseIdentifier: DetailWeatherTableViewCell.identifier)
    
        socialTableView.delegate = self
        socialTableView.dataSource = self
        
        let nibName = UINib(nibName: DetailSocialTableViewCell.identifier, bundle: nil)
        socialTableView.register(nibName, forCellReuseIdentifier: DetailSocialTableViewCell.identifier)
        
        let headerNibName = UINib(nibName: DetailSocialTableViewHeader.identifier, bundle: nil)
        socialTableView.register(headerNibName, forHeaderFooterViewReuseIdentifier: DetailSocialTableViewHeader.identifier)
        socialTableHeightAnchor = socialTableView.constraints.filter({
            $0.identifier == "socialTableViewHeight"
        }).first
        
        if #available(iOS 15.0, *) {
            socialTableView.sectionHeaderTopPadding = 0
        }
    }
    
    @objc func closeBtnClicked () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func fetchWeatherInfo() {
        guard let placeInfo = placeInfo else { return }
        let url = "\(Endpoint.weatherURL)?lat=\(placeInfo.latitude)&lon=\(placeInfo.longitude)&exclude=current,minutely,hourly,alerts&appid=\(APIKey.weather)&units=metric&lang=kr"
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
                self.fetchNaverBlogData()
            case .failure(let error):
                print(error)
            }
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
                self.fetchWeatherInfo()
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
                let data = json["items"].arrayValue.map({
                    SocialMediaInfo(type: "naverBlog", title: self.changeHtmlTag(input: $0["title"].stringValue), link: $0["link"].stringValue, description: self.changeHtmlTag(input: $0["description"].stringValue))
                })
                let newData = self.socialMediaDataList + data
                self.socialMediaDataList = newData
                self.fetchYoutubeData()
            case .failure(let error):
                print(error)
                let urlString = "https://section.blog.naver.com/Search/Post.naver?pageNo=1&rangeType=ALL&orderBy=sim&keyword=\(self.placeInfo!.name)"
                let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let data = [SocialMediaInfo(type: "youtube", title: "\(self.placeInfo!.name)", link: encodedURL, description: "블로그 검색 결과창으로 이동")]
                self.socialMediaDataList = self.socialMediaDataList + data
                self.socialTableHeightAnchor.constant = 240
                self.socialTableView.reloadData()
                self.fetchYoutubeData()
                // GCD, dispatch group
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
                let data = json["items"].arrayValue.map({
                    SocialMediaInfo(type: "youtube", title: $0["snippet"]["title"].stringValue, link: "https://www.youtube.com/watch?v=" + $0["id"]["videoId"].stringValue, description: $0["snippet"]["description"].stringValue)
                })
                self.socialMediaDataList = self.socialMediaDataList + data
                self.socialTableView.reloadData()
            case .failure(let error):
                print(error)
                let urlString = "https://www.youtube.com/results?search_query=\(self.placeInfo!.name)"
                let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let data = [SocialMediaInfo(type: "youtube", title: "\(self.placeInfo!.name)", link: encodedURL, description: "YouTube 검색 결과창으로 이동")]
                let newData = self.socialMediaDataList + data
                self.socialMediaDataList = newData
                self.socialTableHeightAnchor.constant = 240
                self.socialTableView.reloadData()
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
    
    @IBAction func reviewBtnClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
        vc.placeInfo = self.placeInfo
        vc.btnActionHandler = {
            self.view.makeToast("저장 완료!")
        }
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        isLiked = !isLiked
        if isLiked == true {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            try! self.localRealm.write {
                placeInfo?.isLiked = true
            }
            self.view.makeToast("Liked!")
        } else {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            try! self.localRealm.write {
                placeInfo?.isLiked = false
            }
            self.view.makeToast("Unliked!")
        }
    }
    
    func changeHtmlTag(input: String) -> String {
        let convertStr = input
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#035;", with: "#")
            .replacingOccurrences(of: "&#039;", with: "\'")
        return convertStr
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
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let item =  downloadedImageURLs[index]
        let url = URL(string: item)
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ZoomPictureViewController") as! ZoomPictureViewController
        vc.pictureURL = url
        self.navigationController?.pushViewController(vc, animated: true)
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


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == socialTableView {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == socialTableView {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailSocialTableViewHeader.identifier) as? DetailSocialTableViewHeader else { return UITableViewHeaderFooterView() }
            header.titleLabel.text = section == 0 ? "네이버 블로그" : "YouTube"
            return header
        } else {
            return UITableViewHeaderFooterView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == socialTableView {
            return 32
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == socialTableView {
            return section == 0 ? socialMediaDataList.filter{$0.type == "naverBlog"}.count : socialMediaDataList.filter{$0.type == "youtube"}.count
        } else {
            return weatherInFoData.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == socialTableView {
            return 44
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == socialTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailSocialTableViewCell.identifier, for: indexPath) as? DetailSocialTableViewCell else {
                return UITableViewCell()}
            let blog = socialMediaDataList.filter{$0.type == "naverBlog"}.count == 1 ? socialMediaDataList.filter{$0.type == "naverBlog"}[0] : socialMediaDataList.filter{$0.type == "naverBlog"}[indexPath.row]
            let youtube = socialMediaDataList.filter{$0.type == "youtube"}.count == 1 ? socialMediaDataList.filter{$0.type == "youtube"}[0] : socialMediaDataList.filter{$0.type == "youtube"}[indexPath.row]
            
            if indexPath.section == 0 {
                cell.logoImage.image = UIImage(named: "blogLogo")
                cell.titleLabel.text = blog.title
                cell.descLabel.text = blog.description
            } else if indexPath.section == 1 {
                cell.logoImage.image = UIImage(named: "youtube")
                cell.titleLabel.text = youtube.title
                cell.descLabel.text = youtube.description
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailWeatherTableViewCell.identifier, for: indexPath) as? DetailWeatherTableViewCell else {
                return UITableViewCell()}
            let row = weatherInFoData[indexPath.row]
            let convertDate = Date(timeIntervalSince1970: TimeInterval(row.date))
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd"
            formatter.locale = Locale(identifier: "ko")
            cell.dateLabel.text = formatter.string(from: convertDate)
            let url = URL(string: "\(Endpoint.weatherIconURL)/\(row.weatherIcon)@2x.png")
            cell.iconImage.kf.setImage(with: url)
            cell.layer.cornerRadius = 4
            cell.maxTempLabel.text = "최대: \(row.maxTemp)℃"
            cell.minTempLabel.text = "최소: \(row.minTemp)℃"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == socialTableView {
            let blog = socialMediaDataList.filter{$0.type == "naverBlog"}[indexPath.row]
            let youtube = socialMediaDataList.filter{$0.type == "youtube"}[indexPath.row]
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.mediaData = indexPath.section == 0 ? blog : youtube
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}





