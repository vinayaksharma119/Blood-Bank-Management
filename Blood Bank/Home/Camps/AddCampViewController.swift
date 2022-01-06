//
//  AddCampViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 28/05/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase


class AddCampViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate{
   
    @IBOutlet var titleField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var timeField: UITextField!
    
    @IBOutlet var detailsField: UITextView!
    @IBOutlet var submit: UIButton!
    @IBOutlet weak var addLoc: UIButton!
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var docRef: DocumentReference!
    let db = Firestore.firestore()
    
    var latitude : Float? = nil
    var longitude : Float? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUIElemets()
        createDatePicker()
        createTimePicker()
        hideKeyboardWhenTappedAround()
    }
    
    func configUIElemets(){
        detailsField.textColor = .lightGray
        detailsField.text = "Click here to write details"
        detailsField.layer.borderWidth = 1
        detailsField.layer.borderColor = UIColor.lightGray.cgColor
        detailsField.delegate = self
        submit.layer.cornerRadius = 20
        submit.tintColor = .white
        submit.backgroundColor = .systemGreen
        addLoc.layer.cornerRadius = 10
        self.titleField.delegate = self
        self.cityField.delegate = self
       }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailsField.textColor == UIColor.lightGray {
            detailsField.text = nil
            detailsField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Click here to write details"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        dateField.inputAccessoryView = toolBar
        dateField.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    func createTimePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTimePressed))
        toolBar.setItems([doneButton], animated: true)
        timeField.inputAccessoryView = toolBar
        timeField.inputView = timePicker
        
        timePicker.datePickerMode = .time
    }
    
    @objc func doneTimePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
        
    }
    
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        
        guard let title = titleField.text, !title.isEmpty else {
            self.presentAlert(withTitle: "Enter title", message: "")
            return
        }
        guard let city = cityField.text, !city.isEmpty else{
            self.presentAlert(withTitle: "Enter city", message: "")
            return
        }
        guard let date = dateField.text, !date.isEmpty else {
            self.presentAlert(withTitle: "Enter date", message: "")
            return
        }
        guard let time = timeField.text, !time.isEmpty else {
            self.presentAlert(withTitle: "Enter time", message: "")
            return
        }
        
        if detailsField.text! == "Click here to write details"{
            self.presentAlert(withTitle: "Enter details", message: "")
            return
        }
        if (latitude == nil) && (longitude == nil){
            self.presentAlert(withTitle: "Please enter location", message: "")
            return
        }
        
        navigationItem.hidesBackButton = true
        self.showAnimation()
        
        docRef = db.collection("camps").document()
        
        let campTitle = campsFields.title
        let campLocation = campsFields.location
        let timeStamp = campsFields.time
        let campTime = campsFields.campTime
        let dateOfCamp = campsFields.dateOfCamp
        let campDetails = campsFields.details
        let campLatitude = campsFields.latitude
        let campLongitude = campsFields.longitude
        let userId = campsFields.userId
        
        let dataToSave: [String: Any] = [campTitle:title,campLocation: city,timeStamp:Timestamp.init(),dateOfCamp: date,campTime: time,campDetails:detailsField.text!,campLatitude: latitude!,campLongitude: longitude!,userId: docRef.documentID,]
        
        
            docRef.setData(dataToSave) { (error) in
                if let error = error {
                    print("Got an Error : \(error.localizedDescription)")
                    self.removeAnimation()
                    self.navigationItem.hidesBackButton = false
                } else{
                    print("Data has been saved")
                    self.removeAnimation()
                    self.navigationController?.popViewController(animated: true)
                    self.performSegue(withIdentifier: "goToCamps", sender: self)
                }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func unwindToCampsVC(segue:UIStoryboardSegue) { }
    @IBAction func unwindToCampsVC1(segue:UIStoryboardSegue) { }
}
