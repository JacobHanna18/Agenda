//
//  ScheduleEditor.swift
//  Agenda
//
//  Created by Jacob Hanna on 19/09/2023.
//

import SwiftUI
import SwiftData

struct ScheduleEditor: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable var schedule : Schedule
    
    @State var sheetPresented = false
    @State var sheetLesson : Lesson?
    
    @Query
    var lessons: [Lesson]
    
    init(schedule : Schedule) {
        self.schedule = schedule
        let id = schedule.persistentModelID
        let predicate = #Predicate<Lesson> {
            $0.schedule?.persistentModelID == id
        }

        _lessons = Query(filter: predicate, sort: \Lesson.name)
    }
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    // schedule name
                    HStack {
                        Text("Name:")
                            .font(.title2)
                            .padding(.horizontal, 5)
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                    TextField("name", text: $schedule.name.binding)
                        .textFieldStyle(MyTextFieldStyle())
                        .listRowSeparator(.hidden)
                    
                    // show notes
                    HStack {
                        Text("Show Notes:")
                            .font(.title2)
                            .padding(.horizontal, 5)
                        Spacer()
                        Toggle(isOn: $schedule.showNotes, label: {
                            EmptyView()
                        })
                        .padding()
                    }
                    .listRowSeparator(.hidden)
                    
                    HStack {
                        Text("Lessons:")
                            .font(.title2)
                            .padding(.horizontal, 5)
                        Spacer()
                        Button("", systemImage: "plus") {
                            let less = Lesson(schedule: schedule)
                            modelContext.insert(less)
                            
                            sheetLesson = less
                            sheetPresented = true
                        }
                    }
                    .listRowSeparator(.hidden)
                    ForEach(lessons, id: \.persistentModelID) { less in
                        Button {
                            sheetLesson = less
                            sheetPresented = true
                        } label: {
                            ZStack {
                                HStack {
                                    Text(less.name ?? "")
                                        .foregroundStyle(less.textColor ?? Color.black)
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
                        }
                        .listRowBackground(Rectangle().fill(less.backgroundColor ?? Color.white).cornerRadius(6).padding(.vertical, 8).padding(.horizontal, 20))
                        
                    }
                    .listRowSeparator(.hidden)
                    
                }
                
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 70)
            }
            .sheet(isPresented: $sheetPresented, onDismiss: {
                try? modelContext.save()
            }, content: {
                if let less = sheetLesson {
                    LessonEditor(lesson: less)
                }
            })
            .navigationTitle("Edit Schedule")
        }
    }
}
