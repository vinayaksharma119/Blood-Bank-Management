//
//  ViewUserReqTableVC.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 18/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class ViewUserReqTableVC: UITableViewController {
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    var bloodGroupArray:[String] = []
    var detailsArray: [String] = []

    var doc = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloodGroupArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReq") as! ViewReqTableViewCell
        cell.bloodGroup.text! = bloodGroupArray[indexPath.row]
        cell.details.text! = detailsArray[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getData(){
        self.showAnimation()
        db.collection("data").document((self.user?.email)!).collection("Request History").order(by: "Time",descending: true)
            .getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.doc = document.documentID
                        let bloodGroup = document.data()["Blood group"]
                        let details = document.data()["Details"]
                        self.bloodGroupArray.append(bloodGroup as! String)
                        self.detailsArray.append(details as! String)
                        self.removeAnimation()
                    }
                    if self.bloodGroupArray.count == 0{
                        self.tableView.setEmptyMessage("You have not made any requests.")
                        self.removeAnimation()
                    } else{self.tableView.restore()}
                    self.tableView.reloadWithAnimation()
                    
                }
                
        }
        
    }
    
}
   

    
    

    


