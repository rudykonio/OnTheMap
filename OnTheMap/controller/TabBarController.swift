//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 12/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
class TabBarController : UITabBarController{
    var key:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshMap))
        let plus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        navigationItem.rightBarButtonItems = [refresh, plus]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut))
        navigationItem.hidesBackButton = true
    }
    
    @objc func addLocation() {
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    
    @objc func refreshMap(){
        if let mapVC  = self.viewControllers?[0] as! MapViewController?{
            NetworkHelper.handleStudentsLocationsMapController(mapVC)
        }

        if let tableVC  = self.viewControllers?[1] as! TableViewController?{
            NetworkHelper.handleStudentsLocationsTableController(tableVC)
        }
    }
    
    @objc func logOut(){
        NetworkHelper.logOutSession(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addLocation"){
            (segue.destination as! AddLocationNavController).key = self.key
        }
    }
}
