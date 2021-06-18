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
    
    func getAllEvents() -> [EventModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext

        var eventList: [EventModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")

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
    
    func getEventListByType(type: String) -> [EventModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext

        var eventList: [EventModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        query.predicate = NSPredicate(format: "eventType = %@", type)

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
    
    func getEventByID(eventID: String) -> [EventModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext

        var eventList: [EventModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        query.predicate = NSPredicate(format: "eventID = %@", eventID)

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
    
    func deleteEventByID(eventID: String) -> CreateEventEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        let predicate = NSPredicate(format: "eventID = %@", eventID)
        query.predicate = predicate
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return .errorFatal }
            
            if result.count == 0 {
                return .errorFatal
            } else {
                let create = result[0] as NSManagedObject
                managedContext.delete(create)
                
                do {
                    try managedContext.save()
                }
                catch {
                    return .errorFatal
                }
            }
        } catch {
            return .errorFatal
        }
        
        return .success
    }
    
    func editEvent(eventID: String, date: String) -> CreateEventEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext

        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        query.predicate = NSPredicate(format: "eventID = %@", eventID)

        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return .errorFatal }

            if result.count == 0 {
                return .errorFatal
            } else {
                let create = result[0] as NSManagedObject

                create.setValue(date, forKey: "eventDate")

                do {
                    try managedContext.save()
                }
                catch {
                    return .errorFatal
                }
            }
        } catch {
            return .errorFatal
        }

        return .success
    }
}
