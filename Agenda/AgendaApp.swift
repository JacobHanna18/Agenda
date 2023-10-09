//
//  AgendaApp.swift
//  Agenda
//
//  Created by Jacob Hanna on 18/09/2023.
//

import SwiftUI

@main
struct AgendaApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            SchedulesView()
                .modelContainer(persistenceController.container)
        }
    }
}
