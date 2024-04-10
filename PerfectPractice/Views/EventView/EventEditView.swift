//
//  EventEditView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/4/24.
//

import SwiftUI
import SwiftData

// TODO: ADD TAG COLOR SELECTION AND IF PASSED SYMBOL

struct EventEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Bindable var event:Event
    @Query var users:[User]
    @State private var showingAlert = false
    private let titleSize:CGFloat = 25
    private let gridSpacing:CGFloat = 16

    var body: some View {
        // Edit Event
        VStack (alignment: .leading, spacing: 0) {
            // Title
            HStack {
                Text("Event Information")
                    .font(.system(size: titleSize))
                    .fontWeight(.semibold)

                Spacer()
                /// is fav
                Button(action: {
                    event.isFav.toggle()
                }) {
                    Image(systemName: event.isFav ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.vertical, gridSpacing)
            .padding(.horizontal, gridSpacing)
            // Form
            Form {
                // Name
                Section {
                    TextField("Name", text: $event.name)
                } header: {
                    Text("name")
                }
                
                // Date
                Section {
                    DatePicker(
                        "Date", selection: $event.date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                } header: {
                    Text("Date")
                }
                
                // Location
                Section {
                    TextField("Location", text: $event.location)
                } header: {
                    Text("Location")
                }
                
                // Description
                Section {
                    TextField("Description", text: $event.eventDescription, axis: .vertical)
                } header: {
                    Text("Description")
                }
                
                // Tag
                Section {
                    HStack {
                        Text("Tag")
                        Spacer()
                        /// Menu to get text & circle next to each other.
                        Menu {
                            ForEach(tagColors, id:\.self) { tagColor in
                                Button(action: {
                                    event.tagColor = tagColor
                                }) {
                                    Text(tagColor.capitalized)
                                }
                            }
                        } label: {
                            HStack {
                                Circle()
                                    .foregroundStyle(Color(event.tagColor))
                                    .frame(width: 10, height: 10)
                                Text(event.tagColor.capitalized)
                                    .foregroundStyle(Color("TextColor"))
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                } header: {
                    Text("Tag")
                }
                
                // Delete Event
                Section {
                    Button(action: {
                        showingAlert = true
                    }) {
                        Text("Delete Event")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Delete Event"),
                            message: Text("Are you sure you want to delete this event? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteEvent(event: event)
                                presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                } header: {
                    Text("Delete Event")
                } footer: {
                    Text("This action cannot be undone.")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color("BackgroundColor"))
        .onAppear {
            // set default tag color
            if event.tagColor == "" {
                if users.first?.defaultTag != "" {
                    event.tagColor = users.first!.defaultTag
                } else {
                    event.tagColor = "blue"
                }
            }
        }
        .onDisappear {
            // If event name is empty, default event name
            if event.name == "" {
                event.name = "Event"
            }
        }
    }
    
    // Delete Self Event
    func deleteEvent(event: Event) {
        modelContext.delete(event)
    }
}


// Preview
/// ------------------------------------------------------------------------
#Preview {
    // Testing Container
    let testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self,
            Event.self,
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
        .environmentObject(ThemeManager())
        .environmentObject(SidebarManager())
        .environmentObject(UserManager())
}
