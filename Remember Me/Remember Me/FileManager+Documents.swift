//
//  FileManager+Documents.swift
//  Remember Me
//
//  Created by Isaac D. Hoyos on 05/10/26.
//  CMP 432: Mobile Programming for iOS.

import Foundation

extension FileManager {
    
    // Returns the app's documents directory for saving and loading files.
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
