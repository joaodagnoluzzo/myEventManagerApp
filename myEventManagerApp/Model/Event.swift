//
//  EventModel.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 15/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import Foundation

struct Event: Decodable {

    let people: [Person]?
    let date: Int?
    let description: String?
    let image: String?
    let longitude: Float?
    let latitude: Float?
    let price: Double?
    let title: String?
    let id: String?
    let cupons: [Coupon]?
}

struct Person: Codable {
    let id: String?
    let eventId: String?
    let name: String?
    let picture: String?
}

struct Coupon: Codable {
    let id: String?
    let eventId: String?
    let discount: Int?
}

