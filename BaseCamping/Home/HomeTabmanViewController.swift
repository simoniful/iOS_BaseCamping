//
//  HomeTabmanViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/26.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Tabman
import Pageboy

class HomeTabmanViewController: TabmanViewController {
    let localRealm = try! Realm()
    let regionList = ["서울특별시", "경기도", "인천광역시", "강원도", "대전광역시", "광주광역시", "대구광역시", "부산광역시", "울산광역시", "제주특별자치도", "세종특별자치시", "충청북도", "충청남도", "경상북도", "경상남도", "전라북도", "전라남도"]
    let tabList: [String] = ["서울", "경기", "인천", "강원", "대전", "광주", "대구", "부산", "울산", "제주", "세종", "충북", "충남", "경북", "경남", "전북", "전남"]
    
    private var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstOpen ()
        regionList.forEach { place in
            let placeVc = setVC(placeName: place)
            viewControllers.append(placeVc)
        }
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        addBar(bar, dataSource: self, at: .top)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    @objc func checkFirstOpen () {
        print("checkFirstOpen")
        let ud = UserDefaults.standard
        if ud.object(forKey: "isFirstOpenBaseCamping") == nil {
            loadToLocalJson ()
        }
    }
    
    @objc func loadToLocalJson ()  {
        try! self.localRealm.write {
            self.localRealm.delete(localRealm.objects(PlaceInfo.self))
        }
        
        if let url = Bundle.main.url(forResource: "goCampingData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let json = try JSON(data: data)
                let schemaData = json["response"]["body"]["items"]["item"].arrayValue.map {
                    PlaceInfo(contentId: $0["contentId"].intValue,
                                         name: $0["facltNm"].stringValue,
                                         address: $0["addr1"].stringValue,
                                         doName: $0["doNm"].stringValue,
                                         sigunguName: $0["sigunguNm"].stringValue,
                                         latitude: $0["mapY"].doubleValue,
                                         longitude: $0["mapX"].doubleValue,
                                         tel: $0["tel"].stringValue,
                                         lineIntro: $0["lineIntro"].stringValue,
                                         intro: $0["intro"].stringValue,
                                         homepage: $0["homepage"].stringValue,
                                         petAccess: $0["animalCmgCl"].stringValue,
                                         operatingPeriod: $0["operPdCl"].stringValue,
                                         operatingDay: $0["operDeCl"].stringValue,
                                         toiletCount: $0["toiletCo"].intValue,
                                         showerCount: $0["swrmCo"].intValue,
                                         facility: $0["sbrsCl"].stringValue,
                                         inDuty: $0["induty"].stringValue,
                                         prmisnDe: $0["prmisnDe"].stringValue,
                                         insurance: $0["insrncAt"].stringValue,
                                         imageURL: $0["firstImageUrl"].stringValue,
                                         keyword: "\($0["exprnProgrm"].stringValue),\($0["themaEnvrnCl"].stringValue),\( $0["posblFcltyCl"].stringValue),\($0["sbrsCl"].stringValue)",
                                         isLiked: false
                    )
                }
                schemaData.forEach { place in
                    try! localRealm.write {
                        localRealm.add(place)
                    }
                }
                let ud = UserDefaults.standard
                ud.set(false, forKey: "isFirstOpenBaseCamping")
                ud.synchronize()
            } catch {
                print("불러오기를 실패했습니다")
            }
        }
    }
    
    func randomPlaces(list: Results<PlaceInfo>) -> [PlaceInfo] {
        var places:[PlaceInfo] = []
        let num: Int = list.count > 16 ? 16 : list.count
        while places.count < num {
            let number = Int.random(in: 0...list.count - 1)
            let randomPlace = list[number]
            if !places.contains(randomPlace){ places.append(randomPlace) }
        }
        return places
    }
    
    func setVC (placeName: String) -> UIViewController {
        let instanceVC = HomeSubViewController()
        instanceVC.placeName = placeName
        instanceVC.placeDataList = randomPlaces(list: localRealm.objects(PlaceInfo.self).filter("doName == '\(placeName)' AND imageURL != ''"))
        return instanceVC
    }
}

extension HomeTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = tabList[index]
        return item
    }
    
    
}
