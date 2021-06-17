//
//  LoginEnum.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import Foundation

public enum LoginEnum: String {
    case errorFatal = "An error occured, please try again later."
    case errorEmptyEmail = "Email cannot be empty."
    case errorCredential = "Invalid Credentials.\nPlease check your email and password."
    case errorPasswordEmpty = "Password cannot be empty."
    case successSeeker = "Success seeker."
    case successCreator = "Success creator."
}
