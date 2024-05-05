//
//  AddHabit.swift
//  Managed
//
//  Created by ΜΙΤΖ on 5/5/24.
//

import SwiftUI

struct AddHabit: View {
    @Binding var addHabitSheet: Bool
    @Binding var habits: [String:[String:String]]
    @State var habitName: String = ""
    @State var habitDescription: String = ""
    @State  var selectedTime = Date()
    

    var body: some View {
        VStack {
            TextField("Habit title", text: $habitName)
            HStack {
                Text("Habit time:")
                Spacer()
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
            TextEditor(text: $habitDescription)
            Button {
                addHabit(habitName: habitName, description: habitDescription, time: selectedTime)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
    
    func addHabit(habitName: String, description: String, time: Date) {
        var newHabitID: Int
        if let maxID = habits.keys.map({ Int($0) ?? 0}).max(){
            newHabitID = maxID + 1
            print(newHabitID)
        } else {
            newHabitID = 0
            print(newHabitID)
        }
        
        // Get the current date
        let currentDate = Date()
        // Create a date formatter
        let dateFormatter = DateFormatter()
        // Convert the time to string in the desired format
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        
        habits[String(newHabitID)] = ["habitName": habitName, "description": description, "status":"0", "time": formattedTime]
        UserDefaults.standard.set(habits, forKey: "habits")
        addHabitSheet = false
    }
}

