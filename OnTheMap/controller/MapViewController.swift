//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 11/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class MapViewController:UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        NetworkHelper.handleStudentsLocationsMapController(self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MapHelper.getMapAnnotationView(mapView, viewFor: annotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
                if let url = URL(string: (view.annotation?.subtitle!)!){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        }
    }
}
