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

class EventListTableViewController: UITableViewController {

    var eventViewModel = EventViewModel()
    
    private let disposeBag = DisposeBag()
    
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
    
    func setupNavigationBar(){
        
        self.title = "Eventos"
    }
    

    // MARK: - Rx Setup
    func setupCellConfig(){
        
        eventList
            .bind(to: tableView
            .rx
            .items(cellIdentifier: "eventCell", cellType: EventCell.self)){
                        row, event, cell in
                        cell.configureWithEvent(event: event)
        }.disposed(by: disposeBag)
        
    }
    
    func setupBindings(){
        
        self.eventViewModel
            .events
            .asObservable()
            .subscribe(onNext: {
                [weak self] events in
                self?.eventList.accept(events)
            }).disposed(by: disposeBag)
    }
    
    func setupCellTapHandling(){
        tableView
        .rx
            .modelSelected(Event.self)
            .subscribe(onNext: {
                [weak self] event in
                
                guard let selectedIndexPath = self?.tableView.indexPathForSelectedRow else { return }
                
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                
                guard let edvc = self?.storyboard?.instantiateViewController(identifier: "EventDetailViewController") as? EventDetailViewController else { return }
                
                edvc.event = self?.eventList.value[selectedIndexPath.row]
                
                self?.navigationController?.pushViewController(edvc, animated: true)
                
                
                
            }).disposed(by: disposeBag)
    }
}
