//
//  SeekerFactory.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation

class SeekerFactory {
    public static let shared = SeekerFactory()
    private init() { }
    
    func makeSeeker(
        id: String,
        email: String,
        password: String,
        name: String,
        description: String,
        profilePicture: String,
        birthDate: String,
        gender: String
    ) -> Seeker {
        return Seeker(id: id, email: email, password: password, name: name, description: description, profilePicture: profilePicture, birthDate: birthDate, gender: gender)
    }
}
