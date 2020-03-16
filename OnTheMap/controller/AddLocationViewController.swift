//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 14/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class AddLocationViewController:UIViewController,UITextFieldDelegate{
    let locationDefault = "  Location"
    let linkDefault = "  Link"
    let emptyString = ""
    var latitude:String?
    var longitude:String?
    var link:String?
    @IBOutlet weak var locationUITF: UITextField!
    @IBOutlet weak var linkUITF: UITextField!
    @IBOutlet weak var findLocationBtn: UIButton!{
        didSet{
            findLocationBtn.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func locationTFBeginEditing(_ sender: Any) {
        GeneralHelper.setEmptyString(locationDefault,locationUITF)
    }
    
    @IBAction func locationTFEndEditing(_ sender: Any) {
         GeneralHelper.setDefaultString(locationDefault,locationUITF)
    }
    
    
    @IBAction func linkTFBeginEditing(_ sender: Any) {
        GeneralHelper.setEmptyString(linkDefault,linkUITF)
    }
    
    @IBAction func linkTFEndEditing(_ sender: Any) {
        GeneralHelper.setDefaultString(linkDefault,linkUITF)
    }
    @IBAction func findLocationClick(_ sender: Any) {
        if(GeneralHelper.notNullOrEmpty(locationUITF) && GeneralHelper.notNullOrEmpty(linkUITF)
            && locationUITF.text != locationDefault && linkUITF.text != linkDefault){
            activityIndicator.startAnimating()
            CLGeocoder().geocodeAddressString(locationUITF.text!, completionHandler: { placemarks, error in
                 if (error != nil) {
                    self.activityIndicator.stopAnimating()
                     GeneralHelper.showAlert("Something went wrong please try again with correct location", self)
                     return
                 }else{
                    if let placemark = placemarks?[0]{
                        self.latitude = String((placemark.location?.coordinate.latitude ?? 0.0)!)
                        self.longitude = String((placemark.location?.coordinate.longitude ?? 0.0)!)
                        self.link = self.linkUITF.text!
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "addLocationMap", sender: self)
                    }
                }
            })
            
        }else{
            GeneralHelper.showAlert("Please add Location and Link first", self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationUITF.delegate = self
        linkUITF.delegate = self
        self.navigationItem.title = "Add Location"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelVC))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationMap"{
            let destination = segue.destination as! AddLocationMapViewController
            destination.latitude = (self.latitude! as NSString).doubleValue
            destination.longitude = (self.longitude! as NSString).doubleValue
            destination.link = self.link
            destination.key = (self.navigationController as! AddLocationNavController).key
        }
    }
    
    @objc func cancelVC(){
        self.dismiss(animated: true, completion: nil)
    }
}
