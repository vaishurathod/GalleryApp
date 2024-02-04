//
//  UserData+CoreDataProperties.swift
//  GalleryApp_o2h
//
//  Created by Apple on 04/02/24.
//
//

import Foundation
import CoreData


struct UserDataModel {
    var id: String?
    var lname: String?
    var fname: String?
    var imgUrl: String?
    var email: String?
}

extension UserData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var lname: String?
    @NSManaged public var fname: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var email: String?
    
    
    
    //------------------------------------------------------------------------------
    // MARK: - Fetch Record
    //------------------------------------------------------------------------------
    
    class func fetchAllRecords() -> [UserData]? {
        
        let fetchRequest = UserData.fetchRequest()
        
        do {
            let arr = try AppDelegate.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return arr
        } catch {
            print("\(self) - \(error.localizedDescription)")
            
            return nil
        }
    }
    
    class func fetchAllRecords(forId: String) -> [UserData]? {
        
        let fetchRequest = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", forId)
        
        do {
            let arr = try AppDelegate.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return arr
        } catch {
            print("\(self) - \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    //------------------------------------------------------------------------------
    // MARK: - Save Record
    //------------------------------------------------------------------------------
    
    class func saveRecord(_ tblData: [UserDataModel]) {
        
        for data in tblData {
            
            if let tempId = data.id {
                
                if let arrData = UserData.fetchAllRecords(forId: tempId),arrData.count > 0 {
                    
                    let tblData = arrData.first!
                    tblData.id = tempId
                    
                    if let lname = data.lname {
                        tblData.lname = lname
                    }
                    
                    if let fname = data.fname {
                        tblData.fname = fname
                    }
                    
                    if let email = data.email {
                        tblData.email = email
                    }
                    
                    if let imgUrl = data.imgUrl {
                        tblData.imgUrl = imgUrl
                    }
                    
                    do {
                        try AppDelegate.shared.persistentContainer.viewContext.save()
                        print("\(self) Updated Here => =>")
                    } catch {
                        print("\(self) Update Error Here => \(error.localizedDescription)")
                    }
                    
                } else {
                    
                    let viewContext = AppDelegate.shared.persistentContainer.viewContext
                    
                    let UserDataEntity = NSEntityDescription.entity(forEntityName: "UserData", in: viewContext)
                    
                    let UserDataObj = NSManagedObject(entity: UserDataEntity!, insertInto: viewContext) as! UserData
                    
                    UserDataObj.id = tempId
                    
                    if let lname = data.lname {
                        UserDataObj.lname = lname
                    }
                    
                    if let fname = data.fname {
                        UserDataObj.fname = fname
                    }
                    
                    if let email = data.email {
                        UserDataObj.email = email
                    }
                    
                    if let imgUrl = data.imgUrl {
                        UserDataObj.imgUrl = imgUrl
                    }
                    
                    do {
                        try viewContext.save()
                        print("\(self) Saved Here => =>")
                    } catch {
                        print("\(self) Save Error Here => \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Delete All Record
    //------------------------------------------------------------------------------
    
    class func deleteAllRecords() {
        
        let context = AppDelegate.shared.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    class func deleteRecord(forId: String) {
        
        let fetchRequest = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", forId)
        
        do {
            
            let arrData = try
            AppDelegate.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if arrData.count > 0 {
                AppDelegate.shared.persistentContainer.viewContext.delete(arrData.first!)
                print("\(self) : Record Deleted : \(forId)")
                
            }
            
        } catch {
            print("\(self) Delete = \(error.localizedDescription)")
        }
    }
}
