//
//  SwipeToPracticeView.swift
//  PerfectPractice
//
//  Created by Kali Francia on 4/3/24.
//

import SwiftUI
import SwiftData

struct SwipeToPracticeView: View {
    @Binding var selectedView:PrimaryViews
    @State private var offset: CGFloat = 0
    @State private var isUnlocked:Bool = false
    @State private var maxOffset:CGFloat = 0
    private let capsuleSize:CGFloat = 70
    private let circleSizeOffset:CGFloat = 8
    private let horizontalPadding:CGFloat = 10
    
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geometry in
                ZStack (alignment: .leading) {
                    Text("Start Practicing")
                        .frame(maxWidth: .infinity, maxHeight: capsuleSize)
                        .background(.regularMaterial)
                    Capsule()
                        .foregroundStyle(.gray)
                        .frame(width: min(max(offset + capsuleSize, capsuleSize), maxOffset + capsuleSize), height: capsuleSize)
                    Image(systemName: "music.note")
                        .font(.system(size: 30))
                        .foregroundStyle(.ultraThickMaterial)
                        .frame(width: capsuleSize - circleSizeOffset, height: capsuleSize - circleSizeOffset)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .offset(x: min(max(offset + (circleSizeOffset/2), (circleSizeOffset/2)), maxOffset + (circleSizeOffset/2)))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation.width
                                    if (offset >= maxOffset) {
                                        print("AA")
                                        isUnlocked = true
                                    }
                                    else if (offset < maxOffset) {
                                        isUnlocked = false
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        /// locked
                                        if !isUnlocked {
                                            offset = 0
                                        }
                                        /// unlocked
                                        else {
                                            selectedView = PrimaryViews.practice
                                        }
                                    }
                                }
                        )
                }
                .clipShape(Capsule())
                .padding(.vertical, 1)
                .padding(.horizontal, horizontalPadding)
                .onAppear {
                    maxOffset = geometry.size.width - capsuleSize - (horizontalPadding * 2)
                }
            }
            .frame(height: capsuleSize)
        }
    }
}
    
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
}
