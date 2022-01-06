//
//  CampDetailsViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 19/05/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class CampDetailsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tileLabel: UILabel!
    
    @IBOutlet var detailLabel: UILabel!
    
    let db = Firestore.firestore()
    static var doc = ""
    var fetchLatitude: Double?
    var fetchLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData(){
        self.showAnimation()
        let docRef = db.collection("camps").document(CampDetailsViewController.doc)
            docRef.getDocument(){(document, error) in
                if let document = document, document.exists{
                    let data = document.data()
                    self.titleLabel.text = data?[campsFields.title] as? String
                    self.locationLabel.text = data?[campsFields.location] as? String
                    self.dateLabel.text = data?[campsFields.dateOfCamp] as? String
                    self.tileLabel.text = data?[campsFields.campTime] as? String
                    self.detailLabel.text = data?[campsFields.details] as? String
                    let latitude = data?[campsFields.latitude]
                    self.fetchLatitude = (latitude as! Double)
                    let longitude = data?[campsFields.longitude]
                    self.fetchLongitude = (longitude as! Double)
                    self.removeAnimation()
                } else{
                    self.presentAlert(withTitle: "", message: "Error")
                    self.removeAnimation()
                    
                }
            }
        }
    
    @IBAction func shareButton(_ sender: Any) {
        let title = titleLabel.text
        
        let vc = UIActivityViewController(activityItems: [title!], applicationActivities: [])
        
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
           
        }
        self.present(vc,animated: true)
    }
    
    @IBAction func navigateToLocation(_ sender: Any) {
        let longitude: CLLocationDegrees = fetchLongitude!
        let latitude: CLLocationDegrees = fetchLatitude!
        
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude,longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance,longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: options)
        
        
    }
    
    
}
