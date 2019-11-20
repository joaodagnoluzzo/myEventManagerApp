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
        setupCheckinButton()
        
    }
    
    func setupCheckinButton(){
        
        self.checkinButton
        .rx
        .tap
            .subscribe(onNext:{
                [weak self] in
                
                
                guard let eventId = self?.event?.id else { return }
                
                //present modal view for checkin
                print("checkin")
                self?.eventViewModel.applyCheckin(eventId: eventId,  name: "test", email: "test@mail.com")
                
            }).disposed(by: disposeBag)
        
    }
    
    func setupShareButton(){
        self.shareButton
        .rx
        .tap
            .subscribe(onNext:{
                [weak self] in
                
                guard let eventImageToShare = self?.eventImageView.image, let eventTitleToShare = self?.title, let urlToShare = URL(string:(self?.event?.image!)!) else {
                    
                    let alertController = UIAlertController(title: "Erro", message: "Não foi possivel carregar as informações para compartilhar o evento.", preferredStyle: .alert)
                
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                    self?.present(alertController, animated: true, completion: nil)
                        
                
                    return
                }
                
                let activityViewController = UIActivityViewController(activityItems: [urlToShare, eventImageToShare, eventTitleToShare], applicationActivities: [])

                activityViewController.excludedActivityTypes = [.airDrop, .mail, .addToReadingList, .assignToContact, .markupAsPDF, .saveToCameraRoll]
                    
                self?.present(activityViewController, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
    }
    
}
