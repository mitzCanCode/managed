//
//  TaskView.swift
//  Managed
//
//  Created by ΜΙΤΖ on 5/5/24.
//

import SwiftUI

struct TaskView: View {
    @State var tasks: [String:[String:String]] = [:]
    @State var addTaskSheet: Bool = false
    
    @State var filterStatus: String? = nil
    @State private var searchText = ""
    
    
    var filteredTasks: [String: [String: String]] {
        if let status = filterStatus {
            if searchText == ""{
                return tasks.filter { $0.value["status"] == status}
            } else {
                return tasks.filter { $0.value["status"] == status && $0.value["taskName"]?.lowercased().starts(with: searchText.lowercased()) ?? false}
            }
        } else {
            if searchText == ""{
                return tasks
            } else{
                return tasks.filter {$0.value["taskName"]?.lowercased().starts(with: searchText.lowercased())  ?? false}
                
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    if !filteredTasks.isEmpty{
                        ForEach(filteredTasks.keys.sorted(), id: \.self) { key in
                            taskCard(key:key, tasks: filteredTasks)
                                .padding(.horizontal)
                                .contextMenu{
                                    Button(role: .destructive, action: {
                                        deleteTask(key: key)
                                    }, label: {
                                        Label("Delete", systemImage: "trash")
                                    })
                                    Menu{
                                        Button {
                                            tasks[key]?["status"] = "0"
                                            UserDefaults.standard.set(tasks, forKey: "tasks")
                                        } label: {
                                            Label("Not Done", systemImage: tasks[key]?["status"] == "0" ? "x.circle.fill" : "x.circle")
                                        }
                                        
                                        Button {
                                            tasks[key]?["status"] = "1"
                                            UserDefaults.standard.set(tasks, forKey: "tasks")
                                        } label: {
                                            Label("In Progress", systemImage: tasks[key]?["status"] == "1" ? "circle.dotted.circle.fill" : "circle.dotted.circle")
                                        }
                                        Button {
                                            tasks[key]?["status"] = "2"
                                            UserDefaults.standard.set(tasks, forKey: "tasks")
                                        } label: {
                                            Label("Done", systemImage: tasks[key]?["status"] == "2" ? "checkmark.circle.fill" : "checkmark.circle")
                                        }
                                    } label: {
                                        Label("Change status", systemImage: "slider.horizontal.3")
                                    }
                                }
                        }
                    } else {
                        Text("No tasks to show")
                    }
                }
            }
            
            .searchable(text: $searchText, prompt: "Search tasks")
            
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addTaskSheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Button(action: {
                        filterStatus = "0"
                    }) {
                        Label("Not Done", systemImage: "x.circle")
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Button(action: {
                        filterStatus = "1"
                    }) {
                        Label("In Progress", systemImage: "circle.dotted.circle")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button(action: {
                        filterStatus = "2"
                    }) {
                        Label("Done", systemImage: "checkmark.circle")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button(action: {
                        filterStatus = nil
                    }) {
                        Label("Clear Filter", systemImage: "arrow.uturn.backward.circle")
                    }
                }
                
            }
        }
        .sheet(isPresented: $addTaskSheet, content: {
            addTask(addTaskSheet: $addTaskSheet, tasks: $tasks)  // Change here
                .presentationBackground(.thinMaterial)
        })
        .onChange(of: addTaskSheet){
            refreshTasks()
        }
        
        .onAppear{
            refreshTasks()
        }
    }
    func refreshTasks() {
        if let savedTasks = UserDefaults.standard.dictionary(forKey: "tasks") as? [String: [String: String]] {
            tasks = savedTasks
            print("Tasks pulled succesfully")
            print(tasks)
        }else {
            print("error")
        }
    }
    
    func deleteTask(key: String) {
        tasks.removeValue(forKey: key)
        UserDefaults.standard.set(tasks, forKey: "tasks")
        refreshTasks()
    }
    
}
