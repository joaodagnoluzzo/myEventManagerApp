//
//  EventDetailViewController.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 17/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private let eventViewModel = EventViewModel()
    
    public var event: Event? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let event = event else { return }
        
        self.title = event.title
        
        self.eventDateLabel.text = self.eventViewModel.formatDate(dateInMilliseconds: event.date)
        self.eventPriceLabel.text = self.eventViewModel.formatPrice(price: event.price)
        self.descriptionTextView.text = event.description
        self.eventImageView.load(url: URL(string: event.image!)!)
        self.eventImageView.contentMode = .scaleToFill
    }
    
}
