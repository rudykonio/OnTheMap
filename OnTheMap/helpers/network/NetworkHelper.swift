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
class NetworkHelper {
    private init(){}
    static func logInSession(_ emailUITF:UITextField,_ passwordUITF:UITextField,_ loginVC:LoginViewController){
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
                        //error
                            GeneralHelper.showAlert(message,loginVC)
                        }
                        else{
                            //success
                            DispatchQueue.main.async {
                                loginVC.performSegue(withIdentifier: "mapTableSegue", sender: loginVC)
                                emailUITF.text = loginVC.email
                                passwordUITF.text = loginVC.password
                            }
                    }
                }catch  {
                    
                }
            }
        }
        task.resume()
    }
}
