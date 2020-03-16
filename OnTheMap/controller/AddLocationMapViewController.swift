//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 14/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class AddLocationMapViewController : UIViewController,MKMapViewDelegate{
    var longitude:Double?
    var latitude:Double?
    var link:String?
    var pinTitle:String?
    var key:String?
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var finishBtn: UIButton!{
        didSet{
            finishBtn.layer.cornerRadius = 4
        }
    }
    @IBAction func finishClick(_ sender: Any) {
        NetworkHelper.getAndPostData(viewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMapView.delegate = self
        if let longitude = longitude,let latitude = latitude{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude:latitude, longitude: longitude)
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geoCoder.reverseGeocodeLocation(location) { (placemarks,error) in
                if(error != nil){
                    return
                }
                let placeMark: CLPlacemark! = placemarks?[0]
                
                annotation.title = "\(placeMark.locality ?? ""), \(placeMark.administrativeArea ?? ""), \(placeMark.country ?? "")"
                self.pinTitle = annotation.title
                self.locationMapView.addAnnotation(annotation)
                self.locationMapView.setCenter(annotation.coordinate, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        MapHelper.getMapAnnotationView(mapView, viewFor: annotation)
    }
    
}
