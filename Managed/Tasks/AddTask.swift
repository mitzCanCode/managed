//
//  AddTask.swift
//  Managed
//
//  Created by ΜΙΤΖ on 4/5/24.
//

import SwiftUI

struct addTask: View {
    @Binding var addTaskSheet: Bool
    @Binding var tasks: [String:[String:String]]  // Change here
    @State var taskName: String = ""
    @State var taskDescription: String = ""
    @State var selectedDeadline = Date()

    var body: some View {
        VStack {
            TextField("Task title", text: $taskName)
            HStack {
                Text("Deadline:")
                Spacer()
                DatePicker("", selection: $selectedDeadline, displayedComponents: .date)
            }
            TextEditor(text: $taskDescription)
            Button {
                addTask(taskName: taskName, description: taskDescription)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
    
    func addTask(taskName: String, description: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Set the desired date format
        
        let formattedDeadline = dateFormatter.string(from: selectedDeadline)
        
        var newTaskID: Int
        if let maxID = tasks.keys.map({ Int($0) ?? 0}).max(){
            newTaskID = maxID + 1
            print(newTaskID)
        } else {
            newTaskID = 0
            print(newTaskID)
        }
        tasks[String(newTaskID)] = ["taskName": taskName, "description": taskDescription, "deadline": formattedDeadline, "status":"0"]
        UserDefaults.standard.set(tasks, forKey: "tasks")
        addTaskSheet = false
    }
}
