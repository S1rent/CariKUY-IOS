//
//  CreateEventViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateEventViewModel {
    struct Input {
        let submitTrigger: Driver<Void>
        let pictureTrigger: Driver<String>
        let requirementTrigger: Driver<String>
        let dateTrigger: Driver<String>
        let nameTrigger: Driver<String>
        let descriptionTrigger: Driver<String>
        let typeTrigger: Driver<String>
    }
    
    struct Output {
        let success: Driver<CreateEventEnum>
        let error: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let data = Driver.combineLatest(input.pictureTrigger, input.requirementTrigger, input.dateTrigger, input.nameTrigger, input.descriptionTrigger, input.typeTrigger)
        
        data.drive(onNext: { _ in
            print("TEST")
        })
        
        let result = input.submitTrigger.withLatestFrom(data).map { data -> CreateEventEnum in
            
            let pictureURL = data.0.trimmingCharacters(in: .whitespacesAndNewlines)
            let requirement = data.1.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = data.2.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = data.3.trimmingCharacters(in: .whitespacesAndNewlines)
            let desc = data.4.trimmingCharacters(in: .whitespacesAndNewlines)
            let type = data.5.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if name == "" || name == "-" {
                return .errorNameEmpty
            } else if type == "" || type == "-" {
                return .errorTypeEmpty
            } else if type != "Job" && type != "Scholarship" && type != "Competition" && type != "Other" {
                return .errorType
            } else if desc == "" {
                return .errorDescriptionEmpty
            } else if date == "" || date == "-" {
                return .errorDateEmpty
            }
            
            return self.createEvent(name: name, type: type, desc: desc, date: date, picture: pictureURL, requirement: requirement)
        }
        
        let success = result.filter { $0 == .success }.map {$0}
        
        let message = result.filter { $0 != .success }.map {$0.rawValue}
        
        return Output(
            success: success,
            error: message
        )
    }
    
    func createEvent(name: String, type: String, desc: String, date: String, picture: String, requirement: String) -> CreateEventEnum {
        let user = UserService.shared.getUser()
        
        return EventRepository.shared.createEvent(creatorID: user?.userID ?? "", date: date, desc: desc, id: UUID().uuidString, name: name, picture: picture, requirement: requirement, type: type)
    }
}
