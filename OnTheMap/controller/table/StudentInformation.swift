//
//  DataObject.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 16/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
struct StudentInformation : Codable{
    let firstName:String
    let lastName:String
    let longitude:Double
    let latitude:Double
    let mapString:String
    let mediaURL:String
    let uniqueKey:String
    let objectId:String
    let createdAt:String
    let updatedAt:String
}
