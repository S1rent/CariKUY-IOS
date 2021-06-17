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
    public var seekerPhoneNumber: String
    
    init(
        id: String,
        email: String,
        password: String,
        name: String,
        description: String,
        profilePicture: String,
        birthDate: String,
        gender: String,
        phoneNumber: String
    ) {
        seekerBirthDate = birthDate
        seekerGender = gender
        seekerPhoneNumber = phoneNumber
        super.init(id: id, email: email, password: password, name: name, description: description, profilePicture: profilePicture)
    }
}
