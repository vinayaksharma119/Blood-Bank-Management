//
//  EditProfileVC.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 07/05/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase


class EditProfileVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var mobileNoTextField: UITextField!
    
    @IBOutlet var submit: UIButton!
    
    var nameText: String!
    var ageText: String!
    var mobileNumber: String!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var docRef : DocumentReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        nameTextField.delegate = self
        submit.layer.cornerRadius = 20
        submit.tintColor = .white
        submit.backgroundColor = .systemGreen
        nameTextField.text = nameText
        ageTextField.text = ageText
        mobileNoTextField.text = mobileNumber
        
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard let nameText = nameTextField.text , !nameText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter name")
            return}
        guard let ageText = ageTextField.text, !ageText.isEmpty else{
            self.presentAlert(withTitle: "", message: "Enter Age")
            return}
        guard let mobileText = mobileNoTextField.text, !mobileText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter mobile number")
            return}
        
        navigationItem.hidesBackButton = true
        self.showAnimation()
        
        docRef = db.collection("data").document((self.user?.email)!).collection("User Data").document("Data")
        
        let dataToSave: [String: Any] = ["Name": nameText,"Age": ageText,"Mobile Number": mobileText]
        
        docRef.updateData(dataToSave) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                self.removeAnimation()
                self.navigationItem.hidesBackButton = false
            } else{
                print("Data has been saved")
                self.removeAnimation()
                self.performSegue(withIdentifier: "profileVC", sender: self)
            }
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileVC" {
            let destVC = segue.destination as! ViewProfileVC
            destVC.nameLabel.text = nameTextField.text
            destVC.ageLabel.text = ageTextField.text
            destVC.mobileLabel.text = mobileNoTextField.text
        }
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
