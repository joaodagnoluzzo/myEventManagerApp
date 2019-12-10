//
//  EventModel.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 15/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import Foundation

// TODO: Aqui está só decodable, verificar se os models realmente precisam ser Decodable e Encodable (Codable)

// TODO: Todas as variáveis são realmente optionals? Elas podem não ser retornadas no backend? Tomar cuidado com isso. Quando se utilza 
// struct não necessariamente suas variáveis tem de ser optional. Na verdade 99% é ao contrario.

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

