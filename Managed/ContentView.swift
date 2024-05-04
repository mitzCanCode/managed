//
//  ContentView.swift
//  Managed
//
//  Created by ΜΙΤΖ on 4/5/24.
//

import SwiftUI

// MARK: Status meanings
// Status = 0 -> Not Done
// Status = 1 -> In progress
// Status = 2 -> Done


struct ContentView: View {
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
                VStack {
                    if !filteredTasks.isEmpty{
                    ForEach(filteredTasks.keys.sorted(), id: \.self) { key in
                        taskCard(key:key, tasks: filteredTasks)
                            .contextMenu{
                                Button(role: .destructive, action: {
                                    deleteTasks(key: key)
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                                Menu{
                                    Button {
                                        tasks[key]?["status"] = "0"
                                    } label: {
                                        Label("Not Done", systemImage: tasks[key]?["status"] == "0" ? "x.circle.fill" : "x.circle")
                                    }
                                    
                                    Button {
                                        tasks[key]?["status"] = "1"
                                    } label: {
                                        Label("In Progress", systemImage: tasks[key]?["status"] == "1" ? "circle.dotted.circle.fill" : "circle.dotted.circle")
                                    }
                                    Button {
                                        tasks[key]?["status"] = "2"
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

                .padding()
                
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
                    Menu {
                        Button(action: {
                            filterStatus = "0"
                        }) {
                            Label("Not Done", systemImage: "x.circle")
                        }
                        Button(action: {
                            filterStatus = "1"
                        }) {
                            Label("In Progress", systemImage: "circle.dotted.circle")
                        }
                        Button(action: {
                            filterStatus = "2"
                        }) {
                            Label("Done", systemImage: "checkmark.circle")
                        }
                        Button(action: {
                            filterStatus = nil
                        }) {
                            Label("Clear Filter", systemImage: "arrow.uturn.backward.circle")
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
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
    
    func deleteTasks(key: String) {
        tasks.removeValue(forKey: key)
        UserDefaults.standard.set(tasks, forKey: "tasks")
        refreshTasks()
    }

}


#Preview {
    ContentView()
}
