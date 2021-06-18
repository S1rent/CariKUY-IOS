//
//  CreateEventEnum.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation

public enum CreateEventEnum: String {
    case errorFatal = "An error has occured, please try again later."
    case errorNameEmpty = "Event name cannot be empty."
    case errorDescriptionEmpty = "Event description cannot be empty."
    case errorDateEmpty = "Event date cannot be empty."
    case errorTypeEmpty = "Event type cannot be empty."
    case errorType = "Event type can only be Job, Scholarship, Competition,  Other."
    case success = "Successfully create event."
}
