//
//  RegisterViewModel.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterViewModel {
    struct Input {
        let registerTrigger: Driver<Void>
        let emailRelay: Driver<String>
        let passwordRelay: Driver<String>
        let genderRelay: Driver<String>
        let nameRelay: Driver<String>
    }
    
    struct Output {
        let success: Driver<Bool>
        let errorMessage: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let combinedData = Driver.combineLatest(input.emailRelay, input.passwordRelay, input.genderRelay, input.nameRelay)
        
        let message = input.registerTrigger.withLatestFrom(combinedData).map { data -> RegisterEnum in
            
            let email = data.0
            let password = data.1
            let gender = data.2
            let name = data.3
            
            if email == "" {
                return RegisterEnum.errorEmptyEmail
            } else if email.starts(with: "@") {
                return RegisterEnum.errorInvalidEmailFormat
            } else if email.starts(with: ".") {
                return RegisterEnum.errorInvalidEmailFormat
            } else if !email.contains("@") {
                return RegisterEnum.errorInvalidEmailFormat
            } else if !email.contains(".") {
                return RegisterEnum.errorInvalidEmailFormat
            } else if self.checkEmailExist(email) {
                return RegisterEnum.errorEmailExist
            } else if name == "" {
                return RegisterEnum.errorNameEmpty
            } else if password == "" {
                return RegisterEnum.errorPasswordEmpty
            } else if gender == "" {
                return RegisterEnum.errorGenderEmpty
            }
            
            return RegisterEnum.success
        }
        
        let isSuccess = message.filter { $0 == .success }
                        .map { _ in
                            return true
                        }
        
        let errorMessage = message.filter { $0 != .success }
                           .map {
                               $0.rawValue
                           }
        
        return Output(
            success: isSuccess,
            errorMessage: errorMessage
        )
    }
    
    func generateID() -> String {
        return UUID().uuidString
    }
    
    func checkEmailExist(_ email: String) -> Bool {
        let seekerList = SeekerRepository.shared.getSeekersByEmail(email: email)
        return seekerList.count != 0 ? true : false
    }
}
