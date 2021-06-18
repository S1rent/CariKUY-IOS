//
//  HomeCreatorViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeCreatorViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[EventModel]>
    }
    
    public func transform(input: Input) -> Output {
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            let user = UserService.shared.getUser()
            
            let eventList = EventRepository.shared.getEventListByCreatorID(creatorID: user?.userID ?? "")
            return Driver.just(eventList)
        }
        
        return Output(
            data: data
        )
    }
}
