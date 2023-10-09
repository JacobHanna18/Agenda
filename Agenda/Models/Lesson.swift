//
//  Lesson.swift
//  AgendaTwo
//
//  Created by Jacob Hanna on 18/09/2023.
//
//

import Foundation
import SwiftData
import SwiftUI
import UIKit


@Model public class Lesson {
    @Attribute(.transformable(by: ColorTransformer.name.rawValue)) var backgroundColor: Color?
    var name: String?
    var nonChanging: Int64?
    var note: String?
    @Attribute(.transformable(by: ColorTransformer.name.rawValue)) var textColor: Color?
    var schedule: Schedule?
    @Relationship(inverse: \Slot.lesson) var slots: [Slot]?
    

    init(backgroundColor: Color? = nil, name: String? = nil, note: String? = nil, textColor: Color? = nil, schedule: Schedule? = nil, slots: [Slot]? = nil) {

        self.name = name
        self.note = note
        
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        
        self.schedule = schedule
        self.slots = slots ?? []
        
        self.nonChanging = nil
    }
    
}


class ColorTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? Color else { return nil }
        
        let cic = UIColor(color).ciColor
        let arr = [cic.red, cic.green, cic.blue, cic.alpha]
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(arr) {
            return encoded
        }
        
        return nil
        
    }
        
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        let decoder = JSONDecoder()
        if let encoded = try? decoder.decode([CGFloat].self, from: data) {
            if encoded.count == 4 {
                return Color(red: encoded[0], green: encoded[1], blue: encoded[2], opacity: encoded[3])
            }
        }

        return nil
    }
}


extension ColorTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: ColorTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = ColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
