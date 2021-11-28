//
//  ByKeywordViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/26.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class ByKeywordViewController: UIViewController {
    let localRealm = try! Realm()
    var filteredList: Results<PlaceInfo>!
    var searchText: String?
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var noResultView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredList = localRealm.objects(PlaceInfo.self).filter("doName == '서울특별시'").sorted(byKeyPath: "name", ascending: true)
        setupSearchController()
        setupTableView()
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Keyword"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.black
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.searchTextField.delegate = self
    }

    func setupTableView() {
        let nibName = UINib(nibName: SearchResultTableViewCell.identifier, bundle: nil)
        self.searchResultTableView.register(nibName, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
    }
}

extension ByKeywordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = filteredList[indexPath.row]
 
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()}
        let url = URL(string: row.imageURL!)
        cell.placeImage.kf.setImage(with: url)
        cell.addressLabel.text = row.address
        cell.nameLabel.text = row.name
        cell.typeLabel.text = row.inDuty
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredList[indexPath.row]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.placeInfo = item
        let nav =  UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}

extension ByKeywordViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UITextFieldDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText = text
        self.filteredList = localRealm.objects(PlaceInfo.self).filter("name CONTAINS '\(text)' OR doName CONTAINS '\(text)' OR doName CONTAINS '\(text)' OR sigunguName CONTAINS '\(text)' OR intro CONTAINS '\(text)' OR inDuty CONTAINS '\(text)' OR keyword CONTAINS '\(text)'")
        searchResultTableView.reloadData()
        if self.filteredList.count == 0 {
            self.noResultView.isHidden = false
        } else {
            self.noResultView.isHidden = true
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = nil
        searchText = nil
        searchResultTableView.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchResultTableView.reloadData()
        return true
    }
}

