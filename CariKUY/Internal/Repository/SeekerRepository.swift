//
//  SeekerRepository.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import Foundation
import UIKit
import CoreData

class SeekerRepository {
    public static let shared = SeekerRepository()
    private init() { }
    
    func createSeeker(userData: Seeker) -> RegisterEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return RegisterEnum.errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.entity(forEntityName: SeekerEntityKey.entityName.rawValue, in: managedContext) {
            let create = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            create.setValue(userData.userID, forKey: SeekerEntityKey.id.rawValue)
            create.setValue(userData.userEmail, forKey: SeekerEntityKey.email.rawValue)
            create.setValue(userData.userName, forKey: SeekerEntityKey.name.rawValue)
            create.setValue(userData.userPassword, forKey: SeekerEntityKey.password.rawValue)
            create.setValue(userData.seekerBirthDate, forKey: SeekerEntityKey.birthDate.rawValue)
            create.setValue(userData.userDescription, forKey: SeekerEntityKey.description.rawValue)
            create.setValue(userData.seekerGender, forKey: SeekerEntityKey.gender.rawValue)
            create.setValue(userData.userProfilePicture, forKey: SeekerEntityKey.profilePicture.rawValue)
            create.setValue(userData.seekerPhoneNumber, forKey: SeekerEntityKey.phoneNumber.rawValue)
            
            do {
                try managedContext.save()
            } catch {
                return RegisterEnum.errorFatal
            }
        }
        return RegisterEnum.successSeeker
    }
    
    func getSeekersByEmail(email: String) -> [Seeker] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        var seekerList: [Seeker] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: SeekerEntityKey.entityName.rawValue)
        query.predicate = NSPredicate(format: "seekerEmail = %@", email)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }
            
            result.forEach { user in
                let model = Seeker(
                    id: user.value(forKey: SeekerEntityKey.id.rawValue) as? String ?? "", email: user.value(forKey: SeekerEntityKey.email.rawValue) as? String ?? "",
                    password: user.value(forKey: SeekerEntityKey.password.rawValue) as? String ?? "",
                    name: user.value(forKey: SeekerEntityKey.name.rawValue) as? String ?? "-",
                    description: user.value(forKey: SeekerEntityKey.description.rawValue) as? String ?? "-",
                    profilePicture: user.value(forKey: SeekerEntityKey.profilePicture.rawValue) as? String ?? "-", birthDate: user.value(forKey: SeekerEntityKey.birthDate.rawValue) as? String ?? "-",
                    gender: user.value(forKey: SeekerEntityKey.gender.rawValue) as? String ?? "-",
                    phoneNumber: user.value(forKey: SeekerEntityKey.phoneNumber.rawValue) as? String ?? "-"
                )
                seekerList.append(model)
            }
        } catch {
            return []
        }
        
        return seekerList
    }
    
    func editSeeker(userData: Seeker) -> UpdateProfileEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: SeekerEntityKey.entityName.rawValue)
        query.predicate = NSPredicate(format: "seekerEmail = %@", userData.userEmail)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return .errorFatal }
            
            if result.count == 0 {
                return .errorFatal
            } else {
                let create = result[0] as NSManagedObject
                
                create.setValue(userData.userID, forKey: SeekerEntityKey.id.rawValue)
                create.setValue(userData.userEmail, forKey: SeekerEntityKey.email.rawValue)
                create.setValue(userData.userName, forKey: SeekerEntityKey.name.rawValue)
                create.setValue(userData.userPassword, forKey: SeekerEntityKey.password.rawValue)
                create.setValue(userData.seekerBirthDate, forKey: SeekerEntityKey.birthDate.rawValue)
                create.setValue(userData.userDescription, forKey: SeekerEntityKey.description.rawValue)
                create.setValue(userData.seekerGender, forKey: SeekerEntityKey.gender.rawValue)
                create.setValue(userData.userProfilePicture, forKey: SeekerEntityKey.profilePicture.rawValue)
                create.setValue(userData.seekerPhoneNumber, forKey: SeekerEntityKey.phoneNumber.rawValue)
                
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
