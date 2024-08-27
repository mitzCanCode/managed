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
    var body: some View {
        TabView {
            TaskView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Tasks")
                }
            HabitsView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Habits")
                }
        }
        .tint(Color.brown)
    }
}


#Preview {
    ContentView()
}
