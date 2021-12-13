//
//  CreateViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/25.
//

import UIKit
import Cosmos
import RealmSwift

class CreateViewController: UIViewController {
    var placeInfo: PlaceInfo?
    var btnActionHandler: (() -> ())?
    let localRealm = try! Realm()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var contentLabel: UITextView!
    
    @IBOutlet weak var facilityRate: CosmosView!
    var facilityRateValue: Double = 3.0
    @IBOutlet weak var serviceRate: CosmosView!
    var serviceRateValue: Double = 3.0
    @IBOutlet weak var accessRate: CosmosView!
    var accessRateValue: Double = 3.0
    @IBOutlet weak var revisitWillRate: CosmosView!
    var revisitWillRateValue: Double = 3.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("Realm is located at", localRealm.configuration.fileURL!)
        
        titleLabel.delegate = self
        titleLabel.addLeftPadding()
        
        contentLabel.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 0)
        contentLabel.delegate = self
        contentLabel.text = "리뷰 내용을 입력하세요"
        contentLabel.textColor = UIColor.systemGray3
        cosmosSetting ()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func cosmosSetting () {
        facilityRate.settings.fillMode = .full
        serviceRate.settings.fillMode = .full
        accessRate.settings.fillMode = .full
        revisitWillRate.settings.fillMode = .full
        
        facilityRate.didFinishTouchingCosmos = { rating in self.facilityRateValue = rating }
        serviceRate.didFinishTouchingCosmos = { rating in self.serviceRateValue = rating }
        accessRate.didFinishTouchingCosmos = { rating in self.accessRateValue = rating }
        revisitWillRate.didFinishTouchingCosmos = { rating in self.revisitWillRateValue = rating }
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        
        guard let placeInfo = self.placeInfo else { return }
        guard let title = self.titleLabel.text else { return }
        guard let content = self.contentLabel.text else { return }
        guard let btnActionHandler = self.btnActionHandler else { return }
        
        if self.selectedImage.image == nil {
            let alert = UIAlertController(title: "사진이 첨부되지 않았네요", message: "기록할만한 사진을 첨부해 주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel, handler:nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        if title.trimmingCharacters(in: .whitespaces) == "" {
            let alert = UIAlertController(title: "제목이 비었네요", message: "리뷰 제목을 작성해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel, handler:nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        if (content == "리뷰 내용을 입력하세요" || content.trimmingCharacters(in: .whitespaces) == "") {
            let alert = UIAlertController(title: "내용이 비었네요", message: "리뷰 내용을 작성해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel, handler:nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "리뷰를 저장하시겠습니까?", message: "저장된 리뷰는 마이메뉴에서 확인할 수 있습니다", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction!) in
            let review = Review(facilitySatisfaction: self.facilityRateValue, serviceSatisfaction: self.serviceRateValue, accessibility: self.accessRateValue, revisitWill: self.revisitWillRateValue, title: title, content: content, regDate: Date(), placeInfo: placeInfo)
        
            try! self.localRealm.write {
                self.localRealm.add(review)
                if let checkedImage = self.selectedImage.image {
                    self.saveImageToDocuments(imageName: "\(review._id).jpg", image: checkedImage)
                }
            }
            btnActionHandler()
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectImageBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "앨범에서 가져오기", style: .default) { (action: UIAlertAction!) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func saveImageToDocuments(imageName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imagesDirectoryURL = documentDirectory.appendingPathComponent("images")
        if !(FileManager.default.fileExists(atPath: imagesDirectoryURL.path)) {
            do {
                try FileManager.default.createDirectory(atPath: imagesDirectoryURL.path, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        let imageURL = imagesDirectoryURL.appendingPathComponent(imageName)
        let image = image.resize(newWidth: UIScreen.main.bounds.width * 2)
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지 삭제 실패")
            }
        }
        do {
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 실패")
        }
    }
}

extension CreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "리뷰 내용을 입력하세요"
            textView.textColor = UIColor.systemGray3
        }
    }
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let value = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage.image = value
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


