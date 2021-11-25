//
//  ByRegionViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/17.
//

import UIKit
import RealmSwift
import Kingfisher

class ByRegionViewController: UIViewController {
    @IBOutlet weak var doNameBtn: UIButton!
    @IBOutlet weak var sigunguBtn: UIButton!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    
    let localRealm = try! Realm()
    var searchResultList: Results<PlaceInfo>?
    var selectedDo: String? = "서울특별시"
    var selectedSigungu: String? = "전체"
    var selectedType: String? = "일반야영장"
    var doQuery: String = "doName == '서울시'"
    var sigunguQuery: String = ""
    var typeQuery: String = "AND inDuty CONTAINS '일반야영장'"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        let nibName = UINib(nibName: SearchResultTableViewCell.identifier, bundle: nil)
        resultTableView.register(nibName, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        
        searchResultList = localRealm.objects(PlaceInfo.self).filter("doName == '서울시'  AND inDuty CONTAINS '일반야영장'")
    }
    
    @IBAction func doNameBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "광역지방자치단체 선택", message: "도, 광역시, 특별자치시 단위 행정구역을 선택해주세요", preferredStyle: .alert)
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as? PickerViewController else {
            print("PickerVC에 오류가 있음")
            return
        }
        contentView.preferredContentSize.height = 120
        contentView.pickerList = Array(Region.regionDic.keys)
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            let value = contentView.selectedRow
            self.selectedDo = value
            self.doNameBtn.setTitle(value, for: .normal)
            if let value = value {
                self.doQuery = "doName == '\(value)'"
            }
            print(self.doQuery)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alert.setValue(contentView, forKey: "contentViewController")
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sigunguBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "기초지방자치단체 선택", message: "시, 군, 구 단위 행정구역을 선택해주세요", preferredStyle: .alert)
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as? PickerViewController else {
            print("PickerVC에 오류가 있음")
            return
        }
        contentView.preferredContentSize.height = 120
        contentView.pickerList = Region.regionDic[selectedDo!]
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            let value = contentView.selectedRow
            self.selectedSigungu = value
            if let value = value {
                if value == "전체" {
                    self.sigunguQuery = ""
                    self.sigunguBtn.setTitle(value, for: .normal)
                } else {
                    self.sigunguQuery = "AND sigunguName == '\(value)'"
                    self.sigunguBtn.setTitle(value, for: .normal)
                }
            }
            
            print(self.sigunguQuery)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alert.setValue(contentView, forKey: "contentViewController")
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func typeBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "캠핑장 종류 선택", message: "일반야영장, 자동차야영장, 카라반, 글램핑 중 선택해주세요", preferredStyle: .alert)
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as? PickerViewController else {
            print("PickerVC에 오류가 있음")
            return
        }
        contentView.preferredContentSize.height = 120
        contentView.pickerList = ["일반야영장", "자동차야영장", "카라반", "글램핑"]
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            let value = contentView.selectedRow
            self.selectedType = value
            self.typeBtn.setTitle(value, for: .normal)
            if let value = value {
                self.typeQuery = "AND inDuty CONTAINS '\(value)'"
            }
            print(self.typeQuery)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alert.setValue(contentView, forKey: "contentViewController")
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        searchResultList = localRealm.objects(PlaceInfo.self).filter("\(doQuery) \(sigunguQuery) \(typeQuery)")
        self.resultTableView.reloadData()
    }
}

extension ByRegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchResultList = self.searchResultList else { return 0 }
        return searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()}
        guard let searchResultList = self.searchResultList else { return UITableViewCell() }
        let row = searchResultList[indexPath.row]
        let url = URL(string: row.imageURL!)
        cell.placeImage.kf.setImage(with: url)
        cell.addressLabel.text = row.address
        cell.nameLabel.text = row.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

