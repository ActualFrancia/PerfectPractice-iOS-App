//
//  TodoWidget.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/5/24.
//

import SwiftUI
import SwiftData

// TODO: Get ride of animation on the showCompleted button.

struct TodoWidget: View {
    @State private var showCompleted:Bool = true
    private var gridSpacing: CGFloat = 6
    private var textSpacing: CGFloat = 10
    
    var body: some View {
        ScrollView (.vertical) {
            VStack {
                // Menu
                HStack (spacing: textSpacing) {
                    // Number
                    Text("0/2")
                        .fontWeight(.semibold)
                    // Item
                    Text("Item")
                        .fontWeight(.semibold)
                    Spacer()
                    // Show Completed
                    Button(action: {
                        showCompleted.toggle()
                    })  {
                        Image(systemName: showCompleted ? "checkmark.square.fill" : "square")
                        Text("Show Completed")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.plain)
                }
                // Item Listing
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

// Preview
/// ------------------------------------------------------------------------
#Preview {
    // Testing Container
    var testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self,
            Event.self,
            ToDo.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return ContentView()
        .modelContainer(testingModelContainer)
        .environmentObject(PracticeManager())
        .environmentObject(GlobalTimerManager())
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
}
