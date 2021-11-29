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
            pagerView.reloadData()
        }
    }
    var socialMediaDataList: [SocialMediaInfo] = []
    let locationManager = CLLocationManager()
    var isInfoOpened: Bool = true
    var infoContainerViewHeightAnchor:NSLayoutConstraint!
    var socialTableHeightAnchor:NSLayoutConstraint!
    var isLiked = false

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
    @IBOutlet weak var likeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "상세정보"
        guard let likeData = placeInfo?.isLiked else { return }
        isLiked = likeData
        let likeBtnImage = isLiked == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeBtn.setImage(likeBtnImage, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        fetchDetailImages()
        
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.hidesForSinglePage = true
        locationManager.delegate = self
        
        nameLabel.text = placeInfo?.name
        addressLabel.text = placeInfo?.address
        typeLabel.text = placeInfo?.inDuty
        telTextView.text = placeInfo?.tel
        telTextView.centerVertically()
        homepageTextView.text = placeInfo?.homepage
        homepageTextView.centerVertically()
        
        infoContainerViewHeightAnchor = infoContainerView.heightAnchor.constraint(equalToConstant: 500)
        infoContainerViewHeightAnchor.isActive = true
        
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

        socialTableView.delegate = self
        socialTableView.dataSource = self
        
        socialTableHeightAnchor = socialTableView.heightAnchor.constraint(equalToConstant: 352)
        socialTableHeightAnchor.isActive = true
        
        let nibName = UINib(nibName: DetailSocialTableViewCell.identifier, bundle: nil)
        socialTableView.register(nibName, forCellReuseIdentifier: DetailSocialTableViewCell.identifier)
        
        let headerNibName = UINib(nibName: DetailSocialTableViewHeader.identifier, bundle: nil)
        socialTableView.register(headerNibName, forHeaderFooterViewReuseIdentifier: DetailSocialTableViewHeader.identifier)
        
        if #available(iOS 15.0, *) {
            socialTableView.sectionHeaderTopPadding = 0
        }
    }
    
    @objc func closeBtnClicked () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleBtnClicked(_ sender: UIButton) {
        isInfoOpened = !isInfoOpened
        if isInfoOpened == true {
            toggleBtn.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
            informationStack.isHidden = false
            infoContainerViewHeightAnchor.constant = 500
        } else {
            toggleBtn.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
            informationStack.isHidden = true
            infoContainerViewHeightAnchor.constant = 80
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
                let data = json["items"].arrayValue.map({
                    SocialMediaInfo(type: "naverBlog", title: self.changeHtmlTag(input: $0["title"].stringValue), link: $0["link"].stringValue, description: self.changeHtmlTag(input: $0["description"].stringValue))
                })
                
                self.socialMediaDataList = self.socialMediaDataList + data
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
                self.socialMediaDataList = self.socialMediaDataList + data
                self.socialTableHeightAnchor.constant = 264
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailSocialTableViewHeader.identifier) as? DetailSocialTableViewHeader else { return UITableViewHeaderFooterView() }
        header.titleLabel.text = section == 0 ? "네이버 블로그" : "YouTube"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? socialMediaDataList.filter{$0.type == "naverBlog"}.count : socialMediaDataList.filter{$0.type == "youtube"}.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailSocialTableViewCell.identifier, for: indexPath) as? DetailSocialTableViewCell else {
            return UITableViewCell()}
        let blog = socialMediaDataList.filter{$0.type == "naverBlog"}[indexPath.row]
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blog = socialMediaDataList.filter{$0.type == "naverBlog"}[indexPath.row]
        let youtube = socialMediaDataList.filter{$0.type == "youtube"}[indexPath.row]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.mediaData = indexPath.section == 0 ? blog : youtube
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}



