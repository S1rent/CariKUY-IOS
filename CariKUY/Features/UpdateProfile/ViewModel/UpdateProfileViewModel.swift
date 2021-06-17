//
//  UpdateProfileViewModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class UpdateProfileViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let emailTrigger: Driver<String>
        let nameTrigger: Driver<String>
        let descriptionTrigger: Driver<String>
        let phoneNumberTrigger: Driver<String>
        let newPasswordTrigger: Driver<String>
        let passwordTrigger: Driver<String>
        let imageTrigger: Driver<String>
        let genderTrigger: Driver<String>
        let birthDateTrigger: Driver<String>
        let editTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<ProfileModel>
        let success: Driver<UpdateProfileEnum>
        let erorr: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        let data = input.loadTrigger.map { _ -> ProfileModel in
            return self.getProfileData()
        }
        
        let combinedData = Driver.combineLatest(input.emailTrigger,input.nameTrigger, input.descriptionTrigger, input.phoneNumberTrigger, input.newPasswordTrigger, input.passwordTrigger, input.imageTrigger, input.genderTrigger)
        
        let finalData = Driver.combineLatest(combinedData, input.birthDateTrigger) {
            ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $1)
        }
        
        finalData.drive(onNext: { _ in
            print("")
        })
        
        let result = input.editTrigger.withLatestFrom(finalData).map { data -> UpdateProfileEnum in
            
            let user = UserService.shared.getUser()
            let userRole = self.checkUserRole(user?.userEmail ?? "")
            
            if userRole == -1 {
                return UpdateProfileEnum.errorFatal
            }
            
            var role = ""
            if userRole == 0 {
                role = "seeker"
            } else if userRole == 1 {
                role = "creator"
            } else {
                return UpdateProfileEnum.errorFatal
            }
            
            let email = data.0.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = data.1.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = data.2.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = data.3.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = data.4.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = data.5.trimmingCharacters(in: .whitespacesAndNewlines)
            let imageURL = data.6.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = data.7.trimmingCharacters(in: .whitespacesAndNewlines)
            let birthDate = data.8.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if self.checkUserRole(email) == 0 {
                if email == "" {
                    return UpdateProfileEnum.errorEmptyEmail
                } else if email.starts(with: "@") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if email.starts(with: ".") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if !email.contains("@") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if !email.contains(".") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if self.checkEmailExist(email) {
                    return UpdateProfileEnum.errorEmailExist
                } else if name == "" {
                    return UpdateProfileEnum.errorNameEmpty
                } else if description == "" || description == "-" {
                    return UpdateProfileEnum.errorDescriptionEmpty
                } else if phoneNumber == "" || phoneNumber == "-" {
                    return UpdateProfileEnum.errorPhoneNumberEmpty
                } else if gender == "" || gender == "-" {
                    return UpdateProfileEnum.errorGenderEmpty
                } else if birthDate == "" || birthDate == "-" {
                    return UpdateProfileEnum.errorBirthdateEmpty
                } else if password == "" {
                    return UpdateProfileEnum.errorPasswordEmpty
                } else if password != (user?.userPassword ?? password) {
                    return UpdateProfileEnum.errorPasswordNotMatch
                }
            } else if self.checkUserRole(email) == 1 {
                if email == "" {
                    return UpdateProfileEnum.errorEmptyEmail
                } else if email.starts(with: "@") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if email.starts(with: ".") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if !email.contains("@") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if !email.contains(".") {
                    return UpdateProfileEnum.errorInvalidEmailFormat
                } else if self.checkEmailExist(email) {
                    return UpdateProfileEnum.errorEmailExist
                } else if name == "" {
                    return UpdateProfileEnum.errorNameEmpty
                } else if description == "" || description == "-" {
                    return UpdateProfileEnum.errorDescriptionEmpty
                } else if password == "" {
                    return UpdateProfileEnum.errorPasswordEmpty
                } else if password != (user?.userPassword ?? password) {
                    return UpdateProfileEnum.errorPasswordNotMatch
                }
            }
            
            if newPassword == "" {
                return self.editAccount(id: user?.userID ?? "", role: role, email: email, password: password, name: name, description: description, phoneNumber: phoneNumber, imageURL: imageURL, gender: gender, birthDate: birthDate)
            } else {
                return self.editAccount(id: user?.userID ?? "", role: role, email: email, password: newPassword, name: name, description: description, phoneNumber: phoneNumber, imageURL: imageURL, gender: gender, birthDate: birthDate)
            }
        }
        
        let success = result.filter{ $0 == .success }.map{ $0 }
        
        let error = result.filter{ $0 != .success }.map{ $0.rawValue }
        
        return Output(
            data: data,
            success: success,
            erorr: error
        )
    }
    
    func editAccount(id: String, role: String, email: String, password: String, name: String, description: String, phoneNumber: String, imageURL: String, gender: String, birthDate: String) -> UpdateProfileEnum {
        if role.lowercased() == "seeker" {
            let seeker: Seeker = SeekerFactory.shared.makeSeeker(id: id, email: email, password: password, name: name, description: description, profilePicture: imageURL, birthDate: birthDate, gender: gender, phoneNumber: phoneNumber)
            
            let result = SeekerRepository.shared.editSeeker(userData: seeker)
            if result == .success {
                UserService.shared.registerUserSession(data: seeker)
            }
            return result
        } else if role.lowercased() == "creator" {
            let creator: Creator = CreatorFactory.shared.makeCreator(id: id, email: email, password: password, name: name, description: description, profilePicture: imageURL)

            let result = CreatorRepository.shared.editCreator(userData: creator)
            if result == .success {
                UserService.shared.registerUserSession(data: creator)
            }
            return result
        }
        return UpdateProfileEnum.errorFatal
    }
    
    private func getProfileData() -> ProfileModel {
        let user = UserService.shared.getUser()
        var otherItems: [(String, String)] = []
        
        let seeker = SeekerRepository.shared.getSeekersByEmail(email: user?.userEmail ?? "")
        
        if seeker.count != 0 {
            let seekerData = seeker[0]
            otherItems.append(("Gender", seekerData.seekerGender))
            otherItems.append(("Birth date", seekerData.seekerBirthDate))
            otherItems.append(("Phone number", seekerData.seekerPhoneNumber))
        }
        
        return ProfileModel(
            profileImageURL: user?.userProfilePicture ?? "-",
            profileName: user?.userName ?? "-",
            profileEmail: user?.userEmail ?? "-",
            profileDescription: user?.userDescription ?? "-",
            profileOtherItems: otherItems
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
    
    func checkEmailExist(_ email: String) -> Bool {
        let seekerList = SeekerRepository.shared.getSeekersByEmail(email: email)
        let creatorList = CreatorRepository.shared.getCreatorsByEmail(email: email)
        
        if seekerList.count == 0 && creatorList.count == 0 {
            return false
        }
        
        if seekerList.count != 0 {
            if seekerList[0].userEmail == email {
                return false
            }
        }
        
        if creatorList.count != 0 {
            if creatorList[0].userEmail == email {
                return false
            }
        }
        return true
    }
}
