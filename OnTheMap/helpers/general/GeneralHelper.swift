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
}
