//
//  Creator.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation

public class Creator: User {
    
    override init(
        id: String,
        email: String,
        password: String,
        name: String,
        description: String,
        profilePicture: String
    ) {
        super.init(id: id, email: email, password: password, name: name, description: description, profilePicture: profilePicture)
    }
}
