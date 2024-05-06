//
//  TaskDetail.swift
//  Managed
//
//  Created by ΜΙΤΖ on 6/5/24.
//

import SwiftUI

struct TaskDetail: View {
    var key: String
    @State var tasks: [String:[String:String]]
    @State var editedTaskName: String = ""
    @State var editedTaskDescription: String = ""
    @State var editedDeadline: Date = Date()
    @State var editedTaskStatus: String = "0"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let task = tasks[key] {
                    TextField("Task title", text: $editedTaskName)
                        .onAppear {
                            editedTaskName = task["taskName"] ?? "Error fetching task name"
                        }
                    DatePicker("Deadline", selection: $editedDeadline, displayedComponents: .date)
                        .onAppear {
                            // Convert the deadline string to Date and set it to editedDeadline
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            if let deadline = task["deadline"], let date = dateFormatter.date(from: deadline) {
                                editedDeadline = date
                            }
                        }
                    TextEditor(text: $editedTaskDescription)
                        .onAppear {
                            editedTaskDescription = task["description"] ?? "Error fetching task description"
                        }
                    HStack {
                        Text("Task status:")
                        Spacer()
                        Picker("Task status", selection: $editedTaskStatus) {
                            Text("Not Done").tag("0")
                            Text("In Progress").tag("1")
                            Text("Done").tag("2")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
        }
    }
    
    func saveChanges() {
        guard var task = tasks[key] else { return }
        
        // Update task details with edited values
        task["taskName"] = editedTaskName
        task["description"] = editedTaskDescription
        
        // Convert edited deadline to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDeadline = dateFormatter.string(from: editedDeadline)
        task["deadline"] = formattedDeadline
        
        // Update task status
        task["status"] = editedTaskStatus
        
        // Update tasks dictionary
        tasks[key] = task
        
        // Save updated tasks to UserDefaults
        UserDefaults.standard.set(tasks, forKey: "tasks")
    }
}
