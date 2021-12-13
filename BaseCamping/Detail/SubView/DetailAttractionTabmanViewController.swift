//
//  DetailAttractionTabmanViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Tabman
import Pageboy

class DetailAttractionTabmanViewController: TabmanViewController {
    var placeInfo: PlaceInfo?
    var menuList = ["관광지", "문화시설", "축제/행사", "레져", "맛집", "쇼핑"]
    private var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isScrollEnabled = false
        menuList.forEach { place in
            let vc = setVC(data: place)
            viewControllers.append(vc)
        }
        self.configTabbar()
    
    }
    
    func configTabbar() {
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        bar.heightAnchor.constraint(equalToConstant: 32).isActive = true
        bar.backgroundView.style = .clear
        bar.buttons.customize { (button) in
            button.selectedTintColor =  UIColor(red: 165, green: 185, blue: 171)
            button.contentInset = UIEdgeInsets(top: 0.0, left: 4, bottom: 0.0, right: 4)
        }
        bar.indicator.overscrollBehavior = .compress
        bar.indicator.weight = .medium
        bar.indicator.tintColor = UIColor(red: 185, green: 205, blue: 191)
        addBar(bar, dataSource: self, at: .top)
    }
    
    func setVC (data: String) -> UIViewController {
        guard let placeInfo = placeInfo else { return UIViewController() }
        let instanceVC = DetailAttractionSubViewController()
        instanceVC.typeName = data
        instanceVC.placeInfo = placeInfo
        return instanceVC
    }
}

extension DetailAttractionTabmanViewController: TMBarDataSource, PageboyViewControllerDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = menuList[index]
        return item
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
