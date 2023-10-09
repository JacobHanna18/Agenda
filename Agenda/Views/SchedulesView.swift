//
//  ContentView.swift
//  Agenda
//
//  Created by Jacob Hanna on 18/09/2023.
//

import SwiftUI
import SwiftData

struct SchedulesView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var schedules : [Schedule]
    
    @State var sheetPresented = false
    @State var sheetSchedule : Schedule?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(schedules, id: \.persistentModelID){ sch in
                    
                    Button {
                        sheetSchedule = sch
                        sheetPresented = true
                    } label: {
                        HStack {
                            Text(sch.name ?? "")
                                .padding(.leading, 28)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    // swipe actions
                                }
                            Spacer()
                            Label("", systemImage: "pencil.circle")
                            
                        }
                        .contextMenu {
                            // swipe actions
                        }
                    }
                    .listRowBackground(Rectangle().fill(Color.rowColor).cornerRadius(6).padding(.vertical, 8).padding(.horizontal, 20))
                    
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 70)
            //        .navigationDestination(isPresented: $presentSheet, destination: {
            //            // navigate
            //        })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New Schedule", systemImage: "plus") {
                        let sch = Schedule(name: "", showNotes: true, lessons: [])
                        modelContext.insert(sch)
                        sheetSchedule = sch
                        sheetPresented = true
                    }
                }
            }
            .sheet(isPresented: $sheetPresented, onDismiss: {
                try? modelContext.save()
            }, content: {
                if let sch = sheetSchedule {
                    ScheduleEditor(schedule: sch)
                }
            })
            .navigationTitle("Schedules")
            
        }
    }
    
}

