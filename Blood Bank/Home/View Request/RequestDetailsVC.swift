//
//  RequestDetailsVC.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 04/09/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class RequestDetailsVC: UIViewController {

    @IBOutlet weak var bloodGroupLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    let db = Firestore.firestore()
    static var docId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
   
    func getData(){
    self.showAnimation()
    let docRef = db.collection("request").document(RequestDetailsVC.docId)
        docRef.getDocument(){(document, error) in
            if let document = document, document.exists{
                let data = document.data()
                self.bloodGroupLabel.text = data?["Blood group"] as? String
                self.dateLabel.text = data?["Date"] as? String
                self.detailLabel.text = data?["Details"] as? String
                self.removeAnimation()
            } else{
                self.presentAlert(withTitle: "", message: "Error")
                self.removeAnimation()
                
            }
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let detail = detailLabel.text
        
        let vc = UIActivityViewController(activityItems: [detail!], applicationActivities: [])
        
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
           
        }
        self.present(vc,animated: true)
    }
    
    
}
