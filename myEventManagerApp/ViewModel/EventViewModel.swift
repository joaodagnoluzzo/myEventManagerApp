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
    
    public func formatDate(dateInMilliseconds: Int?) -> String{
        
        guard let dateInMilliseconds = dateInMilliseconds else {return "00/00/0000" }
        let date = Date(timeIntervalSince1970: (TimeInterval(dateInMilliseconds / 1000)))
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        
        return formatter.string(from: date)
    }
    
    public func formatPrice(price: Double?) -> String {
        
        guard let price = price else { return "R$ --.--" }
        
        let result: String = "R$ \(price)"
        
        return result
    }
    
    func applyCheckin(eventId: String, name: String, email: String){
        
        
        guard let checkinURL = URL(string: self.apiCheckinURL) else { return }
        
        var checkinJson = [String: Any]()
        
        checkinJson["eventId"] = eventId
        checkinJson["name"] = name
        checkinJson["email"] = email
        
        do{
            let body = try JSONSerialization.data(withJSONObject: checkinJson, options: [])
            var request = URLRequest(url: checkinURL)

            request.httpMethod = "POST"
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request)
            
            task.resume()
        } catch {
            
            // handle errors
        }
    }
    
}
