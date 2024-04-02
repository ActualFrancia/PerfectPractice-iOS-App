//
//  EditProfileView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/1/24.
//

import SwiftUI
import SwiftData
import Collections


struct EditProfileView: View {
    @Bindable var user: User
    @State private var newPrimaryInstrument:String = ""
    @State private var newSecondaryInstrument:String = ""

    var body: some View {
        Form {
            // Name
            Section {
                TextField("Name", text: $user.name)
            } header: {
                Text("Name")
            }
            // Instruments
            // -----------------
            Section {
                // Primary Instruments
                HStack {
                    Text("Primary Instruments")
                    Spacer()
                    /// Selector
                    Menu {
                        ForEach(orderedInstrumentDict.keys, id:\.self) { category in
                            Menu {
                                ForEach(orderedInstrumentDict[category] ?? [], id:\.self) { instrument in
                                    Button(action: {
                                        newPrimaryInstrument = instrument
                                    }) {
                                        Text(instrument.capitalized)
                                    }
                                }
                            } label: {
                                Text(category.capitalized)
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                /// List Primary Instruments
                List {
                    ForEach(user.primaryInstruments ?? [], id:\.self) { instrument in
                        Text(instrument.capitalized)
                    }
                    .onDelete(perform: deletePrimaryInstruments)
                }
                // Secondary Instruments
                HStack {
                    Text("Secondary Instruments")
                    Spacer()
                    /// Selector
                    Menu {
                        ForEach(orderedInstrumentDict.keys, id:\.self) { category in
                            Menu {
                                ForEach(orderedInstrumentDict[category] ?? [], id:\.self) { instrument in
                                    Button(action: {
                                        newSecondaryInstrument = instrument
                                    }) {
                                        Text(instrument.capitalized)
                                    }
                                }
                            } label: {
                                Text(category.capitalized)
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                /// List Secondary Instruments
                List {
                    ForEach(user.secondaryInstruments ?? [], id:\.self) { instrument in
                        Text(instrument.capitalized)
                    }
                    .onDelete(perform: deleteSecondaryInstruments)
                }
            } header: {
                Text("Instruments")
            }
            // Default Instrument
            Section {
                Picker (selection: $user.defaultInstrument) {
                    if (user.defaultInstrument == "" ) {
                        Text("Select...").tag("")
                    }
                    ForEach(user.instrumentsPlayed, id:\.self) { instrument in
                        Text(instrument.capitalized).tag(instrument)
                    }
                } label: {
                    Text("Default Instrument")
                }
            } header: {
                Text("Default Practice Options")
            }
        }
        // OnChange of newPrimaryInstrument
        .onChange(of: newPrimaryInstrument) {
            if (newPrimaryInstrument != "") {
                /// Check if already in Primary Instruments or Secondary Instruments
                if (user.primaryInstruments?.contains(newPrimaryInstrument) != true) && (user.secondaryInstruments?.contains(newPrimaryInstrument) != true) {
                    user.primaryInstruments?.append(newPrimaryInstrument)
                }
                newPrimaryInstrument = ""
            }
        }
        // OnChange of newSecondaryInstrument
        .onChange(of: newSecondaryInstrument) {
            if (newSecondaryInstrument != "") {
                /// Check if already in Primary Instruments or Secondary Instruments
                if (user.primaryInstruments?.contains(newSecondaryInstrument) != true) && (user.secondaryInstruments?.contains(newSecondaryInstrument) != true) {
                    user.secondaryInstruments?.append(newSecondaryInstrument)
                }
                newSecondaryInstrument = ""
            }
        }
        // OnChange of all InstrumentedPlayed
        .onChange(of: user.instrumentsPlayed) {
            /// instrumentsPlayed is empty
            if user.instrumentsPlayed.isEmpty {
                user.defaultInstrument = ""
            }
            // current default instrument is deleted
            else if user.instrumentsPlayed.contains(user.defaultInstrument) != true {
                user.defaultInstrument = ""
            }
        }
    }
    
    // Delete Primary Instruments
    func deletePrimaryInstruments(_ indexSet: IndexSet) {
        for index in indexSet {
            user.primaryInstruments?.remove(at: index)
        }
    }
    
    // Delete Secondary Instruments
    func deleteSecondaryInstruments(_ indexSet: IndexSet) {
        for index in indexSet {
            user.secondaryInstruments?.remove(at: index)
        }
    }
}

#Preview {
    // Testing Container
    var testingModelContainer: ModelContainer = {
        let schema = Schema([
            Practice.self,
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    let name = "Jeff"
    let defIns = ""
    
    let user1 = User(name: name, primaryInstruments: [], secondaryInstruments: [], defaultInstrument: defIns)
    
    return EditProfileView(user: user1)
        .modelContainer(testingModelContainer)
}
