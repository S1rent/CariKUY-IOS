//
//  SearchViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[EventModel]>
    }
    
    let query: String
    let type: String
    
    init(query: String, type: String) {
        self.query = query
        self.type = type
    }
    
    public func transform(input: Input) -> Output {
        
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            let events: [EventModel] = EventRepository.shared.getAllEvents()
            
            if self.query != "" {
                var queryEvent: [EventModel] = []
                
                for event in events {
                    if event.eventName.lowercased().contains(self.query.lowercased()) {
                        queryEvent.append(event)
                    }
                }
                return Driver.just(queryEvent)
            } else if self.type != "" {
                var queryEvent: [EventModel] = []
                
                for event in events {
                    if event.eventType.lowercased() == self.type.lowercased() {
                        queryEvent.append(event)
                    }
                }
                return Driver.just(queryEvent)
            }
            
            return Driver.of([])
        }
        
        return Output(
            data: data
        )
    }
}
