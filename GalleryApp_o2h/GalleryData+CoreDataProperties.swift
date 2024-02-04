//
//  GalleryData+CoreDataProperties.swift
//  GalleryApp_o2h
//
//  Created by Apple on 04/02/24.
//
//

import Foundation
import CoreData


struct GalleryDataModel {
    var imgUrls: [String]?
    var id: String?
    var pageNo: Int?

}


extension GalleryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GalleryData> {
        return NSFetchRequest<GalleryData>(entityName: "GalleryData")
    }

    @NSManaged public var imgUrls: [String]?
    @NSManaged public var id: String?
    @NSManaged public var pageNo: String?

    
    //------------------------------------------------------------------------------
    // MARK: - Fetch Record
    //------------------------------------------------------------------------------
    
    class func fetchAllRecords() -> [GalleryData]? {
        
        let fetchRequest = GalleryData.fetchRequest()
        
        do {
            let arr = try AppDelegate.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return arr
        } catch {
            print("\(self) - \(error.localizedDescription)")
            
            return nil
        }
    }
    
    class func fetchAllRecords(forId: String) -> [GalleryData]? {
        
        let fetchRequest = GalleryData.fetchRequest()
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
    
    class func saveRecord(_ tblData: [GalleryDataModel]) {
        
        let viewContext = AppDelegate.shared.persistentContainer.viewContext


        for data in tblData {
            
            if let tempId = data.id {
                
                if let arrData = GalleryData.fetchAllRecords(forId: tempId),arrData.count > 0 {
                    
                    let tblData = arrData.first!
                    tblData.id = tempId
                    
                    if let imgUrls = data.imgUrls {
                        tblData.imgUrls = imgUrls
                    }
                    
                    do {
                          try viewContext.save()
                          print("\(self) Saved Here => =>")
                      } catch {
                          print("\(self) Save Error Here => \(error.localizedDescription)")
                      }
                    
                } else {
                    
                    let viewContext = AppDelegate.shared.persistentContainer.viewContext
                    
                    let galleryEntity = NSEntityDescription.entity(forEntityName: "GalleryData", in: viewContext)
                    
                    let galleryObj = NSManagedObject(entity: galleryEntity!, insertInto: viewContext) as! GalleryData
                    
                    galleryObj.id = tempId
                    
                    if let imgUrls = data.imgUrls{
                        galleryObj.imgUrls = imgUrls
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
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GalleryData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    class func deleteRecord(forId: String) {
        
        let fetchRequest = GalleryData.fetchRequest()
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


