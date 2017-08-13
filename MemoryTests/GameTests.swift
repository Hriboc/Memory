//
//  MemoryTests.swift
//  MemoryTests
//
//  Created by Hristijan Bocevski on 2017-08-03.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import XCTest
@testable import Memory

class GameTests: XCTestCase {
    
    var game : Game?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        game = Game()
    }
    
    // *** Game Logic tests
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsGameOver() {
        for _ in 1...10 {
            game?.markSolvedItems()
        }

        XCTAssert((game?.isGameOver())!)
    }
    
    func testIsSelectedPair() {
        game?.addSelection(position: 0)
        game?.addSelection(position: 1)
        
        XCTAssert(game?.isSelectedPair() == true)
    }
    
    func testGetFirstSelection() {
        game?.addSelection(position: 3)
        game?.addSelection(position: 5)
        
        let result = game?.getFirstSelection()
        
        XCTAssert(result == 3, "expected \(3) got \(result)")
    }
    
    func testNewGame() {
        game?.score = 6
        game?.addSelection(position: 4)
        game?.addSelection(position: 8)
        
        game?.newGame()
        
        XCTAssert(game?.score == 0, "expected 0 got \(game?.score)")
        XCTAssert(game?.isSelectedPair() == false)
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
