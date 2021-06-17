//
//  CreatorFactory.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation

class CreatorFactory {
    public static let shared = CreatorFactory()
    private init() { }
    
    func makeCreator(
        id: String,
        email: String,
        password: String,
        name: String,
        description: String,
        profilePicture: String
    ) -> Creator {
        return Creator(id: id, email: email, password: password, name: name, description: description, profilePicture: profilePicture)
    }
}
