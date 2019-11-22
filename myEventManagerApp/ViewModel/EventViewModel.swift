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

enum ResponseStatus {
    case ErrorMessage
    case InvalidJSON
    case InvalidRequest
    case Success
}

class EventViewModel {
    
    
    
    
    
    private let apiBaseEventURL = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    private let apiCheckinURL = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"
    
    
    
    public let events: BehaviorRelay<[Event]> = BehaviorRelay<[Event]>(value:[])
    public let lastResponseStatus: BehaviorRelay<ResponseStatus> = BehaviorRelay<ResponseStatus>(value: ResponseStatus.ErrorMessage)
    
    
    public func fetchEvents(){
    
        let requestURL = URL(string: apiBaseEventURL)!
        
        let task = URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
            
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode([Event].self, from: data)
                            self.events.accept(result)
                            
                            self.lastResponseStatus.accept(ResponseStatus.Success)
//                            print("Http response status: 200 Success")
                        
                        } catch {
                            self.lastResponseStatus.accept(ResponseStatus.InvalidJSON)
//                            print("JSON Error: \(error)")
                        }
                    }
                case 400:
                    self.lastResponseStatus.accept(ResponseStatus.InvalidRequest)
//                    print("Http response status: 404 Bad Request")
                default:
                    self.lastResponseStatus.accept(ResponseStatus.ErrorMessage)
//                    print("Http Response status: \(httpResponse.statusCode) Error")
//                    if let error = error {
//                        print("Error: \(error)")
//                    }
                }
            }
            
        })
        
        task.resume()
    }
    
    public func formatDate(dateInMilliseconds: Int?) -> String{
        
        guard let dateInMilliseconds = dateInMilliseconds else {return "--/--/----" }
        let date = Date(timeIntervalSince1970: (TimeInterval(dateInMilliseconds / 1000)))
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        
        return formatter.string(from: date)
    }
    
    public func formatPrice(price: Double?) -> String {
        
        guard let price = price else { return "R$ --.--" }
        
        print(price)
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
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse {
                
                    switch httpResponse.statusCode {
                    case 200:
                        self.lastResponseStatus.accept(ResponseStatus.Success)
//                        print("Http response status: 200 Success")
                    case 400:
                        self.lastResponseStatus.accept(ResponseStatus.InvalidRequest)
//                        print("Http response status: 404 Bad Request")
                    default:
                        self.lastResponseStatus.accept(ResponseStatus.ErrorMessage)
//                        print("Http Response status: \(httpResponse.statusCode) Error")
//                        if let error = error {
//                            print("Error: \(error)")
//                        }
                    }
                }
                
            })
            
            task.resume()
        } catch {
            
            // handle errors
        }
    }
    
}
