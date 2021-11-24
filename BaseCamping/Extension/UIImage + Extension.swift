//
//  UIImage + Extension.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/23.
//

import UIKit

extension UIImage {
    // allows creating image from CALayer.
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
