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
        
        setupBindings()
        setupCellConfig()
        
        eventViewModel.fetchEvents()
        
        
        
//        tableView.register(EventCell.self, forCellReuseIdentifier:"cell")
        
//        tableView.tableFooterView = UIView()
        
    }

    // MARK: - Rx Setup
    func setupCellConfig(){
        
        eventList
            .bind(to: tableView
            .rx
            .items(cellIdentifier: "cell", cellType: EventCell.self)){
                        row, event, cell in
                        cell.configureWithEvent(event: event)
                print(event.title)
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
    
//    vc.selectedUser
//        .subscribe(onNext: { [weak self] user in
//            var list = self!.listOfUsers.value
//            list[selectedIndexPath.row] = user
//            self?.listOfUsers.accept(list)
//        }).disposed(by: self!.disposeBag)
    

}
