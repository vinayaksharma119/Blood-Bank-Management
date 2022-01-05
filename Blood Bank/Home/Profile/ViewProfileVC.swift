//
//  ViewProfileVC.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 06/05/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class ViewProfileVC: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var bloodGroupLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameLabel.text = nameLabel.text
        ageLabel.text = ageLabel.text
        mobileLabel.text = mobileLabel.text
    }
    
    func getData(){
        self.showAnimation()
        db.collection("data").document((self.user?.email)!).collection("User Data")
            .getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let name = document.data()["Name"]
                        let gender = document.data()["Gender"]
                        let age = document.data()["Age"]
                        let mobile = document.data()["Mobile Number"]
                        let bloodGroup = document.data()["Blood Group"]
                        let email = document.data()["Email"]
                        self.nameLabel.text?.append(name as! String)
                        self.genderLabel.text?.append(gender as! String)
                        self.ageLabel.text?.append(age as! String)
                        self.mobileLabel.text?.append(mobile as! String)
                        self.bloodGroupLabel.text?.append(bloodGroup as! String)
                        self.emailLabel.text?.append(email as! String)
                        self.removeAnimation()
                    }
                }
                
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditProfile"{
        let destVC = segue.destination as! EditProfileVC
        destVC.nameText = nameLabel.text
        destVC.ageText = ageLabel.text
        destVC.mobileNumber = mobileLabel.text
        }
    }
    
@IBAction func profileVC(segue:UIStoryboardSegue) { }
}

extension ViewProfileVC: UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile")
            return cell!
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "req")
            return cell!
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "logout")
            return cell!
        }
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            performSegue(withIdentifier: "goToEditProfile", sender: self)
            
        } else if indexPath.row == 1{
            performSegue(withIdentifier: "goToUserReq", sender: self)
            
        }
         else if indexPath.row == 2{
            print("Logout")
            do {

                try Auth.auth().signOut()

                dismiss(animated: true, completion: nil)
                
                let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstNav") as! UINavigationController
                present(vc,animated: true,completion: nil)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
