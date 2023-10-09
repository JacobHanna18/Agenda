//
//  ScheduleEditor.swift
//  Agenda
//
//  Created by Jacob Hanna on 19/09/2023.
//

import SwiftUI
import SwiftData

struct LessonEditor: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable var lesson : Lesson
    
    
    init(lesson : Lesson) {
        self.lesson = lesson
//        let id = schedule.persistentModelID
//        let predicate = #Predicate<Lesson> {
//            $0.schedule?.persistentModelID == id
//        }
//
//        _lessons = Query(filter: predicate, sort: \Lesson.name)
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
                    TextField("name", text: $lesson.name.binding)
                        .textFieldStyle(MyTextFieldStyle())
                        .listRowSeparator(.hidden)
                    
                    HStack {
                        Text("Note:")
                            .font(.title2)
                            .padding(.horizontal, 5)
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                    TextField("name", text: $lesson.note.binding)
                        .textFieldStyle(MyTextFieldStyle())
                        .listRowSeparator(.hidden)
                    
                    HStack {
                        Text("Background Color:")
                            .font(.title2)
                            .padding(.horizontal, 5)
                        Spacer()
                        ColorPicker("", selection: $lesson.backgroundColor.binding(Color.white))
                        .padding()
                    }
                    .listRowSeparator(.hidden)
                    
                    HStack {
                        Text("Text Color:")
                            .font(.title2)
                            .padding(.horizontal, 5)
                        Spacer()
                        ColorPicker("", selection: $lesson.textColor.binding(Color.black))
                        .padding()
                    }
                    .listRowSeparator(.hidden)
                    
                    
                    
                }
                
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 70)
            }
            .navigationTitle("Edit Lesson")
        }
    }
}
