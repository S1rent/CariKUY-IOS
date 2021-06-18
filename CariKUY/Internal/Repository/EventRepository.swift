//
//  EventRepository.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import UIKit
import CoreData

class EventRepository {
    public static let shared = EventRepository()
    private init() { }
    
    func createEvent(creatorID: String, date: String, desc: String, id: String, name: String, picture: String, requirement: String, type: String) -> CreateEventEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return CreateEventEnum.errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext) {
            let create = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            create.setValue(creatorID, forKey: "creatorID")
            create.setValue(id, forKey: "eventID")
            create.setValue(date, forKey: "eventDate")
            create.setValue(desc, forKey: "eventDescription")
            create.setValue(name, forKey: "eventName")
            create.setValue(picture, forKey: "eventPictureURL")
            create.setValue(requirement, forKey: "eventRequirement")
            create.setValue(type, forKey: "eventType")
            
            do {
                try managedContext.save()
            } catch {
                return CreateEventEnum.errorFatal
            }
        }
        return CreateEventEnum.success
    }
    
    func getEventListByCreatorID(creatorID: String) -> [EventModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext

        var eventList: [EventModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        query.predicate = NSPredicate(format: "creatorID = %@", creatorID)

        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }

            result.forEach { user in
                let model = EventModel(
                    eventID: user.value(forKey: "eventID") as? String ?? "",
                    creatorID: user.value(forKey: "creatorID") as? String ?? "",
                    eventName: user.value(forKey: "eventName") as? String ?? "",
                    eventDate: user.value(forKey: "eventDate") as? String ?? "",
                    eventDesc: user.value(forKey: "eventDescription") as? String ?? "",
                    eventType: user.value(forKey: "eventType") as? String ?? "",
                    eventPicture: user.value(forKey: "eventPictureURL") as? String ?? "",
                    eventReq: user.value(forKey: "eventRequirement") as? String ?? ""
                )
                
                eventList.append(model)
            }
        } catch {
            return []
        }

        return eventList
    }
//
//    func editSeeker(userData: Seeker) -> UpdateProfileEnum {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .errorFatal }
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let query = NSFetchRequest<NSFetchRequestResult>(entityName: SeekerEntityKey.entityName.rawValue)
//        query.predicate = NSPredicate(format: "seekerEmail = %@", userData.userEmail)
//
//        do {
//            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return .errorFatal }
//
//            if result.count == 0 {
//                return .errorFatal
//            } else {
//                let create = result[0] as NSManagedObject
//
//                create.setValue(userData.userID, forKey: SeekerEntityKey.id.rawValue)
//                create.setValue(userData.userEmail, forKey: SeekerEntityKey.email.rawValue)
//                create.setValue(userData.userName, forKey: SeekerEntityKey.name.rawValue)
//                create.setValue(userData.userPassword, forKey: SeekerEntityKey.password.rawValue)
//                create.setValue(userData.seekerBirthDate, forKey: SeekerEntityKey.birthDate.rawValue)
//                create.setValue(userData.userDescription, forKey: SeekerEntityKey.description.rawValue)
//                create.setValue(userData.seekerGender, forKey: SeekerEntityKey.gender.rawValue)
//                create.setValue(userData.userProfilePicture, forKey: SeekerEntityKey.profilePicture.rawValue)
//                create.setValue(userData.seekerPhoneNumber, forKey: SeekerEntityKey.phoneNumber.rawValue)
//
//                do {
//                    try managedContext.save()
//                }
//                catch {
//                    return .errorFatal
//                }
//            }
//        } catch {
//            return .errorFatal
//        }
//
//        return .success
//    }
}
