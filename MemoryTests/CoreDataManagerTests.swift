//
//  CoreDataManagerTests.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-14.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import XCTest
@testable import Memory

class CoreDataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // *** Database performace tests
    
    func testFetchHighScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataManager = CoreDataManager.shared
        coreDataManager.managedContext = appDelegate.persistentContainer.viewContext
        
        self.measure {
            coreDataManager.fetchHighScores()
        }
    }
    
    func testSaveHighScore() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataManager = CoreDataManager.shared
        coreDataManager.managedContext = appDelegate.persistentContainer.viewContext
        
        self.measure {
            coreDataManager.saveHighScore(player: "Performance_Test", score: 20, gameType: "N/A")
        }
    }
    
}
