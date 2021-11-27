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
    @IBOutlet weak var doNameTextField: UITextField!
    @IBOutlet weak var sigunguTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var noResultView: UIView!
    
    let localRealm = try! Realm()
    var searchResultList: Results<PlaceInfo>?
    
    var selectedDo: String? = "서울특별시"
    var selectedSigungu: String? = "전체"
    var selectedType: String? = "일반야영장"
    
    var doQuery: String = "doName == '서울시'"
    var sigunguQuery: String = ""
    var typeQuery: String = "AND inDuty CONTAINS '일반야영장'"
    
    let doNamePickerView = UIPickerView()
    let sigunguPickerView = UIPickerView()
    let typePickerView = UIPickerView()
    
    let doPickerList = Array(Region.regionDic.keys).sorted(by: <)
    var sigunguPickerList: [String] = []
    let typePickerList: [String] = ["일반야영장", "자동차야영장", "카라반", "글램핑"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        let nibName = UINib(nibName: SearchResultTableViewCell.identifier, bundle: nil)
        resultTableView.register(nibName, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        searchResultList = localRealm.objects(PlaceInfo.self).filter("doName == '서울특별시'  AND inDuty CONTAINS '일반야영장'")
        configPickerView(textField: doNameTextField, pickerView: doNamePickerView, dataList: doPickerList)
        configPickerView(textField: sigunguTextField, pickerView: sigunguPickerView, dataList: sigunguPickerList)
        configPickerView(textField: typeTextField, pickerView: typePickerView, dataList: typePickerList)
    }
    
    func configPickerView (textField: UITextField, pickerView: UIPickerView, dataList: [String]) {
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220)
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        textField.tintColor = .clear
        configToolbar(textField: textField, pickerView: pickerView, dataList: dataList)
    }
    
    func configToolbar(textField: UITextField, pickerView: UIPickerView, dataList: [String]) {
        let toolBar: UIToolbar = {
            let layoutedToolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
            return layoutedToolbar
        }()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker(sender:)))
        if textField == doNameTextField {
            doneBtn.tag = 0
        } else if textField == sigunguTextField {
            doneBtn.tag = 1
        } else {
            doneBtn.tag = 2
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker(sender:)))
        if textField == doNameTextField {
            cancelBtn.tag = 0
        } else if textField == sigunguTextField {
            cancelBtn.tag = 1
        } else {
            cancelBtn.tag = 2
        }
        toolBar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(sender: AnyObject) {
        if let tag = sender.tag {
            if tag == 0 {
                let row = doNamePickerView.selectedRow(inComponent: 0)
                doNamePickerView.selectRow(row, inComponent: 0, animated: false)
                doNameTextField.text = doPickerList[row]
                doNameTextField.resignFirstResponder()
            } else if tag ==  1 {
                let row = sigunguPickerView.selectedRow(inComponent: 0)
                sigunguPickerView.selectRow(row, inComponent: 0, animated: false)
                sigunguTextField.text = sigunguPickerList[row]
                sigunguTextField.resignFirstResponder()
            } else {
                let row = typePickerView.selectedRow(inComponent: 0)
                typePickerView.selectRow(row, inComponent: 0, animated: false)
                typeTextField.text = typePickerList[row]
                typeTextField.resignFirstResponder()
            }
        }
    }
    
    @objc func cancelPicker(sender: AnyObject) {
        if let tag = sender.tag {
            if tag == 0 {
                doNameTextField.text = nil
                sigunguPickerList = []
                doNameTextField.resignFirstResponder()
            } else if tag ==  1 {
                sigunguTextField.text = nil
                sigunguTextField.resignFirstResponder()
            } else {
                typeTextField.text = nil
                typeTextField.resignFirstResponder()
            }
        }
        
    }

    @IBAction func searchBtnClicked(_ sender: UIButton) {
        searchResultList = localRealm.objects(PlaceInfo.self).filter("\(doQuery) \(sigunguQuery) \(typeQuery)")
        self.resultTableView.reloadData()
        guard let searchResultList = searchResultList else { return }
        if searchResultList.count == 0 {
            self.noResultView.isHidden = false
        } else {
            self.noResultView.isHidden = true
        }
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
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchResultList = self.searchResultList else { return }
        let item = searchResultList[indexPath.row]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.placeInfo = item
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ByRegionViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == doNamePickerView {
            return doPickerList.count
        } else if pickerView == sigunguPickerView {
            return sigunguPickerList.count
        } else if pickerView == typePickerView {
            return typePickerList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == doNamePickerView {
            return doPickerList[row]
        } else if pickerView == sigunguPickerView {
            return sigunguPickerList[row]
        } else if pickerView == typePickerView {
            return typePickerList[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == doNamePickerView {
            selectedDo = doPickerList[row]
            doNameTextField.text = selectedDo
            sigunguPickerList = Region.regionDic[selectedDo!]!
            doQuery = "doName == '\(selectedDo!)'"
        } else if pickerView == sigunguPickerView {
            selectedSigungu = sigunguPickerList[row]
            sigunguTextField.text = selectedSigungu
            if selectedSigungu == "전체" {
                self.sigunguQuery = ""
            } else {
                self.sigunguQuery = "AND sigunguName == '\(selectedSigungu!)'"
            }
        } else if pickerView == typePickerView {
            selectedType = typePickerList[row]
            typeTextField.text = selectedType
            typeQuery =  "AND inDuty CONTAINS '\(selectedType!)'"
        }
    }
}

