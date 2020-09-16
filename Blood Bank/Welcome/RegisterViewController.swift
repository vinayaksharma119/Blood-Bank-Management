//
//  RegisterViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    let db = Firestore.firestore()
    var docRef: DocumentReference!

    
    @IBOutlet var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet var age: UITextField!
    @IBOutlet var mobile: UITextField!
    @IBOutlet weak var bloodGroup: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var register: UIButton!
    
    let genderPickerr = UIPickerView()
    let bloodGroupPickerr = UIPickerView()
    
    let genderPicker = ["Male","Female"]
    var selectedGender : String?
    
    let bloodGroupPicker = ["A+","O+","B+","AB+","A-","O-","B-","AB-"]
    var selectedBloodGroup : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register.layer.cornerRadius = 20
        register.tintColor = .white
        register.backgroundColor = .systemGreen
        hideKeyboardWhenTappedAround()
        createPickerView()
        createToolbar()
        
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        guard let nameText = name.text , !nameText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter name")
            return}
        guard let genderText = gender.text, !genderText.isEmpty else{
            self.presentAlert(withTitle: "", message: "Enter Gender")
            return}
        guard let ageText = age.text, !ageText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter age")
            return}
        guard let mobileText = mobile.text, !mobileText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter mobile")
            return}
        guard let bloodGroupText = bloodGroup.text, !bloodGroupText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter blood group")
            return}
        guard let emailText = email.text, !emailText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter email")
            return}
        guard let passwordText = password.text, !passwordText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter password")
            return}
        navigationItem.hidesBackButton = true
        self.showAnimation()
        docRef = db.collection("data").document(emailText).collection("User Data").document("Data")
        
        let dataToSave: [String: Any] = ["Name": nameText,"Gender": genderText,"Age": ageText,"Mobile Number": mobileText,"Blood Group": bloodGroupText,"Email": emailText]
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { (user, error) in
            if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .invalidEmail:
                            self.presentAlert(withTitle: "Invalid email", message: "Please enter a valid email.")
                        case .emailAlreadyInUse:
                            self.presentAlert(withTitle: "Something went wrong", message: "This email already exists")
                        case .networkError:
                            self.presentAlert(withTitle: "Network error", message: "Please check your internet and try again")
                        default:
                            self.presentAlert(withTitle: "Something went wrong", message: "Internal error")
                    }
                }
                self.removeAnimation()
                self.navigationItem.hidesBackButton = false
                
            }
            else {
                print("Registration Successful")
                self.removeAnimation()
                self.performSegue(withIdentifier: "goToHome", sender: self)
                self.docRef.setData(dataToSave) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    } else{
                        print("Data has been saved")
                    }
                }
            }
        }
        
    }
    
    func createPickerView(){
        genderPickerr.delegate = self
        bloodGroupPickerr.delegate = self
        
        gender.inputView = genderPickerr
        bloodGroup.inputView = bloodGroupPickerr
    }
    
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        gender.inputAccessoryView = toolBar
        bloodGroup.inputAccessoryView = toolBar
        
    }
    
    @objc override func dismissKeyboard(){
        view.endEditing(true)
    }
    
   

}

extension RegisterViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == genderPickerr {
            return genderPicker.count
        }
        
        else if pickerView == bloodGroupPickerr{
            return bloodGroupPicker.count
        }
        
        return 1
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerr {
            return genderPicker[row]
        }
        
        else if pickerView == bloodGroupPickerr{
            return bloodGroupPicker[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == genderPickerr{
            selectedGender = genderPicker[row]
            gender.text = selectedGender
        }
        else if pickerView == bloodGroupPickerr{
            selectedBloodGroup = bloodGroupPicker[row]
            bloodGroup.text = selectedBloodGroup
        }
        
    }
    
    
}
