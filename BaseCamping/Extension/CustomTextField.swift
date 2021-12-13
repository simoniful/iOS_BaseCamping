//
//  CustomTextField.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/30.
//

import UIKit

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
