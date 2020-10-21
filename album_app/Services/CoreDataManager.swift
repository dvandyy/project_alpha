//
//  CoreDataManager.swift
//  project_alpha
//
//  Created by Tomas Boda on 21/10/2020.
//

import UIKit
import CoreData

extension NSManagedObjectContext {
    static var current:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}


final class CoreDataManager {
    static let shared = CoreDataManager(moc: NSManagedObjectContext.current)
    
    var managedContext: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.managedContext = moc
    }
    
    //Get childs
    func getChilds() -> [Child] {
        var childs = [Child]()
        let childsRequest: NSFetchRequest<Child> = Child.fetchRequest() as! NSFetchRequest<Child>
        
        do {
            childs = try self.managedContext.fetch(childsRequest)
        }catch {
            print(error)
        }
        return childs
    }
    
    //Add child
    func addChild(id: UUID, name: String, birthDate: String) {
        let child = Child(context: self.managedContext)
        child.name = name
        child.birthDate = birthDate
        child.id = id
        
        do{
            try self.managedContext.save()
        }catch {
            print(error)
        }
    }
    
    //Remove child
    func removeChild(id: UUID) {
        let childsRequest: NSFetchRequest<Child> = Child.fetchRequest() as! NSFetchRequest<Child>
        childsRequest.predicate = NSPredicate.init(format: "id=%@", id.uuidString)
        
        do {
            let child = try self.managedContext.fetch(childsRequest).first!
            self.managedContext.delete(child)
        }catch {
            print(error)
        }
    }
    
}