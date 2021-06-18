//
//  UpdateProfileEnum.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation

enum UpdateProfileEnum: String {
    case errorFatal = "An error occured, please try again later."
    case errorEmptyEmail = "Email cannot be empty."
    case errorEmailExist = "Email already exist."
    case errorInvalidEmailFormat = "Please input a valid email format."
    case errorPasswordEmpty = "Password cannot be empty."
    case errorGenderEmpty = "Please select your gender."
    case errorNameEmpty = "Name cannot be empty."
    case errorBirthdateEmpty = "Birthdate cannot be empty."
    case errorDescriptionEmpty = "Description cannot be empty."
    case errorPhoneNumberEmpty = "Phone number cannot be empty."
    case errorPasswordNotMatch = "Wrong password."
    case success = "Successfully edited your account."
}
