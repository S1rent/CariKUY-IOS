//
//  ParticipationRepository.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import Foundation
import UIKit
import CoreData

class ParticipationRepository {
    public static let shared = ParticipationRepository()
    private init() { }
    
    func createParticipation(eventID: String, isAccepted: Double, seekerID: String) -> ParticipationEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return ParticipationEnum.errorfatal }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.entity(forEntityName: "Participation", in: managedContext) {
            let create = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            create.setValue(eventID, forKey: "eventID")
            create.setValue(seekerID, forKey: "seekerID")
            create.setValue(isAccepted, forKey: "isAccepted")
            
            do {
                try managedContext.save()
            } catch {
                return ParticipationEnum.errorfatal
            }
        }
        return ParticipationEnum.success
    }
    
    func deleteParticipation(eventID: String, seekerID: String) -> ParticipationEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .errorfatal }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Participation")
        let predicateOne = NSPredicate(format: "seekerID = %@", seekerID)
        let predicateTwo = NSPredicate(format: "eventID = %@", eventID)
        query.predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicateOne, predicateTwo])
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return .errorfatal }
            
            if result.count == 0 {
                return .errorfatal
            } else {
                let create = result[0] as NSManagedObject
                managedContext.delete(create)
                
                do {
                    try managedContext.save()
                }
                catch {
                    return .errorfatal
                }
            }
        } catch {
            return .errorfatal
        }
        
        return .success
    }
    
    func getParticipationListBySeekerID(id: String) -> [ParticipationModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        var list: [ParticipationModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Participation")
        query.predicate = NSPredicate(format: "seekerID = %@", id)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }
            
            result.forEach { user in
                let model = ParticipationModel(
                    sID: user.value(forKey: SeekerEntityKey.id.rawValue) as? String ?? "", eID: user.value(forKey: "eventID") as? String ?? "", isA: user.value(forKey: "isAccepted") as? Double ?? 0
                )
                list.append(model)
            }
        } catch {
            return []
        }
        
        return list
    }
    
    func getParticipationListByEventID(id: String) -> [ParticipationModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        var list: [ParticipationModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Participation")
        query.predicate = NSPredicate(format: "eventID = %@", id)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }
            
            result.forEach { user in
                let model = ParticipationModel(
                    sID: user.value(forKey: SeekerEntityKey.id.rawValue) as? String ?? "", eID: user.value(forKey: "eventID") as? String ?? "", isA: user.value(forKey: "isAccepted") as? Double ?? 0
                )
                list.append(model)
            }
        } catch {
            return []
        }
        
        return list
    }
}
