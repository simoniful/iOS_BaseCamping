//
//  AttractionDetailViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/12/13.
//

import UIKit


class AttractionDetailViewController: UIViewController {
    
    var attractionInfo: AttractionInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
