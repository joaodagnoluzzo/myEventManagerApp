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

// TODO: Deixar por padrão suas classes como final a não ser que você vá criar subclasses. O swift compiler faz algumas 
// otimizações de compilação

// TODO: DICA: Evitar usar Rx dado que a curva de aprendizado é muito alta no inicio. Tente aquiteturas como MVC normal ou 
// MVP.

class CheckinViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    private let disposeBag = DisposeBag()
    private let eventViewModel = EventViewModel()
    
    // TODO: Não faz sentido essa variável estar exposta dado que você não a modifica fora da classe
    
    var lastResponseStatus: ResponseStatus = ResponseStatus.ErrorMessage
    
    // TODO: Variável public. Ela pode ser apenas var. Com o uso de storyboards isso é um dos problemas que eles nos trazem. 
    // A injeção de dependência fica prejudicada.
    
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
            self?.lastResponseStatus = status
        }).disposed(by: disposeBag)
    }
    
    
    
    func setupConfirmButton(){
        self.confirmButton
        .rx
        .tap
            .subscribe(onNext: {

                
                [weak self] in
                
                // TODO: Bloco com muita responsabilidade. Está muito grande. Dificulta o entendimento do que ele realmente faz.
                // Abstrair a responsabilidades em métodos/classes
                
                guard let eventId = self?.eventId, let name = self?.nameTextField.text, let email = self?.emailTextField.text else { return }
                
                // TODO: Evitar string oriented programming. Usar uma classes para centralizar tudo ou usar Swiftgen ou R.swift por exemplo
                
                if name.isEmpty || email.isEmpty {
                    let emptyFieldMessage = UIAlertController(title: "Erro", message: "É necessário preencher todos os campos para fazer check-in", preferredStyle: .alert)
                    emptyFieldMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(emptyFieldMessage, animated: true, completion: nil)
                }
                
                self?.eventViewModel.applyCheckin(eventId: eventId, name: name, email: email)
                
                var title = "Erro"
                var message = "Não foi possível efetuar o Check-in!"
                
                // TODO: O state da tela poderia estar no didSet da variável e realizar o que deve ser feito em um switch case por exemplo
                
                if let status = self?.lastResponseStatus {
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

