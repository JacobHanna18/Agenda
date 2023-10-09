//
//  context.swift
//  Agenda
//
//  Created by Jacob Hanna on 19/09/2023.
//

import Foundation
import SwiftData
import CoreData


struct PersistenceController {
    static let shared = PersistenceController()
    
    var container : ModelContainer
    
    init(inMemory: Bool = false) {
        //        container = NSPersistentContainer(name: "School_")
        //
        //        let appGroupContainer = FileManager.default.urls(for: .documentDirectory,
        //                                                                             in: .userDomainMask).first!
        //
        //        let url = appGroupContainer.appendingPathComponent("School_.sqlite")
        //
        //        if let description = container.persistentStoreDescriptions.first {
        //            description.url = url
        //            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        //        }
        //
        //        container.loadPersistentStores { storeDescription, error in
        //            if let error = error as NSError? {
        //                fatalError("Unresolved error \(error), \(error.userInfo)")
        //            }
        //        }
        //        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
        ColorTransformer.register()
        ForcedDaysTransformer.register()
        
        let appGroupContainer = NSPersistentContainer.defaultDirectoryURL()
        
        let url = appGroupContainer.appendingPathComponent("School_.sqlite")
        
        let fullSchema = Schema([
            Lesson.self,
            Schedule.self,
            Slot.self
        ])
        
        let sch = ModelConfiguration(
            schema: Schema([
                Lesson.self,
                Schedule.self,
                Slot.self
            ]),
            url: url
        )
        
        
        do {
            container = try ModelContainer(for: fullSchema, configurations: sch)
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
    }
    
}
