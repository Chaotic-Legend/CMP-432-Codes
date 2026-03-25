//
//  ContentView.swift
//  Mini To-Do Tracker
//
//  Created by Isaac D. Hoyos on 3/11/26.
//  CMP 432: Mobile Programming for iOS.

import SwiftUI

struct ContentView: View {
    
    // Store tasks in an array.
    @State private var tasks: [String] = []
    
    // Store user input.
    @State private var taskInput: String = ""
    
    // Store the selected task.
    @State private var selectedTask: String? = nil
    
    // Trim whitespace from input.
    var trimmedInput: String {
        taskInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Check if the task is a duplicate.
    var isDuplicate: Bool {
        tasks.contains { $0.lowercased() == trimmedInput.lowercased() }
    }
    
    // Disable Add Task button if input is invalid.
    var isInvalidInput: Bool {
        trimmedInput.isEmpty || isDuplicate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Display the main title.
            Text("Mini To-Do Tracker")
                .font(.largeTitle)
                .bold()
            
            // Add Your Tasks section.
            VStack(alignment: .leading, spacing: 10) {
                Text("Add a Task")
                    .font(.headline)
                HStack {
                    // Input field for new tasks.
                    TextField("Enter Task...", text: $taskInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Create Add Task button.
                    Button("Add Task") {
                        addTask()
                    }
                    .disabled(isInvalidInput)
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Divider()
            
            // Task list section.
            Text("Your Tasks")
                .font(.headline)
            List {
                ForEach(tasks, id: \.self) { task in
                    HStack {
                        // Display task text.
                        Text(task)
                            .padding(4)
                        Spacer()
                    }
                    // Highlight selected task.
                    .background(
                        task == selectedTask ? Color.blue.opacity(0.3) : Color.clear
                    )
                    .cornerRadius(5)
                    // Make the row tappable.
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedTask == task {
                            selectedTask = nil
                        } else {
                            selectedTask = task
                        }
                    }
                }
            }
            
            HStack {
                Text("CMP 432: Mobile Programming for iOS - Isaac D. Hoyos")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Spacer()
                
                // Delete selected task button.
                Button("Delete Task") {
                    deleteTask()
                }
                .disabled(selectedTask == nil)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    // Add a new task to the list.
    func addTask() {
        let newTask = trimmedInput
        tasks.insert(newTask, at: 0)
        taskInput = ""
    }
    
    // Delete the selected task.
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
