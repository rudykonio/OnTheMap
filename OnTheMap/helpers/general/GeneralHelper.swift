//
//  GeneralHelper.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 06/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
class GeneralHelper{
    private init(){}
    static func showAlert(_ message:String,_ currentVC:UIViewController){
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        DispatchQueue.main.async {
          currentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    static func setEmptyString(_ defaultStr:String,_ textField:UITextField){
        if(textField.text == defaultStr){
            textField.text = ""
        }
    }
    
    static func setDefaultString(_ defaultStr:String,_ textfield:UITextField){
        if(textfield.text == ""){
            textfield.text = defaultStr
        }
    }
    
   static func notNullOrEmpty(_ uiTF:UITextField?) -> Bool{
        guard uiTF != nil && uiTF!.text != nil && uiTF!.text != "" else {
            return false
        }
        return true
    }
}
