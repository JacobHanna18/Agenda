//
//  Extensions.swift
//  Agenda
//
//  Created by Jacob Hanna on 19/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    
    static let rowColor = Color("RowColor")
    
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
            )
    }
    
}


struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.title3)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.accentColor.opacity(0.5), lineWidth: 1).padding(1)
            )
    }
}


extension Binding<String?> {
    var binding : Binding<String> {
        Binding<String>.init {
            return self.wrappedValue ?? ""
        } set: { str in
            self.wrappedValue = str
        }
    }
}


extension Binding<Color?> {
    func binding (_ deff : Color) -> Binding<Color> {
        Binding<Color>.init {
            return self.wrappedValue ?? deff
        } set: { str in
            self.wrappedValue = str
        }
    }
}
