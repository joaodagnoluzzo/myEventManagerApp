//
//  EventViewModel.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 15/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventViewModel {
    
    
    private let apiBaseEventURL = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    private let apiCheckinURL = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"
    
    
    
    public let events: BehaviorRelay<[Event]> = BehaviorRelay<[Event]>(value:[])
    
    public func fetchEvents(){
        
        let requestURL = URL(string: apiBaseEventURL)!
        
        let task = URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                //handle error
                print("Http error: \(error)")
                
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Event].self, from: data)
                    
                    self.events.accept(result)
                    
                } catch {
                    print("JSON Error: \(error)")
                }
            }
        })
        
        task.resume()
    }
    
}
