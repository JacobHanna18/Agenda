//
//  SchemaVersion1.swift
//  Agenda
//
//  Created by Janan Hanna on 09/10/2023.
//

import Foundation
import SwiftData
import SwiftUI
import CoreData

enum VersionedSchemaCoreData: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Slot.self, Schedule.self, Lesson.self]
    }

    @Model public class Slot {
        var customNote: String?
        var day: Int64?
        var hour: Int64?
        var lesson: Lesson?
        

        init(customNote: String? = nil, day: Int64? = nil, hour: Int64? = nil, lesson: Lesson? = nil) {
            self.customNote = customNote
            self.day = day
            self.hour = hour
            self.lesson = lesson
        }
        
        func SDSlot(_ less : VersionedSchemaV1.Lesson) -> VersionedSchemaV1.Slot {
            return VersionedSchemaV1.Slot(
                customNote: customNote ?? "",
                day: Int(day ?? 0),
                hour: Int(hour ?? 0),
                lesson: less)
        }
        
    }
    
    @Model public class Schedule {
        var createrName: String?
        var creatorUID: String?
        var dateAdded: Date?
        @Attribute(.transformable(by: ForcedDaysTransformer.name.rawValue)) var forcedDays: [Int : Bool]?
        var lastUpdated: Date?
        var name: String?
        var showNotes: Bool
        var syncingCode: String?
        @Relationship() var lessons: [Lesson]?
        

        init(dateAdded: Date? = nil, forcedDays: [Int : Bool]? = nil, name: String? = nil, showNotes: Bool = true, lessons: [Lesson]? = []) {
            
            self.dateAdded = Date()
            self.forcedDays = forcedDays ?? [:]
            
            self.name = name ?? ""
            self.showNotes = showNotes
            
            self.lessons = lessons
            
            self.lastUpdated = nil
            self.syncingCode = nil
            self.createrName = nil
            self.creatorUID = nil
        }
        
        func SDSchedule() -> VersionedSchemaV1.Schedule {
            return VersionedSchemaV1.Schedule(
                dateAdded: dateAdded ?? Date(),
                forcedDays: forcedDays ?? [:],
                name: name ?? "",
                showNotes: showNotes,
                lessons: [])
        }
    }

    
    @Model public class Lesson {
        @Attribute(.transformable(by: ColorTransformer.name.rawValue)) var backgroundColor: Color?
        var name: String?
        var nonChanging: Int64?
        var note: String?
        @Attribute(.transformable(by: ColorTransformer.name.rawValue)) var textColor: Color?
        var schedule: Schedule?
        @Relationship(inverse: \Slot.lesson) var slots: [Slot]?
        

        init(backgroundColor: Color? = nil, name: String? = nil, note: String? = nil, textColor: Color? = nil, schedule: Schedule? = nil, slots: [Slot]? = []) {

            self.name = name
            self.note = note
            
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            
            self.schedule = schedule
            self.slots = slots ?? []
            
            self.nonChanging = nil
        }
        
        func SDLesson (_ sch : VersionedSchemaV1.Schedule) -> VersionedSchemaV1.Lesson {
            return VersionedSchemaV1.Lesson(
                name: name ?? "",
                note: note ?? "",
                backgroundColor: backgroundColor,
                textColor: textColor,
                schedule: sch,
                slots: [])
        }
        
    }
    
    
    struct PersistenceController {
        static let shared = PersistenceController()
        
        var container : ModelContainer
        
        init(inMemory: Bool = false) {
            
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


}



struct MigrateView: View {
    
    @Query
    var schedules: [VersionedSchemaCoreData.Schedule]
    
    let coredataContext = VersionedSchemaCoreData.PersistenceController.shared
    @Environment(\.modelContext) var modelContext
    
    init() {
        for CDSch in schedules {
            let sch = CDSch.SDSchedule()
            modelContext.insert(sch)
            
            for CDless in CDSch.lessons ?? [] {
                let less = CDless.SDLesson(sch)
                modelContext.insert(less)
                
                for CDSlot in CDless.slots ?? [] {
                    let slot = CDSlot.SDSlot(less)
                    modelContext.insert(slot)
                }
            }
        }
    }
    
    var body: some View {
        EmptyView()
    }
}
