//
//  HabitsView.swift
//  Managed
//
//  Created by ΜΙΤΖ on 5/5/24.
//

import SwiftUI

struct HabitsView: View {
    @State var habits: [String:[String:String]] = [:]
    @State var addHabitSheet: Bool = false
    @State var filterStatus: String? = nil
    @State private var searchText = ""
    
    
    var filteredHabits: [String: [String: String]] {
        if let status = filterStatus {
            if searchText == ""{
                return habits.filter { $0.value["status"] == status}
            } else {
                return habits.filter { $0.value["status"] == status && $0.value["habitName"]?.lowercased().starts(with: searchText.lowercased()) ?? false}
            }
        } else {
            if searchText == ""{
                return habits
            } else{
                return habits.filter {$0.value["habitName"]?.lowercased().starts(with: searchText.lowercased())  ?? false}
                
            }
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    if !filteredHabits.isEmpty{
                        ForEach(filteredHabits.keys.sorted(), id: \.self) { key in
                            
                            NavigationLink(destination: HabitDetail(key: key, habits: habits)){
                                HabitCard(key:key, habits: filteredHabits)
                                    .padding(.horizontal)
                                    .contextMenu{
                                        Button(role: .destructive, action: {
                                            deleteHabit(key: key)
                                        }, label: {
                                            Label("Delete", systemImage: "trash")
                                        })
                                        Menu{
                                            Button {
                                                habits[key]?["status"] = "0"
                                                UserDefaults.standard.set(habits, forKey: "habits")
                                                print(habits)
                                                
                                            } label: {
                                                Label("Not Done", systemImage: habits[key]?["status"] == "0" ? "x.circle.fill" : "x.circle")
                                            }
                                            
                                            Button {
                                                habits[key]?["status"] = "1"
                                                UserDefaults.standard.set(habits, forKey: "habits")
                                                print(habits)
                                                
                                            } label: {
                                                Label("In Progress", systemImage: habits[key]?["status"] == "1" ? "circle.dotted.circle.fill" : "circle.dotted.circle")
                                            }
                                            Button {
                                                habits[key]?["status"] = "2"
                                                UserDefaults.standard.set(habits, forKey: "habits")
                                                print(habits)
                                            } label: {
                                                Label("Done", systemImage: habits[key]?["status"] == "2" ? "checkmark.circle.fill" : "checkmark.circle")
                                            }
                                        } label: {
                                            Label("Change status", systemImage: "slider.horizontal.3")
                                        }
                                    }
                                    .onAppear{
                                        updateHabitStatusIfNeeded(key: key)
                                    }
                                
                            }
                                
                        }
                    } else {
                        Text("No habits to show")
                    }
                }
                
                
            }
            
            .searchable(text: $searchText, prompt: "Search habits")
            
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addHabitSheet = true
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
        .sheet(isPresented: $addHabitSheet, content: {
            AddHabit(addHabitSheet: $addHabitSheet, habits: $habits)  // Change here
                .presentationBackground(.thinMaterial)
        })
        .onChange(of: addHabitSheet){
            refreshHabits()
        }
        
        .onAppear{
            refreshHabits()
        }
    }
    func refreshHabits() {
        if let savedHabits = UserDefaults.standard.dictionary(forKey: "habits") as? [String: [String: String]] {
            habits = savedHabits
            print("Habits pulled successfully")
            print(habits)
        } else {
            print("Error fetching habits")
        }
        
        
    }
    
    func updateHabitStatusIfNeeded(key: String) {
        guard var habit = habits[key] else {
            return
        }
        
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        
        if habit["date"] != formattedDate {
            habit["date"] = formattedDate
            habit["status"] = "0"
            habits[key] = habit
            UserDefaults.standard.set(habits, forKey: "habits")
            print("Habit status updated for \(key)")
        }
    }
    
    func deleteHabit(key: String) {
        habits.removeValue(forKey: key)
        UserDefaults.standard.set(habits, forKey: "habits")
        refreshHabits()
    }
    
}
