//
//  EventListTableViewController.swift
//  myEventManagerApp
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 15/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: Final class

class EventListTableViewController: UITableViewController {

    var eventViewModel = EventViewModel()
    
    private let disposeBag = DisposeBag()
    
    // TODO: Quem deveria segurar essa lista deveria ser o viewModel.
    
    let eventList: BehaviorRelay<[Event]> = BehaviorRelay(value: [])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        setupNavigationBar()
        setupBindings()
        setupCellConfig()
        setupCellTapHandling()
        
        eventViewModel.fetchEvents()
        
        tableView.tableFooterView = UIView()
        
    }
    
    // TODO: String oriented
    // TODO: private func
    
    func setupNavigationBar(){
        self.title = "Eventos"
    }
    
    // TODO: private func

    func setupCellConfig(){
        
        eventList
            .bind(to: tableView
            .rx
            .items(cellIdentifier: "eventCell", cellType: EventCell.self)){
                        row, event, cell in
                        cell.configureWithEvent(event: event)
        }.disposed(by: disposeBag)
        
    }
    
    // TODO: private func
    
    func setupBindings(){
        
        self.eventViewModel
            .events
            .asObservable()
            .subscribe(onNext: {
                [weak self] events in
                self?.eventList.accept(events)
            }).disposed(by: disposeBag)
    }
    
    // TODO: private func
    
    func setupCellTapHandling(){
        tableView
        .rx
            .modelSelected(Event.self)
            .subscribe(onNext: {
                [weak self] event in
                
                // TODO: Bloco muito grande. Muito dificil saber o que faz. Separar em métodos/classes afim de dividir a responsabilidade
                
                guard let selectedIndexPath = self?.tableView.indexPathForSelectedRow else { return }
                
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                
                guard let edvc = self?.storyboard?.instantiateViewController(identifier: "EventDetailViewController") as? EventDetailViewController else { return }
                
                edvc.event = self?.eventList.value[selectedIndexPath.row]
                
                self?.navigationController?.pushViewController(edvc, animated: true)
                
                
                
            }).disposed(by: disposeBag)
    }
}
