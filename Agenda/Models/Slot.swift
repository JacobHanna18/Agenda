//
//  Slot.swift
//  AgendaTwo
//
//  Created by Jacob Hanna on 18/09/2023.
//
//

import Foundation
import SwiftData


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
    
}
