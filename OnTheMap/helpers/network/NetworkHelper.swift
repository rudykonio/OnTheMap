//
//  NetworkHelper.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 05/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
import Network
import MapKit
class NetworkHelper {
    private init(){}
    static func logInSession(_ emailUITF:UITextField,_ passwordUITF:UITextField,_ loginVC:LoginViewController){
        loginVC.logInBTN.isEnabled = false
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailUITF.text!)\", \"password\": \"\(passwordUITF.text!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with:request) { (data, response, error) in
            if(error != nil){
                let errorMessage = error?.localizedDescription
                GeneralHelper.showAlert(errorMessage!,loginVC)
                return
            }
            if(data != nil && data!.count>0 ){
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                do {
                    let json = try JSONSerialization.jsonObject(with: newData!, options: [JSONSerialization.ReadingOptions.mutableContainers]) as![String:Any]
                        if let message =  json["error"] as! String?{
                            GeneralHelper.showAlert(message,loginVC)
                                        DispatchQueue.main.async{
                             loginVC.logInBTN.isEnabled = true
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let decoder = JSONDecoder()
                                if let postSessionObj = try? decoder.decode(NetworkData.PostSessionObject.self, from: newData!){
                                loginVC.key =  postSessionObj.account.key
                                loginVC.performSegue(withIdentifier: "mapTableSegue", sender: loginVC)
                                emailUITF.text = loginVC.email
                                passwordUITF.text = loginVC.password
                                loginVC.logInBTN.isEnabled = true
                                }
                            }
                    }
                }catch  {
                    
                }
            }
        }
        task.resume()
    }
    
    static func logOutSession(_ tabBarController:UITabBarController){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async{
             tabBarController.navigationController?.popViewController(animated: true)
            }
        }
        task.resume()
    }
    
    static func handleStudentsLocationsMapController(_ mapController:MapViewController){
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            return
          }
        let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(NetworkData.ResultsList.self, from: data!)
                let mapObjects = result.results
                var annotations = [MKPointAnnotation]()
                for mapObj in mapObjects{
                    let coordinate = CLLocationCoordinate2D(latitude: mapObj.latitude, longitude: mapObj.longitude)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(mapObj.firstName) \(mapObj.lastName)"
                    annotation.subtitle = mapObj.mediaURL
                    annotations.append(annotation)
                }
                DispatchQueue.main.async{
                 mapController.mapView.addAnnotations(annotations)
                }
                print(mapObjects)
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    
    static func handleStudentsLocationsTableController(_ tableController:TableViewController){
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(NetworkData.ResultsList.self, from: data!)
                DispatchQueue.main.async {
                    tableController.students = result.results
                    tableController.tableView.reloadData()
                }
            } catch{
                print(error)
            }
        }
        task.resume()
    }
    

    static func getAndPostData(viewController:AddLocationMapViewController){
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(viewController.key!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
            do{
                if let json = try JSONSerialization.jsonObject(with: newData!, options: []) as? [String: Any] {
                    if let firstName = json["first_name"] as? String,let lastName = json["last_name"] as? String {
                        var requestBody:[String:Any] = [String:Any]()
                        requestBody["uniqueKey"] = viewController.key!
                        requestBody["firstName"] = firstName
                        requestBody["lastName"] = lastName
                        requestBody["mapString"] = viewController.pinTitle!
                        requestBody["mediaURL"] = viewController.link!
                        requestBody["latitude"] = viewController.latitude
                        requestBody["longitude"] = viewController.longitude
                        let reqBodyJson = try JSONSerialization.data(withJSONObject:requestBody, options:[])
                        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
                        request.httpMethod = "POST"
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpBody = reqBodyJson
                        let session = URLSession.shared
                        let task = session.dataTask(with: request) { data, response, error in
                          if error != nil {
                              return
                          }
                        
                                do {
                                     print(String(data: data!, encoding: .utf8)!)
                                    let dicData =  try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                                    if let message =  dicData!["error"] as! String?{
                                        GeneralHelper.showAlert(message,viewController)
                                    }
                                    else{
                                        DispatchQueue.main.async {
                                            viewController.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                } catch {}
                        }
                        task.resume()
                        
                    }
                }
            }catch {}
        }
        task.resume()
    }
}
