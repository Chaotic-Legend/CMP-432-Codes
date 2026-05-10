//
//  ContentView.swift
//  Mini To-Do Tracker
//
//  Created by Isaac D. Hoyos on 03/11/26.
//  CMP 432: Mobile Programming for iOS.

import SwiftUI

struct ContentView: View {
    
    // Stores all tasks in memory for the session.
    @State private var tasks: [String] = []
    
    // Holds the text entered by the user.
    @State private var taskInput: String = ""
    
    // Tracks the currently selected task.
    @State private var selectedTask: String? = nil
    
    // Returns the trimmed version of the user input.
    var trimmedInput: String {
        taskInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Checks whether the input already exists in the task list.
    var isDuplicate: Bool {
        tasks.contains { $0.lowercased() == trimmedInput.lowercased() }
    }
    
    // Determines whether the Add button should be disabled.
    var isInvalidInput: Bool {
        trimmedInput.isEmpty || isDuplicate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Displays the app title.
            Text("Mini To-Do Tracker")
                .font(.largeTitle)
                .bold()
            
            // Section for adding new tasks.
            VStack(alignment: .leading, spacing: 10) {
                Text("Add a Task")
                    .font(.headline)
                HStack {
                    TextField("Enter Task...", text: $taskInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add Task") {
                        addTask()
                    }
                    .disabled(isInvalidInput)
                    .buttonStyle(.borderedProminent)
                }
            }
            Divider()
            
            // Displays the list of tasks.
            Text("Your Tasks")
                .font(.headline)
            List {
                ForEach(tasks, id: \.self) { task in
                    HStack {
                        Text(task)
                            .padding(5)
                        Spacer()
                    }
                    .background(
                        task == selectedTask ? Color.blue.opacity(0.3) : Color.clear
                    )
                    .cornerRadius(5)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTask = (selectedTask == task) ? nil : task
                    }
                }
            }
            
            // Button to delete the selected task.
            Button("Delete Task") {
                deleteTask()
            }
            .disabled(selectedTask == nil)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        
        // Displays a persistent footer at the bottom of the screen.
        .safeAreaInset(edge: .bottom) {
            Text("CMP 432: Mobile Programming for iOS - Isaac D. Hoyos")
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
        }
    }
    
    // Adds a new task to the list and clears the input field.
    func addTask() {
        let newTask = trimmedInput
        tasks.insert(newTask, at: 0)
        taskInput = ""
    }
    
    // Removes the selected task from the list.
    func deleteTask() {
        guard let taskToDelete = selectedTask else { return }
        if let index = tasks.firstIndex(of: taskToDelete) {
            tasks.remove(at: index)
        }
        selectedTask = nil
    }
}

#Preview {
    ContentView()
}
