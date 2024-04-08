//
//  TodoEditView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/7/24.
//

import SwiftUI
import SwiftData

struct TodoEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Bindable var todo:ToDo
    @State private var showingAlert = false
    private let titleSize:CGFloat = 25
    private let gridSpacing:CGFloat = 16
    
    var body: some View {
        // Edit Todo
        VStack (alignment: .leading, spacing: 0) {
            // Title
            Text("Todo Information")
                .font(.system(size: titleSize))
                .fontWeight(.semibold)
                .padding(.vertical, gridSpacing)
                .padding(.horizontal, gridSpacing)
        }
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
