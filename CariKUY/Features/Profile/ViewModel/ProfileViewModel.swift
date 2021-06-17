//
//  ProfileViewModel.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<ProfileModel>
    }
    
    public func transform(input: Input) -> Output {
        let data = input.loadTrigger.map { _ -> ProfileModel in
            return self.getProfileData()
        }
        
        return Output(data: data)
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
}
