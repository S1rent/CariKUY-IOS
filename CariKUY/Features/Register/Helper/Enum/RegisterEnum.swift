//
//  RegisterEnum.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import Foundation

public enum RegisterEnum: String {
    case errorFatal = "An error occured, please try again later."
    case errorEmptyEmail = "Email cannot be empty."
    case errorEmailExist = "Email already exist."
    case errorInvalidEmailFormat = "Please input a valid email format."
    case errorPasswordEmpty = "Password cannot be empty."
    case errorGenderEmpty = "Please select your gender."
    case errorNameEmpty = "Name cannot be empty."
    case success = "Successfully created an account."
}
