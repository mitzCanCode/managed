//
//  HabitCard.swift
//  Managed
//
//  Created by ΜΙΤΖ on 5/5/24.
//

import SwiftUI

struct HabitCard: View {
    var key: String
    var habits: [String:[String:String]]
    @State var habitColor: Color = Color(.systemGreen)
    var body: some View {
        if let habit = habits[key]{
            
            if let status = Int(habit["status"] ?? "3"){
                
                VStack(alignment:.leading){
                    HStack{
                        Text(habit["habitName"] ?? "Error fetching habit name")
                            .font(.title2)
                            .lineLimit(2)

                        Spacer()
                        
                        
                        switch status{
                        case 0:
                            Text("Not Done")
                                .foregroundStyle(Color(.systemRed))
                        case 1:
                            Text("In progress")
                                .foregroundStyle(Color(.systemYellow))
                        case 2:
                            Text("Done")
                                .foregroundStyle(Color(.systemGreen))
                        case 3:
                            Text("Error")
                                .foregroundStyle(Color(.systemPurple))
                        default:
                            Text("Error")
                                .foregroundStyle(Color(.systemPurple))
                        }
                        
                        
                    }
                    if let description = habit["description"], !description.isEmpty {
                        Text(description)
                            .lineLimit(3)
                            .font(.headline)
                            .foregroundStyle(Color(.systemGray))
                    } else {
                        Text("No description...")
                            .lineLimit(3)
                            .font(.headline)
                            .foregroundStyle(Color(.systemGray))
                    }

                    if !((habit["time"]?.isEmpty) == nil){
                        HStack{
                            Spacer()
                            Text("Habit due at: \(habit["time"] ?? "Error fetching habit due time")")
                                .foregroundStyle(habitColor)

                                .onAppear {
                                    // Get the current date
                                    let time = Date()
                                    // Create a date formatter
                                    let dateFormatter = DateFormatter()
                                    // Convert the time to string in the desired format
                                    dateFormatter.dateFormat = "HH:mm"
                                    let formattedTime = dateFormatter.string(from: time)
                                    
                                    if habit["time"]! > formattedTime {
                                        habitColor =  Color(.systemGreen)
                                    } else if habit["time"]! < formattedTime{
                                        habitColor = Color(.systemRed)
                                    }else{
                                        habitColor = Color(.systemYellow)
                                    }
                                    
                                }
                        }
                    }
                    
                }
                .padding()
                .blurredBackground()
            }
        }
    }
}




