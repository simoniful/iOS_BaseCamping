//
//  HomeViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/17.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class HomeViewController: UIViewController {
//    let localRealm = try! Realm()
//
//    @IBOutlet weak var tabMenuCollectionView: UICollectionView!
//    @IBOutlet weak var scrollView: UIScrollView!
//
//    let seoulVC = HomeSubViewController()
//    let gyeonggiVC = GyeonggiViewController()
//    let incheonVC = IncheonViewController()
//    let jejuVC = JejuViewController()
//    let sejongVC = SeJongViewController()
//    let gyeongsangnamVC = GyeongsangnamViewController()
//    let gyeongsangbukVC = GyeongsangbukViewController()
//    let jeollanamVC = JeollanamViewController()
//    let jeollabukVC = JeollabukViewController()
//    let gwanjuVC = GwanjuViewController()
//    let ulsanVC = UlsanViewController()
//    let busanVC = BusanViewController()
//    let daeguVC = DaeguViewController()
//    let chungcheongnamVC = ChungcheongnamViewController()
//    let chungcheongbukVC = ChungcheongbukViewController()
//    let daejeonVC = DaejeonViewController()
//    let gangwonVC = GangwonViewController()
//
//    var tabSelectedIndex: Int = 0
//    let tabList: [String] = ["서울", "경기", "인천", "강원", "대전", "광주", "대구", "부산", "울산", "제주", "세종", "충북", "충남", "경북", "경남", "전북", "전남"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadToLocalJson()
//        setCollectionView()
//        setScrollView()
//        // print("Realm is located at", localRealm.configuration.fileURL!)
//    }
//
//    func randomPlaces(list: Results<PlaceInfo>, num: Int) -> [PlaceInfo] {
//        var places:[PlaceInfo] = []
//        while places.count < num {
//            let number = Int.random(in: 0...list.count - 1)
//            let randomPlace = list[number]
//            if !places.contains(randomPlace){ places.append(randomPlace) }
//        }
//        return places
//    }
//
//    func setScrollView() {
//        scrollView.delegate = self
//        scrollView.contentSize.width = self.view.frame.width * 16
//
//        self.addChild(seoulVC)
//        seoulVC.placeDataList = randomPlaces(list: localRealm.objects(PlaceInfo.self).filter("doName == '서울특별시' AND imageURL != ''"), num: 7)
//        guard let seoulView = seoulVC.view else { return }
//        seoulView.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(gyeonggiVC)
//        gyeonggiVC.placeDataList = randomPlaces(list: localRealm.objects(PlaceInfo.self).filter("doName == '경기도' AND imageURL != ''" ), num: 16)
//        guard let gyeonggiView = gyeonggiVC.view else { return }
//        gyeonggiView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(incheonVC)
//        guard let incheonView = incheonVC.view else { return }
//        incheonView.frame = CGRect(x: self.view.frame.width * 2, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(gangwonVC)
//        guard let gangwonView = gangwonVC.view else { return }
//        gangwonView.frame = CGRect(x: self.view.frame.width * 3, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(daejeonVC)
//        guard let daejeonView = daejeonVC.view else { return }
//        daejeonView.frame = CGRect(x: self.view.frame.width * 4, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(gwanjuVC)
//        guard let gwanjuView = gwanjuVC.view else { return }
//        gwanjuView.frame = CGRect(x: self.view.frame.width * 5, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(daeguVC)
//        guard let daeguView = daeguVC.view else { return }
//        daeguView.frame = CGRect(x: self.view.frame.width * 6, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(busanVC)
//        guard let busanView = busanVC.view else { return }
//        busanView.frame = CGRect(x: self.view.frame.width * 7, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(ulsanVC)
//        guard let ulsanView = ulsanVC.view else { return }
//        ulsanView.frame = CGRect(x: self.view.frame.width * 8, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(jejuVC)
//        guard let jejuView = jejuVC.view else { return }
//        jejuView.frame = CGRect(x: self.view.frame.width * 9, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(sejongVC)
//        guard let sejongView = sejongVC.view else { return }
//        sejongView.frame = CGRect(x: self.view.frame.width * 10, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(chungcheongbukVC)
//        guard let chungcheongbukVeiw = chungcheongbukVC.view else { return }
//        chungcheongbukVeiw.frame = CGRect(x: self.view.frame.width * 11, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(chungcheongnamVC)
//        guard let chungcheongnamView = chungcheongnamVC.view else { return }
//        chungcheongnamView.frame = CGRect(x: self.view.frame.width * 12, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(gyeongsangbukVC)
//        guard let gyeongsangbukView = gyeongsangbukVC.view else { return }
//        gyeongsangbukView.frame = CGRect(x: self.view.frame.width * 13, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(gyeongsangnamVC)
//        guard let gyeongsangnamView = gyeongsangnamVC.view else { return }
//        gyeongsangnamView.frame = CGRect(x: self.view.frame.width * 14, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(jeollabukVC)
//        guard let jeollabukView = jeollabukVC.view else { return }
//        jeollabukView.frame = CGRect(x: self.view.frame.width * 15, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        self.addChild(jeollanamVC)
//        guard let jeollanamView = jeollanamVC.view else { return }
//        jeollanamView.frame = CGRect(x: self.view.frame.width * 16, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//        scrollView.addSubviews([seoulView, gyeonggiView, incheonView, gangwonView, daejeonView, gwanjuView, daeguView, busanView, ulsanView, jejuView, sejongView, chungcheongbukVeiw, chungcheongnamView, gyeongsangbukView, gyeongsangnamView, jeollabukView, jeollanamView ])
//
//    }
//
//    func setCollectionView () {
//        tabMenuCollectionView.delegate = self
//        tabMenuCollectionView.dataSource = self
//        tabMenuCollectionView.isPagingEnabled = true
//    }
//
//    @objc func loadToLocalJson ()  {
//        try! self.localRealm.write {
//            self.localRealm.delete(localRealm.objects(PlaceInfo.self))
//        }
//
//        if let url = Bundle.main.url(forResource: "goCampingData", withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url, options: .mappedIfSafe)
//                let json = try JSON(data: data)
//                let schemaData = json["response"]["body"]["items"]["item"].arrayValue.map {
//                    PlaceInfo(contentId: $0["contentId"].intValue,
//                                         name: $0["facltNm"].stringValue,
//                                         address: $0["addr1"].stringValue,
//                                         doName: $0["doNm"].stringValue,
//                                         sigunguName: $0["sigunguNm"].stringValue,
//                                         latitude: $0["mapY"].doubleValue,
//                                         longitude: $0["mapX"].doubleValue,
//                                         tel: $0["tel"].stringValue,
//                                         lineIntro: $0["lineIntro"].stringValue,
//                                         intro: $0["intro"].stringValue,
//                                         homepage: $0["homepage"].stringValue,
//                                         petAccess: $0["animalCmgCl"].stringValue,
//                                         operatingPeriod: $0["operPdCl"].stringValue,
//                                         operatingDay: $0["operDeCl"].stringValue,
//                                         toiletCount: $0["toiletCo"].intValue,
//                                         showerCount: $0["swrmCo"].intValue,
//                                         facility: $0["sbrsCl"].stringValue,
//                                         inDuty: $0["induty"].stringValue,
//                                         prmisnDe: $0["prmisnDe"].stringValue,
//                                         insurance: $0["insrncAt"].stringValue,
//                                         imageURL: $0["firstImageUrl"].stringValue,
//                                         isLiked: false)
//                }
//                schemaData.forEach { place in
//                    try! localRealm.write {
//                        localRealm.add(place)
//                    }
//                }
//            } catch {
//                print("불러오기를 실패했습니다")
//            }
//        }
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return tabList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        if indexPath.row != tabSelectedIndex {
//                cell.setStatus(name: tabList[indexPath.row], isTouched: false)
//            }
//            else {
//                cell.setStatus(name: tabList[indexPath.row], isTouched: true)
//            }
//        cell.menuTitleLabel.text = tabList[indexPath.row]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            tabSelectedIndex = 0
//            scrollView.setContentOffset(CGPoint.zero, animated: true)
//        case 1:
//            tabSelectedIndex = 1
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width, y: 0), animated: true)
//        case 2:
//            tabSelectedIndex = 2
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 2, y: 0), animated: true)
//        case 3:
//            tabSelectedIndex = 3
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 3, y: 0), animated: true)
//        case 4:
//            tabSelectedIndex = 4
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 4, y: 0), animated: true)
//        case 5:
//            tabSelectedIndex = 5
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 5, y: 0), animated: true)
//        case 6:
//            tabSelectedIndex = 6
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 6, y: 0), animated: true)
//        case 7:
//            tabSelectedIndex = 7
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 7, y: 0), animated: true)
//        case 8:
//            tabSelectedIndex = 8
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 8, y: 0), animated: true)
//        case 9:
//            tabSelectedIndex = 9
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 9, y: 0), animated: true)
//        case 10:
//            tabSelectedIndex = 10
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 10, y: 0), animated: true)
//        case 11:
//            tabSelectedIndex = 11
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 11, y: 0), animated: true)
//        case 12:
//            tabSelectedIndex = 12
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 12, y: 0), animated: true)
//        case 13:
//            tabSelectedIndex = 13
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 13, y: 0), animated: true)
//        case 14:
//            tabSelectedIndex = 14
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 14, y: 0), animated: true)
//        case 15:
//            tabSelectedIndex = 15
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 15, y: 0), animated: true)
//        case 16:
//            tabSelectedIndex = 16
//            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * 16, y: 0), animated: true)
//        default:
//            break
//        }
//
//        tabMenuCollectionView.reloadData()
//    }

}
