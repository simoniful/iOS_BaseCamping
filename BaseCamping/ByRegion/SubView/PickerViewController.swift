//
//  PickerViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/25.
//

import UIKit

class PickerViewController: UIViewController {
    var pickerList: [String]? = []
    var selectedRow: String!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))
        tap.delegate = self
        pickerView.addGestureRecognizer(tap)
    }
    
    @objc func pickerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let pickerView = gestureRecognizer.view as? UIPickerView else {
            return
        }
        let row = pickerView.selectedRow(inComponent: 0)
        
        if let pickerList = pickerList {
            selectedRow = pickerList[row]
        }
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerList = self.pickerList else {return 0}
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerList = self.pickerList else {return nil}
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerList = self.pickerList else {return}
        selectedRow = pickerList[row]
    }
    
}

extension PickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
}

