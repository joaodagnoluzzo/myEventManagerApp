//
//  EventDetailViewController.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 17/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EventDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var checkinButton: UIBarButtonItem!
    
    
    private let eventViewModel = EventViewModel()
    private let disposeBag = DisposeBag()
    
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
        
        setupShareButton()
    }
    
    func setupCheckinButton(){
        
        self.checkinButton
        .rx
        .tap
            .subscribe(onNext:{
                [weak self] in
                
                //present modal view for checkin
                
            }).disposed(by: disposeBag)
        
    }
    
    func setupShareButton(){
        self.shareButton
        .rx
        .tap
            .subscribe(onNext:{
                [weak self] in
                
                let actionSheet = UIAlertController(title: "Compartilhar", message: nil, preferredStyle: .actionSheet)
                
                actionSheet.addAction(UIAlertAction(title: "Facebook", style: .default) { (UIAlertAction) in
                    print("facebook")
                })
                
                actionSheet.addAction(UIAlertAction(title: "Twitter", style: .default) { (UIAlertAction) in
                    print("twitter")
                })
                
                actionSheet.addAction(UIAlertAction(title: "Instagram", style: .default) { (UIAlertAction) in
                    print("instagram")
                })
                
                actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { (UIAlertAction) in
                    print("cancel")
                })
                
                self?.present(actionSheet, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
    }
    
}
