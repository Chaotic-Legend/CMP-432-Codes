//
//  Person.swift
//  Remember Me
//
//  Created by Isaac D. Hoyos on 05/10/26.
//  CMP 432: Mobile Programming for iOS.

import Foundation

// Represents a person stored in the app with a name and associated image.
struct Person: Codable, Identifiable, Comparable {
    
    // Unique identifier for each person.
    var id = UUID()
    
    // The display name of the person.
    var name: String
    
    // The filename of the saved image associated with the person.
    var imageFilename: String

    // Sorts people alphabetically by name.
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}
