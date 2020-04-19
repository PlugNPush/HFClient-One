//
//  Database.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation
import SQLite
import StoreKit

class Database {
    
    // Static instance
    static let current = Database()
    
    // Properties
    private var db: Connection?
    let files = Table("files")
    let link = Expression<String>("link")
    let name = Expression<String>("name")
    let expiration = Expression<Date>("expiration")
    
    // Initialize
    init() {
        do {
            // Get database path
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                // Connect to database
                db = try Connection("\(path)/hiberfile.sqlite3")
                
                // Initialize tables
                try db?.run(files.create(ifNotExists: true) { table in
                    table.column(link, unique: true)
                    table.column(name)
                    table.column(expiration)
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Get files
    func getFiles() -> [(String, String, Date)] {
        // Initialize an array
        var list = [(String, String, Date)]()
        
        do {
            // Get algorithms data
            if let result = try db?.prepare(files.order(expiration.desc)) {
                // Iterate data
                for line in result {
                    // Create algorithm in list
                    list.append((try line.get(link), try line.get(name), try line.get(expiration)))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Return found algorithms
        return list
    }
    
    // Add a file
    func addFile(_ file: (String, String, Date)) {
        do {
            // Insert data
            let _ = try db?.run(files.insert(link <- file.0, name <- file.1, expiration <- file.2))
        } catch {
            print(error.localizedDescription)
        }
        
        // Check number of saves to ask for a review
        checkForReview()
    }
    
    // Delete history
    func clearHistory()  {
        do {
            // Delete data
            try db?.run(files.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Check for review
    func checkForReview() {
        // Check number of saves to ask for a review
//        let datas = UserDefaults.standard
//        let savesCount = datas.integer(forKey: "savesCount") + 1
//        datas.set(savesCount, forKey: "savesCount")
//        datas.synchronize()
//
//        if savesCount == 10 || savesCount == 50 || savesCount % 100 == 0 {
//            SKStoreReviewController.requestReview()
//        }
        print("Will not request a review.")
    }
    
}
