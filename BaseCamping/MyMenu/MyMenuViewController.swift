//
//  MyMenuViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/26.
//

import UIKit

class MyMenuViewController: UIViewController {
    @IBOutlet weak var likedPlaceView: UIView!
    @IBOutlet weak var reviewListView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont.boldSystemFont(ofSize: 16)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }

    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            likedPlaceView.alpha = 1
            reviewListView.alpha = 0
        } else {
            likedPlaceView.alpha = 0
            reviewListView.alpha = 1
        }
    }
}
