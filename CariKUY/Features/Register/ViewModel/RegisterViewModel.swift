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
        let roleRelay: Driver<String>
        let nameRelay: Driver<String>
    }
    
    struct Output {
        let success: Driver<Bool>
        let errorMessage: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let combinedData = Driver.combineLatest(input.emailRelay, input.passwordRelay, input.roleRelay, input.nameRelay)
        
        let message = input.registerTrigger.withLatestFrom(combinedData).map { data -> RegisterEnum in
            
            let email = data.0.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = data.1.trimmingCharacters(in: .whitespacesAndNewlines)
            let role = data.2.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = data.3.trimmingCharacters(in: .whitespacesAndNewlines)
            
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
            } else if role == "" {
                return RegisterEnum.errorRoleEmpty
            }
            
            return self.createAccount(role: role, email: email, password: password, name: name)
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
    
    func createAccount(role: String, email: String, password: String, name: String) -> RegisterEnum {
        if role.lowercased() == "seeker" {
            let seeker: Seeker = SeekerFactory.shared.makeSeeker(id: generateID(), email: email, password: password, name: name, description: "-", profilePicture: "-", birthDate: "-", gender: "-")
            return SeekerRepository.shared.createSeeker(userData: seeker)
        } else {
            return RegisterEnum.errorFatal
        }
    }
    
    func generateID() -> String {
        return UUID().uuidString
    }
    
    func checkEmailExist(_ email: String) -> Bool {
        let seekerList = SeekerRepository.shared.getSeekersByEmail(email: email)
        return seekerList.count != 0 ? true : false
    }
}
