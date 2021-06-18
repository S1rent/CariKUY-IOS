//
//  MyParticipationViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class MyParticipationViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[EventModel]>
    }
    
    func transform(input: Input) -> Output {
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<[EventModel]> in
            var events: [EventModel] = []
            let user = UserService.shared.getUser()
            let participationList = ParticipationRepository.shared.getParticipationListBySeekerID(id: user?.userID ?? "")
            
            if participationList.count == 0 {
                return Driver.just([])
            } else {
                for participation in participationList {
                    events += EventRepository.shared.getEventByID(eventID: participation.eventID)
                }
                return Driver.just(events)
            }
        }
        
        return Output(
            data: data
        )
    }
}
