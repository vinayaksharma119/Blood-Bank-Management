//
//  AddReqViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 18/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class AddReqViewController: UIViewController, UITextViewDelegate {
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    var userRef: DocumentReference!
    
    @IBOutlet var bloodGroup: UITextField!
    @IBOutlet var details: UITextView!
    @IBOutlet var submit: UIButton!
    
    let bloodGroupPickerr = UIPickerView()
    
    let bloodGroupPicker = ["A+","O+","B+","AB+","A-","O-","B-","AB-"]
    var selectedBloodGroup : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        createPickerView()
        createToolbar()
        configUIElemets()
    }
    
    func configUIElemets(){
        details.textColor = .lightGray
        details.text = "Click here to write details"
        details.layer.borderWidth = 1
        details.layer.borderColor = UIColor.lightGray.cgColor
        details.delegate = self
        submit.layer.cornerRadius = 20
        submit.tintColor = .white
        submit.backgroundColor = .systemGreen
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if details.textColor == UIColor.lightGray {
            details.text = nil
            details.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Click here to write details"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func createPickerView(){
        bloodGroupPickerr.delegate = self
    
        bloodGroup.inputView = bloodGroupPickerr
    }
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddReqViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        bloodGroup.inputAccessoryView = toolBar
        
    }
    
    @objc override func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
    
        guard let bloodGroup = bloodGroup.text , !bloodGroup.isEmpty else {self.presentAlert(withTitle: "Enter blood group", message: "")
            return
        }
        
        if details.text == "Click here to write details"{
            self.presentAlert(withTitle: "Please enter details", message: "")
            return
        }
        
        navigationItem.hidesBackButton = true
        self.showAnimation()

        docRef = db.collection("request").document()
        
        let dataToSave: [String: Any] = ["Blood group":bloodGroup,"Details": details.text!,"Date":Date().string(format: "dd-MM-yyyy"),"Doc id": docRef.documentID,"Time":Timestamp.init()]
        
        
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("Got an Error : \(error.localizedDescription)")
                self.removeAnimation()
                self.navigationItem.hidesBackButton = false
            }
            else {
                self.userRef = self.db.collection("data").document((self.user?.email)!).collection("Request History").document()
                let reqData : [String: Any] = ["Blood group":bloodGroup,"Details": self.details.text!,"Time":Timestamp.init(),]
                self.userRef.setData(reqData) { (error) in
                    if let error = error {
                        print("Got an Error : \(error.localizedDescription)")
                        self.removeAnimation()
                        self.navigationItem.hidesBackButton = false
                    }else{
                            self.removeAnimation()
                            self.navigationController?.popViewController(animated: true)
                            self.performSegue(withIdentifier: "goToViewReq", sender: self)
                    }
                }

            }
        }
        
      }
}

extension AddReqViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

            return bloodGroupPicker.count
    }
        
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            return bloodGroupPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedBloodGroup = bloodGroupPicker[row]
            bloodGroup.text = selectedBloodGroup
        
        
    }
    
    
}

