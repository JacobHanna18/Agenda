//
//  Schedule.swift
//  AgendaTwo
//
//  Created by Jacob Hanna on 18/09/2023.
//
//

import Foundation
import SwiftData
import UIKit

class ForcedDaysTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let forced = value as? [Int : Bool] else { return nil }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(forced) {
            return encoded
        }
        
        return nil
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        let decoder = JSONDecoder()
        if let encoded = try? decoder.decode([Int : Bool].self, from: data) {
            return encoded
        }

        return nil
    }
}


extension ForcedDaysTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: ForcedDaysTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = ForcedDaysTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
