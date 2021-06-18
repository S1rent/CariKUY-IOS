//
//  HomeViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let jobs: Driver<[EventModel]>
        let scholars: Driver<[EventModel]>
        let competitions: Driver<[EventModel]>
        let otherEvents: Driver<[EventModel]>
    }
    
    public func transform(input: Input) -> Output {
        
        let jobList = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            
            return Driver.just(
                EventRepository.shared.getEventListByType(type: "Job")
            )
        }
        
        let scholarshipList = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            
            return Driver.just(
                EventRepository.shared.getEventListByType(type: "Scholarship")
            )
        }
        
        let competitionList = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            
            return Driver.just(
                EventRepository.shared.getEventListByType(type: "Competition")
            )
        }
        
        let otherEventList = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            
            return Driver.just(
                EventRepository.shared.getEventListByType(type: "Other")
            )
        }
        
        return Output(
            jobs: jobList,
            scholars: scholarshipList,
            competitions: competitionList,
            otherEvents: otherEventList
        )
    }
}
