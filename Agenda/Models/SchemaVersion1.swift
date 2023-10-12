//
//  SchemaVersion2.swift
//  Agenda
//
//  Created by Janan Hanna on 09/10/2023.
//

import Foundation
import SwiftData
import SwiftUI

enum VersionedSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Slot.self, Schedule.self, Lesson.self]
    }

    @Model public class Slot {
        var customNote: String = ""
        var day: Int = 0
        var hour: Int = 0
        var lesson: Lesson? = nil
        

        init(){}
        init(customNote: String, day: Int, hour: Int, lesson: Lesson?) {
            self.customNote = customNote
            self.day = day
            self.hour = hour
            self.lesson = lesson
        }
        
    }
    
    @Model public class Schedule {
        var dateAdded: Date = Date()
        var forcedDays: [Int : Bool] = [:]
        var name: String = ""
        var showNotes: Bool = true
        @Relationship() var lessons: [Lesson] = []
        
        init(){}
        init(dateAdded: Date, forcedDays: [Int : Bool], name: String, showNotes: Bool, lessons: [Lesson]) {
            
            self.dateAdded = dateAdded
            self.forcedDays = forcedDays
            
            self.name = name
            self.showNotes = showNotes
            
            self.lessons = lessons
            
        }
    }

    
    @Model public class Lesson {
        
        var name: String = ""
        var note: String = ""
        
        @Attribute(.transformable(by: ColorTransformer.name.rawValue)) var backgroundColor: Color? = nil
        @Attribute(.transformable(by: ColorTransformer.name.rawValue)) var textColor: Color? = nil
        
        var schedule: Schedule? = nil
        @Relationship(inverse: \Slot.lesson) var slots: [Slot] = []
        
        init(){}
        init(name: String, note: String, backgroundColor: Color?, textColor: Color?, schedule: Schedule? = nil, slots: [Slot]) {

            self.name = name
            self.note = note
            
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            
            self.schedule = schedule
            self.slots = slots
        }
        
    }

}
