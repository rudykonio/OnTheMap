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
    var key:String?
    @IBOutlet weak var logInBTN: UIButton!{
        didSet{
               logInBTN.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var emailUITF: UITextField!
    @IBOutlet weak var passwordUITF: UITextField!
    let password = "  Password"
    let email = "  Email"
    @IBAction func emailTFBeginEditing(_ sender: Any) {
        GeneralHelper.setEmptyString(email,emailUITF)
    }
    
    @IBAction func emailTFEndEditing(_ sender: Any) {
        GeneralHelper.setDefaultString(email,emailUITF)
    }
    
    @IBAction func passwordTFBeginEditing(_ sender: Any) {
        GeneralHelper.setEmptyString(password, passwordUITF)
    }
    
    @IBAction func passwordTFEndEditing(_ sender: Any) {
        GeneralHelper.setDefaultString(password, passwordUITF)
    }
    @IBAction func logInClick(_ sender: Any) {
        if(GeneralHelper.notNullOrEmpty(emailUITF)&&GeneralHelper.notNullOrEmpty(passwordUITF)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailUITF.delegate = self
        passwordUITF.delegate = self
        passwordUITF.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! == "mapTableSegue"){
            (segue.destination as! TabBarController).key = self.key
        }
    }
}
