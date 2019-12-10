//
//  Checkin.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 16/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import Foundation


// TODO: Se você não for encodar, faz sentido esse model ser apenas Decodable.

struct Checkin : Codable {
    
    let eventId: String
    let name: String
    let email: String

}
