//
//  CoreDataManager.swift
//  seatGeekSearch
//
//  Created by Michael Jester on 7/20/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {

  static let sharedInstance = CoreDataManager()
  private override init() {}
  
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "SeatGeekEvents")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  static func saveContext() {
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  // MARK: - CRUD operations for model objects to core data
  
  
  static func getSavedEventIds() -> [String] {
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"EventEntity")
    var results:[NSManagedObject] = []
    var savedEventIds: [String] = []
    do {
      results = try context.fetch(fetchRequest)
      for result in results {

        let idString = result.value(forKey: "id") as! String
        savedEventIds.append(idString)
      }
    } catch {
      
      print("error executing fetch request: \(error)")
    }
    return savedEventIds
  }
  
  static func addEvent(_ event: Event){
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    //only create the entry if one does not already exist for specified id
    if (!entryExists(entityName: "EventEntity", id: event.id)){
      if let eventEntity = NSEntityDescription.insertNewObject(forEntityName: "EventEntity", into: context) as? EventEntity {
        eventEntity.id = event.id
      }
      saveContext()
    }
  }
  
  static func deleteEvent(_ event: Event){
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"EventEntity")
    fetchRequest.predicate = NSPredicate(format: "id == %@", event.id)
    var results:[NSManagedObject] = []
    do {
      results = try context.fetch(fetchRequest)
      //should only be one element in the results array
      //but iterate through array of results anyway
      for result in results {
        context.delete(result)
      }
      saveContext()
    } catch {
      print("error executing fetch request: \(error)")
    }
    
  }
  
  //helper method used in merge operations
  private static func entryExists(entityName:String, id: String)->Bool{
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:entityName)
    fetchRequest.predicate = NSPredicate(format: "id == %@", id)
    var results:[NSManagedObject] = []
    do {
      results = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest)
    }
    catch {
      print("error executing fetch request: \(error)")
    }
    return results.count > 0
  }
}
