//
//  CampsTableViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class CampsTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var titleArray:[String] = []
    var locationArray: [String] = []
    var dateArray: [String] = []
    
    var searchCity: [String] = []
    
    var isSearching = false
    
    var uid:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        searchBar.delegate = self
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            if searchCity.count == 0{
                tableView.setEmptyMessage("No results found.")
            } else{tableView.restore()}
            return searchCity.count
        }
        else{
           return locationArray.count
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "camps") as! CampsTableViewCell
        if isSearching{
            cell.titleLabel.text! = titleArray[indexPath.row]
            cell.locationLabel.text! = searchCity[indexPath.row]
            cell.dateLabel.text! = dateArray[indexPath.row]
        } else{
            cell.titleLabel.text! = titleArray[indexPath.row]
            cell.locationLabel.text! = locationArray[indexPath.row]
            cell.dateLabel.text! = dateArray[indexPath.row]
            }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CampDetailsViewController.doc = uid[indexPath.row]
        performSegue(withIdentifier: "viewCamps", sender: self)
    }
    
    
    func getData(){
        
        
        db.collection("camps").order(by: "Date",descending: false)
            .getDocuments {[weak self] (querySnapshot, err) in
                guard let self = self else {return}
                if let err = err {
                    self.presentAlert(withTitle: "Error", message: "\(String(describing: err))")
                } else {
                       
                    for document in querySnapshot!.documents {
                        
                        let title = document.data()[campsFields.title]
                        let location = document.data()[campsFields.location]
                        let date = document.data()[campsFields.dateOfCamp]
                        let uidd = document.data()[campsFields.userId]
                        self.uid.append(uidd as! String)
                        self.titleArray.append(title as! String)
                        self.locationArray.append(location  as! String)
                        self.dateArray.append(date as! String)

                    }
                    self.tableView.reloadData()
                }
        }
        
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        titleArray.removeAll()
        locationArray.removeAll()
        dateArray.removeAll()
        uid.removeAll()
        getData()
        sender.endRefreshing()
    }
}

extension CampsTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchCity = locationArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
        tableView.restore()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    

}
