//
//  LoginViewModel.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
        let submitTrigger: Driver<Void>
        let emailRelay: Driver<String>
        let passwordRelay: Driver<String>
        let userDataRelay: Driver<String>
    }
    
    struct Output {
        let isSuccess: Driver<LoginEnum>
        let isValid: Driver<Int>
        let errorMessage: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let isSeeker = input.userDataRelay.map { email -> Int in
            
            //0 = seeker, 1 == creator
            let isSeeker = self.getSeekersByEmail(email)
            let isCreator = self.getCreatorsByEmail(email)
            
            if let _ = isSeeker {
                return 0
            } else if let _ = isCreator {
                return 1
            }
            return -1
        }
        
        let combinedData = Driver.combineLatest(input.emailRelay, input.passwordRelay)
        
        let message = input.submitTrigger.withLatestFrom(combinedData).map { data -> LoginEnum in
            
            let email = data.0.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = data.1.trimmingCharacters(in: .whitespacesAndNewlines)
            let isSeeker = self.getSeekersByEmail(email)
            let isCreator = self.getCreatorsByEmail(email)
            
            if email == "" {
                return LoginEnum.errorEmptyEmail
            } else if password == "" {
                return LoginEnum.errorPasswordEmpty
            } else if isSeeker == nil && isCreator == nil {
                return LoginEnum.errorCredential
            }
            
            if isSeeker != nil {
                guard let isSeeker = isSeeker else { return LoginEnum.errorFatal }
                UserService.shared.registerUserSession(data: isSeeker)
                return LoginEnum.successSeeker
            } else {
                guard let isCreator = isCreator else { return LoginEnum.errorFatal }
                UserService.shared.registerUserSession(data: isCreator)
                return LoginEnum.successCreator
            }
        }
        
        let isSuccess = message.filter { $0 == .successSeeker || $0 == .successCreator }.map { $0 }
        
        let errorMessage = message.filter { $0 != .successSeeker && $0 != .successCreator }.map {
                               $0.rawValue
                           }
        
        return Output(
            isSuccess: isSuccess,
            isValid: isSeeker,
            errorMessage: errorMessage
        )
    }
    
    func getSeekersByEmail(_ email: String) -> Seeker? {
        let seekerList = SeekerRepository.shared.getSeekersByEmail(email: email)
        return seekerList.count == 0 ? nil : seekerList[0]
    }
    
    func getCreatorsByEmail(_ email: String) -> Creator? {
        let creatorList = CreatorRepository.shared.getCreatorsByEmail(email: email)
        return creatorList.count == 0 ? nil : creatorList[0]
    }
}
