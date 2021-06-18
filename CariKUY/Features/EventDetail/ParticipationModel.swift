//
//  ParticipationModel.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation

public struct ParticipationModel {
    let seekerID: String
    let eventID: String
    let isAccepted: Double
    
    init(sID: String, eID: String, isA: Double) {
        self.seekerID = sID
        self.eventID = eID
        self.isAccepted = isA
    }
}
