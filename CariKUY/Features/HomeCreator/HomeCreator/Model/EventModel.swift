//
//  EventModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation

public struct EventModel {
    let eventID: String
    let creatorID: String
    let eventName: String
    let eventDate: String
    let eventDesc: String
    let eventType: String
    let eventPicture: String
    let eventReq: String
    
    init(
        eventID: String,
        creatorID: String,
        eventName: String,
        eventDate: String,
        eventDesc: String,
        eventType: String,
        eventPicture: String,
        eventReq: String
    ) {
        self.eventID = eventID
        self.creatorID = creatorID
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventDesc = eventDesc
        self.eventType = eventType
        self.eventPicture = eventPicture
        self.eventReq = eventReq
    }
}
