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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
             cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
             },completion: { finished in
                UIView.animate(withDuration: 0.1, animations: {
                     cell.layer.transform = CATransform3DMakeScale(1,1,1)
                 })
         })
    }
    
    func getData(){
        self.showAnimation()
        
        db.collection("camps").order(by: "Date",descending: false)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let title = document.data()["Title"]
                        let location = document.data()["Location"]
                        let date = document.data()["Date"]
                        let uidd = document.data()["User id"]
                        self.uid.append(uidd as! String)
                        self.titleArray.append(title as! String)
                        self.locationArray.append(location  as! String)
                        self.dateArray.append(date as! String)
                        self.removeAnimation()
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
        
        db.collection("camps").order(by: "Date",descending: false)
        .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let title = document.data()["Title"]
                        let location = document.data()["Location"]
                        let date = document.data()["Date"]
                        let uidd = document.data()["User id"]
                        self.uid.append(uidd as! String)
                        self.titleArray.append(title as! String)
                        self.locationArray.append(location  as! String)
                        self.dateArray.append(date as! String)
                        }
                    self.tableView.reloadWithAnimation()
                }
            sender.endRefreshing()
        }
       
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
