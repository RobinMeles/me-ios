//
//  Register.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/15/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


struct Register: Decodable{
    
    var message : String?
    var errors : Errors?
    var accessToken: String?
    var success: Bool?
}


