//
//  ZoomPictureViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/13.
//

import UIKit
import Kingfisher

class ZoomPictureViewController: UIViewController {
    var pictureURL: URL?
    var isZooming = false
    var originalImageCenter:CGPoint?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pictureURL = pictureURL else {
            return
        }
        imageView.kf.setImage(with: pictureURL)
        imageView.isUserInteractionEnabled = true
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.imageView.addGestureRecognizer(pinch)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        pan.delegate = self
        self.imageView.addGestureRecognizer(pan)
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        if sender.state == .began {
        
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale = currentScale*sender.scale
        
            if newScale > 1 {
                self.isZooming = true
            }
        } else if sender.state == .changed {
            guard let view = sender.view else { return }
        
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX, y: sender.location(in: view).y - view.bounds.midY)

            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
        
            var newScale = currentScale*sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
                sender.scale = 1
            } else {
                view.transform = transform
                sender.scale = 1
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else { return }

            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.imageView.superview)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ZoomPictureViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
