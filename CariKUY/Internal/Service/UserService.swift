//
//  UserService.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation

public class UserService {
    public static let shared = UserService()

    private var userData: AuthenticatedUser?
    private let userDefaultsKey = "carikuy_authenticated_user"
    
    private init() {
        if let rawData = UserDefaults.standard.value(forKey: userDefaultsKey) as? Data {
            self.userData = try? JSONDecoder().decode(AuthenticatedUser.self, from: rawData)
        }
    }
    
    func logout() {
        self.userData = nil
        
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    func registerUserSession(data: User) {
        if var user = UserService.shared.getUser() {
            user.userID = data.userID
            user.userEmail = data.userEmail
            user.userPassword = data.userPassword
            user.userName = data.userName
            user.userDescription = data.userDescription
            user.userProfilePicture = data.userProfilePicture
            
            UserService.shared.setUser(user)
        } else {
            let user = AuthenticatedUser(
                userID: data.userID,
                userEmail: data.userPassword,
                userPassword: data.userPassword,
                userName: data.userName,
                userDescription: data.userDescription,
                userProfilePicture: data.userProfilePicture
            )
            
            UserService.shared.setUser(user)
        }
        
    }
    
    func setUser(_ user: AuthenticatedUser?) {
        self.userData = user
        if let encodedData = try? JSONEncoder().encode(self.userData) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() -> AuthenticatedUser? {
        return self.userData
    }
}
