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
    var body: some View {
        if let task = tasks[key]{
            
            if let status = Int(task["status"] ?? "3"){
                
                VStack(alignment:.leading){
                    HStack{
                        Text(task["taskName"] ?? "Error fetching task name")
                            .font(.title)
                            .fontWeight(.semibold)
                            .kerning(1.2)
                        
                        Spacer()
                        
                        
                        switch status{
                        case 0:
                            Text("Not Done")
                        case 1:
                            Text("In progress")
                        case 2:
                            Text("Done")
                        case 3:
                            Text("Error")
                        default:
                            Text("Error")
                        }
                        
                        
                    }
                    Text(task["description"] ?? "Error fetching task description")
                        .lineLimit(3)
                    
                }
                .padding()
                .blurredBackground()
            }
        }
    }
}



