//
//  SeekerModel.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import Foundation

public class Seeker: User {
    public var seekerBirthDate: String
    public var seekerGender: String
    
    init(
        id: String,
        email: String,
        password: String,
        name: String,
        description: String,
        profilePicture: String,
        birthDate: String,
        gender: String
    ) {
        seekerBirthDate = birthDate
        seekerGender = gender
        super.init(id: id, email: email, password: password, name: name, description: description, profilePicture: profilePicture)
    }
}
