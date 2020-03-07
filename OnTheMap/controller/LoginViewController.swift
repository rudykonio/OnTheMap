//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 03/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var logInBTN: UIButton!{
        didSet{
               logInBTN.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var emailUITF: UITextField!
    @IBOutlet weak var passwordUITF: UITextField!
    let password = "  Password"
    let email = "  Email"
    let emptyString = ""
    @IBAction func emailTFBeginEditing(_ sender: Any) {
          if(emailUITF.text == email){
              emailUITF.text = emptyString
          }
    }
    
    @IBAction func emailTFEndEditing(_ sender: Any) {
        if(emailUITF.text == emptyString){
            emailUITF.text = email
        }
    }
    
    @IBAction func passwordTFBeginEditing(_ sender: Any) {
        if(passwordUITF.text == password){
            passwordUITF.text = emptyString
        }
    }
    
    @IBAction func passwordTFEndEditing(_ sender: Any) {
        if(passwordUITF.text == emptyString){
            passwordUITF.text = password
        }
    }
    @IBAction func logInClick(_ sender: Any) {
                if(notNullOrEmpty(emailUITF)&&notNullOrEmpty(passwordUITF)
                    && (emailUITF.text != email && passwordUITF.text != password)){
            NetworkHelper.logInSession(emailUITF,passwordUITF,self)
        }
    }
    
    @IBAction func signUpTFClick(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else {
            return
        }
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func notNullOrEmpty(_ uiTF:UITextField?) -> Bool{
        guard uiTF != nil && uiTF!.text != nil && uiTF!.text != emptyString else {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailUITF.delegate = self
        passwordUITF.delegate = self
        passwordUITF.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
}
