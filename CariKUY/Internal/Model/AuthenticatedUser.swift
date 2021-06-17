//
//  AuthenticatedUser.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation

public struct AuthenticatedUser: Codable {
    public var userID: String?
    public var userEmail: String?
    public var userPassword: String?
    public var userName: String?
    public var userDescription: String?
    public var userProfilePicture: String?
    
    public enum CodingKeys: String, CodingKey {
        case userID = "session_userID"
        case userPassword = "session_userPassword"
        case userName = "session_userName"
        case userEmail = "session_userEmail"
        case userProfilePicture = "session_userPRofilePicture"
        case userDescription = "session_userDescription"
    }
}
