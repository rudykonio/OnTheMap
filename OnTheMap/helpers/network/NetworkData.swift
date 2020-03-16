//
//  MapObject.swift
//  OnTheMap
//
//  Created by Rodion Konioshko on 13/03/2020.
//  Copyright © 2020 Rodion Konioshko. All rights reserved.
//

import Foundation
 class NetworkData{
    private init(){}
    struct ResultsList:Codable {
        let results: [StudentInformation]
    }
    
    struct PostSessionObject:Codable {
        let account:Account
        let session:Session
        
        struct Account:Codable {
            let registered:Bool
            let key:String
        }
        
        struct Session:Codable {
            let id:String
            let expiration:String
        }
    }
}
