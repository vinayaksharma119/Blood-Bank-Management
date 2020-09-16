//
//  ViewRequestsTableVC.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 18/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class ViewRequestsTableVC: UITableViewController {
    
    var bloodGroupArray:[String] = []
    var detailsArray: [String] = []
    var uid:[String] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bloodGroupArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request") as! ViewRequestsTableViewCell
        if bloodGroupArray.count != 0{
            cell.bloodGroup.text! = bloodGroupArray[indexPath.row]
            cell.details.text! = detailsArray[indexPath.row]
        }

        // Configure the cell...
        
        return cell
    }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RequestDetailsVC.docId = uid[indexPath.row]
        performSegue(withIdentifier: "viewReq", sender: self)
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
        
        let first = db.collection("request").order(by: "Time",descending: true)
         first.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let bloodGroup = document.data()["Blood group"]
                        let details = document.data()["Details"]
                        let uidd = document.data()["Doc id"]
                        self.uid.append(uidd as! String)
                        self.bloodGroupArray.append(bloodGroup as! String)
                        self.detailsArray.append(details as! String)
                        self.removeAnimation()
                    }
                    self.tableView.reloadData()
                }
           
            }
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        self.bloodGroupArray.removeAll()
        self.detailsArray.removeAll()
        self.uid.removeAll()
        
        db.collection("request").order(by: "Time",descending: true)
             .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let bloodGroup = document.data()["Blood group"]
                            let details = document.data()["Details"]
                            let uidd = document.data()["Doc id"]
                            self.uid.append(uidd as! String)
                            self.bloodGroupArray.append(bloodGroup as! String)
                            self.detailsArray.append(details as! String)
                        }
                        self.tableView.reloadWithAnimation()
                    }
            }

            sender.endRefreshing()
        
    }
    
@IBAction func unwindToVC(segue:UIStoryboardSegue) { }
}
