//
//  DetailView.swift
//  Remember Me
//
//  Created by Isaac D. Hoyos on 05/10/26.
//  CMP 432: Mobile Programming for iOS.

import SwiftUI

struct DetailView: View {
    
    // Binds to the selected person so edits update the shared data.
    @Binding var person: Person
    
    // Binds to the full people list for updates and persistence.
    @Binding var people: [Person]
    
    // Controls whether the rename alert is shown.
    @State private var showingRenameAlert = false
    
    // Controls whether the delete confirmation alert is shown.
    @State private var showingDeleteAlert = false
    
    // Stores the new name entered by the user.
    @State private var newName = ""
    
    // Allows this view to dismiss itself when needed.
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            // Displays the person's saved image if it exists.
            if let image = DataManager.shared.loadImage(filename: person.imageFilename) {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 8)
            }
            
            // Displays the person's name.
            Text(person.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            Spacer()
            
            // Action buttons for renaming or deleting the person.
            HStack {
                
                // Opens rename alert.
                Button("Rename") {
                    newName = person.name
                    showingRenameAlert = true
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                
                // Opens delete confirmation alert.
                Button("Delete") {
                    showingDeleteAlert = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding()
        }
        .padding()
        
        // Sets navigation title for the detail screen.
        .navigationTitle("Remember Me")
        .navigationBarTitleDisplayMode(.inline)
        
        // Alert for renaming a person.
        .alert("Rename Photo", isPresented: $showingRenameAlert) {
            TextField("Name", text: $newName)
            Button("Save") {
                renamePerson()
            }
            Button("Cancel", role: .cancel) { }
        }
        
        // Alert for confirming deletion.
        .alert("Delete Photo?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deletePerson()
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    // Updates the person's name and saves changes.
    func renamePerson() {
        person.name = newName
        people.sort()
        DataManager.shared.save(people)
    }

    // Deletes the person and removes their image from storage.
    func deletePerson() {
        let imageURL = FileManager.documentsDirectory
            .appendingPathComponent(person.imageFilename)
        try? FileManager.default.removeItem(at: imageURL)
        people.removeAll { $0.id == person.id }
        DataManager.shared.save(people)
        dismiss()
    }
}

#Preview {
    DetailView(
        person: .constant(Person(name: "Example", imageFilename: "")),
        people: .constant([])
    )
}
