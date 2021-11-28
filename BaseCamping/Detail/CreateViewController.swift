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
        print("Realm is located at", localRealm.configuration.fileURL!)
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
        // [To-do] alert으로 저장여부 확인
        // [To-do] 공백 체크
        // [To-do] 핸들러 사용 DetailView에 토스트 띄우기
        guard let placeInfo = placeInfo else { return }
        guard let title = titleLabel.text else { return }
        guard let content = contentLabel.text else { return }
        
        let review = Review(facilitySatisfaction: facilityRateValue, serviceSatisfaction: serviceRateValue, accessibility: accessRateValue, revisitWill: revisitWillRateValue, title: title, content: content, regDate: Date(), placeInfo: placeInfo)
        try! localRealm.write {
            localRealm.add(review)
            if let checkedImage = selectedImage.image {
                saveImageToDocuments(imageName: "\(review._id).jpg", image: checkedImage)
            }
        }
        self.dismiss(animated: true, completion: nil)
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
        let imageURL = documentDirectory.appendingPathComponent(imageName)
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


