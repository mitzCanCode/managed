//
//  HabitDetail.swift
//  Managed
//
//  Created by ΜΙΤΖ on 6/5/24.
//

import SwiftUI

struct HabitDetail: View {
    var key: String
    @State var habits: [String:[String:String]]
    @State var editedHabitTitle: String = ""
    @State var editedHabitDescription: String = ""
    @State var editedHabitTime: Date = Date()
    @State var editedHabitStatus: String = "0" // Default status, assuming "0" represents "Not Done"
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                if let habit = habits[key]{
                    TextField("Habit title", text: $editedHabitTitle)
                        .padding()
                        .blurredBackground()
                        .onAppear{
                            editedHabitTitle = habit["habitName"] ?? "Error fetching habit name"
                        }
                    
                    HStack {
                        Text("Habit time:")
                        Spacer()
                        DatePicker("", selection: $editedHabitTime, displayedComponents: .hourAndMinute)
                            .onAppear {
                                // Convert the habit time string to Date and set it to editedHabitTime
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "HH:mm"
                                if let habitTime = habit["time"], let time = dateFormatter.date(from: habitTime) {
                                    editedHabitTime = time
                                }
                            }
                    }
                    .padding()
                    .blurredBackground()
                    
                    TextEditor(text: $editedHabitDescription)
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .padding()
                        .blurredBackground()
                        .onAppear{
                            editedHabitDescription = habit["description"] ?? "Error fetching task description"
                        }
                    HStack {
                        Text("Habit status:")
                        Spacer()
                        Picker("Habit status", selection: $editedHabitStatus) {
                            Text("Not Done").tag("0")
                            Text("In Progress").tag("1")
                            Text("Done").tag("2")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .blurredBackground()
                }
            }
            .padding(.horizontal)
            
        }
        .navigationTitle("Edit habit")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
            }
        }
    }
    
    func saveChanges() {
        guard var habit = habits[key] else { return }
        
        // Update habit details with edited values
        habit["habitName"] = editedHabitTitle
        habit["description"] = editedHabitDescription
        
        // Convert edited habit time to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: editedHabitTime)
        habit["time"] = formattedTime
        
        // Update habit status
        habit["status"] = editedHabitStatus
        
        // Update habits dictionary
        habits[key] = habit
        
        // Save updated habits to UserDefaults
        UserDefaults.standard.set(habits, forKey: "habits")
    }
}
