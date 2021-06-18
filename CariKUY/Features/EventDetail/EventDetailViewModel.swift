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
    }
    
    struct Output {
        let creatorData: Driver<[User]>
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
        
        return Output(
            creatorData: creatorData
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
