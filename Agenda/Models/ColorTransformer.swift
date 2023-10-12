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

class ColorTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? Color else { return nil }
        
        let comp = color.components
        let arr = [comp.red, comp.green, comp.blue, comp.alpha]
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


extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {

        typealias NativeColor = UIColor

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }
        
        return (r, g, b, a)
    }
}
