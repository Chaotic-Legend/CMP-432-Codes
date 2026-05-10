//
//  ContentView.swift
//  Remember Me
//
//  Created by Isaac D. Hoyos on 05/10/26.
//  CMP 432: Mobile Programming for iOS.

import PhotosUI
import SwiftUI

struct ContentView: View {
    
    // Loads the saved list of people when the view starts.
    @State private var people = DataManager.shared.load()
    
    // Stores the selected photo from the photo picker.
    @State private var selectedItem: PhotosPickerItem?
    
    // Temporarily holds image data before saving.
    @State private var inputImageData: Data?
    
    // Controls whether the name input alert is shown.
    @State private var showingNamePrompt = false
    
    // Stores the name entered by the user.
    @State private var newName = ""
    var body: some View {
        NavigationStack {
            
            // Displays the list of saved people.
            List {
                ForEach($people) { $person in
                    
                    // Navigates to a detail view when a person is tapped.
                    NavigationLink(destination: DetailView(person: $person, people: $people)) {
                        HStack {
                            
                            // Loads and displays the saved image if it exists.
                            if let image = DataManager.shared.loadImage(filename: person.imageFilename) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            
                            // Displays the person's name.
                            Text(person.name)
                        }
                    }
                }
                .onDelete(perform: deletePerson)
            }
            
            // Sets the navigation bar title.
            .navigationTitle("Remember Me")
            
            // Adds a button to select a photo.
            .toolbar {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Image(systemName: "plus")
                }
            }
            
            // Handles when a new photo is selected.
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                        inputImageData = data
                        showingNamePrompt = true
                    }
                }
            }
            
            // Prompts the user to enter a name for the selected photo.
            .alert("Name Photo", isPresented: $showingNamePrompt) {
                TextField("Name", text: $newName)
                
                // Saves the new person.
                Button("Save") {
                    saveNewPerson()
                }
                
                // Cancels the operation and resets inputs.
                Button("Cancel", role: .cancel) {
                    selectedItem = nil
                    inputImageData = nil
                    newName = ""
                }
            }
            
            // Displays a footer with course information.
            .safeAreaInset(edge: .bottom) {
                Text("CMP 432: Mobile Programming for iOS - Isaac D. Hoyos")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
    }

    // Saves a new person with their selected image and name.
    func saveNewPerson() {
        guard let data = inputImageData else { return }
        let filename = DataManager.shared.saveImage(data)
        let newPerson = Person(
            name: newName,
            imageFilename: filename
        )
        people.append(newPerson)
        people.sort()
        DataManager.shared.save(people)
        newName = ""
        inputImageData = nil
        selectedItem = nil
    }

    // Deletes a person and removes their stored image.
    func deletePerson(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            let imageURL = FileManager.documentsDirectory
                .appendingPathComponent(person.imageFilename)
            try? FileManager.default.removeItem(at: imageURL)
            people.remove(at: offset)
        }
        DataManager.shared.save(people)
    }
}

#Preview {
    ContentView()
}
