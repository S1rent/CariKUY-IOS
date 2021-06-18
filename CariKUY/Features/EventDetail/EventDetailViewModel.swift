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
        
    }
    
    public func transform(input: Input) -> Output {
        return Output(
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
