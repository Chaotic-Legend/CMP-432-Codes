//
//  DataManager.swift
//  Remember Me
//
//  Created by Isaac D. Hoyos on 05/10/26.
//  CMP 432: Mobile Programming for iOS.

import Foundation
import UIKit

class DataManager {
    
    // Provides a shared singleton instance for app-wide data access.
    static let shared = DataManager()
    
    // Defines the file path used to store the saved people data.
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("people.json")
    
    // Saves the array of Person objects to local storage using JSON encoding.
    func save(_ people: [Person]) {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath)
        } catch {
            print("Save Failed: \(error.localizedDescription)")
        }
    }

    // Loads and decodes the saved Person objects from local storage.
    func load() -> [Person] {
        do {
            let data = try Data(contentsOf: savePath)
            return try JSONDecoder().decode([Person].self, from: data)
        } catch {
            return []
        }
    }

    // Saves an image to disk and returns the generated filename.
    func saveImage(_ data: Data) -> String {
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.documentsDirectory.appendingPathComponent(filename)
        try? data.write(to: url)
        return filename
    }

    // Loads an image from disk using its filename.
    func loadImage(filename: String) -> UIImage? {
        let url = FileManager.documentsDirectory.appendingPathComponent(filename)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }

        return nil
    }
}
