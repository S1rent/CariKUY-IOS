//
//  CreatorRepository.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import Foundation
import UIKit
import CoreData

class CreatorRepository {
    public static let shared = CreatorRepository()
    private init() { }
    
    func createCreator(userData: Creator) -> RegisterEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return RegisterEnum.errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.entity(forEntityName: CreatorEntityKey.entityName.rawValue, in: managedContext) {
            let create = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            create.setValue(userData.userID, forKey: CreatorEntityKey.id.rawValue)
            create.setValue(userData.userEmail, forKey: CreatorEntityKey.email.rawValue)
            create.setValue(userData.userName, forKey: CreatorEntityKey.name.rawValue)
            create.setValue(userData.userPassword, forKey: CreatorEntityKey.password.rawValue)
            create.setValue(userData.userDescription, forKey: CreatorEntityKey.description.rawValue)
            create.setValue(userData.userProfilePicture, forKey: CreatorEntityKey.profilePicture.rawValue)
            
            do {
                try managedContext.save()
            } catch {
                return RegisterEnum.errorFatal
            }
        }
        return RegisterEnum.successCreator
    }
    
    func getCreatorsByEmail(email: String) -> [Creator] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        var creatorList: [Creator] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: CreatorEntityKey.entityName.rawValue)
        query.predicate = NSPredicate(format: "creatorEmail = %@", email)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }
            
            result.forEach { user in
                let model = Creator(
                    id: user.value(forKey: CreatorEntityKey.id.rawValue) as? String ?? "",
                    email: user.value(forKey: CreatorEntityKey.email.rawValue) as? String ?? "",
                    password: user.value(forKey: CreatorEntityKey.password.rawValue) as? String ?? "",
                    name: user.value(forKey: CreatorEntityKey.name.rawValue) as? String ?? "-",
                    description: user.value(forKey: CreatorEntityKey.description.rawValue) as? String ?? "-",
                    profilePicture: user.value(forKey: CreatorEntityKey.profilePicture.rawValue) as? String ?? "-"
                )
                creatorList.append(model)
            }
        } catch {
            return []
        }
        
        return creatorList
    }
    
    func getCreatorsByID(id: String) -> [Creator] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        var creatorList: [Creator] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: CreatorEntityKey.entityName.rawValue)
        query.predicate = NSPredicate(format: "creatorID = %@", id)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }
            
            result.forEach { user in
                let model = Creator(
                    id: user.value(forKey: CreatorEntityKey.id.rawValue) as? String ?? "",
                    email: user.value(forKey: CreatorEntityKey.email.rawValue) as? String ?? "",
                    password: user.value(forKey: CreatorEntityKey.password.rawValue) as? String ?? "",
                    name: user.value(forKey: CreatorEntityKey.name.rawValue) as? String ?? "-",
                    description: user.value(forKey: CreatorEntityKey.description.rawValue) as? String ?? "-",
                    profilePicture: user.value(forKey: CreatorEntityKey.profilePicture.rawValue) as? String ?? "-"
                )
                creatorList.append(model)
            }
        } catch {
            return []
        }
        
        return creatorList
    }
    
    func editCreator(userData: Creator) -> UpdateProfileEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: CreatorEntityKey.entityName.rawValue)
        query.predicate = NSPredicate(format: "creatorEmail = %@", userData.userEmail)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return .errorFatal }
            
            if result.count == 0 {
                return .errorFatal
            } else {
                let create = result[0] as NSManagedObject
                
                create.setValue(userData.userID, forKey: CreatorEntityKey.id.rawValue)
                create.setValue(userData.userEmail, forKey: CreatorEntityKey.email.rawValue)
                create.setValue(userData.userName, forKey: CreatorEntityKey.name.rawValue)
                create.setValue(userData.userPassword, forKey: CreatorEntityKey.password.rawValue)
                create.setValue(userData.userDescription, forKey: CreatorEntityKey.description.rawValue)
                create.setValue(userData.userProfilePicture, forKey: CreatorEntityKey.profilePicture.rawValue)
                
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
