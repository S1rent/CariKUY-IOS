//
//  EventDetailViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class EventDetailViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let participateTrigger: Driver<Void>
    }
    
    struct Output {
        let creatorData: Driver<[User]>
        let successParticipate: Driver<(ParticipationEnum, Bool)>
    }
    
    let data: EventModel
    init(data: EventModel) {
        self.data = data
    }
    
    public func transform(input: Input) -> Output {
        let creatorData = input.loadTrigger.flatMapLatest { _ -> Driver<[User]> in
            let creator = CreatorRepository.shared.getCreatorsByID(id: self.data.creatorID)
            
            return Driver.just(creator)
        }
        
        let successParticipates = input.participateTrigger.flatMapLatest { _ -> Driver<(ParticipationEnum, Bool)> in
            
            var isRegistered = false
            let user = UserService.shared.getUser()
            let participationList = ParticipationRepository.shared.getParticipationListBySeekerID(id: user?.userID ?? "")
            
            for participation in participationList {
                if participation.eventID == self.data.eventID {
                    isRegistered = true
                }
            }
            
            if !isRegistered {
                return Driver.just((ParticipationRepository.shared.createParticipation(eventID: self.data.eventID, isAccepted: 0, seekerID: user?.userID ?? ""), true))
            } else {
                return Driver.just((ParticipationRepository.shared.deleteParticipation(eventID: self.data.eventID, seekerID: user?.userID ?? ""), false))
            }
        }
        
        return Output(
            creatorData: creatorData,
            successParticipate: successParticipates
        )
    }
    
    func checkUserRole(_ email: String) -> Int {
        let seekerList = SeekerRepository.shared.getSeekersByEmail(email: email)
        let creatorList = CreatorRepository.shared.getCreatorsByEmail(email: email)
        
        if seekerList.count != 0 {
            return 0
        } else if creatorList.count != 0 {
            return 1
        }
        return -1
    }
}
