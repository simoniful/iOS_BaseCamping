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
    
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }

}
