//
//  User.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import Foundation

public class User {
    public var userID: String
    public var userEmail: String
    public var userPassword: String
    public var userName: String
    public var userDescription: String
    public var userProfilePicture: String
    
    init(
        id: String,
        email: String,
        password: String,
        name: String,
        description: String,
        profilePicture: String
    ) {
        userID = id
        userEmail = email
        userPassword = password
        userName = name
        userDescription = description
        userProfilePicture = profilePicture
    }
}
