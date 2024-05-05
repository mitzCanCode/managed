//
//  TaskCard.swift
//  Managed
//
//  Created by ΜΙΤΖ on 4/5/24.
//

import SwiftUI

struct taskCard: View {
    var key: String
    var tasks: [String:[String:String]]
    @State var dateColor: Color = Color(.systemGreen)
    var body: some View {
        if let task = tasks[key]{
            
            if let status = Int(task["status"] ?? "3"){
                
                VStack(alignment:.leading){
                    HStack{
                        Text(task["taskName"] ?? "Error fetching task name")
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
                    if ((task["description"]?.isEmpty) == nil){
                        Text(task["description"] ?? "Error fetching task description")
                            .lineLimit(3)
                            .font(.headline)
                            .foregroundStyle(Color(.systemGray))
                    }else{
                        Text("No description...")
                            .lineLimit(3)
                            .font(.headline)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    if !((task["deadline"]?.isEmpty) == nil){
                        HStack{
                            Spacer()
                            Text("Deadline: \(task["deadline"] ?? "Error fetching task deadline")")
                                .onAppear {
                                    // Get the current date
                                    let currentDate = Date()
                                    // Create a date formatter
                                    let dateFormatter = DateFormatter()
                                    // Set the desired date format
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    // Convert the date to string in the desired format
                                    let formattedDate = dateFormatter.string(from: currentDate)
                                    
                                    if task["deadline"]! > formattedDate {
                                        dateColor =  Color(.systemGreen)
                                    } else if task["deadline"]! < formattedDate{
                                        dateColor = Color(.systemRed)
                                    }else{
                                        dateColor = Color(.systemYellow)
                                    }
                                    
                                }
                                .foregroundStyle(dateColor)
                                .font(.footnote)

                        }
                    }
                        
                    
                }
                .padding()
                .blurredBackground()
            }
        }
    }
}



