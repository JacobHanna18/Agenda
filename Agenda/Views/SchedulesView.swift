//
//  ContentView.swift
//  Agenda
//
//  Created by Jacob Hanna on 18/09/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var schedules : [Schedule]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(schedules, id: \.persistentModelID){ sch in
                    
                    Button {
                        print("tapped")
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
                    Button("New File", systemImage: "plus") {
                        
                    }
                }
            }
            .navigationTitle("Schedules")
            
        }
    }
    
}

