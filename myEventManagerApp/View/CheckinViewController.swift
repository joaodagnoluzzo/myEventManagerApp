//
//  CheckinViewController.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 20/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckinViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    private let disposeBag = DisposeBag()
    private let eventViewModel = EventViewModel()
    
    let lastResponseStatus: BehaviorRelay<ResponseStatus> = BehaviorRelay(value: ResponseStatus.ErrorMessage)
    
    
    public var eventId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupResponseBinding()
        setupConfirmButton()
        setupCancelButton()

    }
    
    func setupResponseBinding(){
        
        self.eventViewModel
        .lastResponseStatus
        .asObservable()
        .subscribe(onNext: {
            [weak self] status in
            self?.lastResponseStatus.accept(status)
        }).disposed(by: disposeBag)
    }
    
    
    
    func setupConfirmButton(){
        self.confirmButton
        .rx
        .tap
            .subscribe(onNext: {
                [weak self] in
                
                guard let eventId = self?.eventId, let name = self?.nameTextField.text, let email = self?.emailTextField.text else { return }
                
                self?.eventViewModel.applyCheckin(eventId: eventId, name: name, email: email)
                
                var title = "Erro"
                var message = "Não foi possível efetuar o Check-in!"
                if let status = self?.lastResponseStatus.value {
                    
                    if status == ResponseStatus.Success {
                        title = "Check-in"
                        message = "Check-in efetuado com sucesso! Aproveite o evento."
                    }
                }
                
                let checkinStatusMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                checkinStatusMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self?.presentingViewController?.dismiss(animated: true, completion: nil)
                }))
                    
                self?.present(checkinStatusMessage, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
    }
    
    func setupCancelButton(){
        
        self.cancelButton
        .rx
        .tap
            .subscribe(onNext:{
                [weak self] in
                
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
        
    }
    
    
    
    

}
