//
//  CoreDataManager.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-13.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // needs to be set before calling any function
    var managedContext : NSManagedObjectContext?
    
    // Singelton
    static let shared = CoreDataManager()
    private init() {}
    
    // Save highscore to database if any presented
    func saveHighScore(player: String, score: Int, gameType: String) -> Bool {
        
        let description = NSEntityDescription.entity(forEntityName: "HighScore", in: managedContext!)!
        let entity = NSManagedObject(entity: description, insertInto: managedContext) as! HighScore
            
        entity.player = player
        entity.score = Int32(score)
        entity.gameType = gameType
            
        do {
            try managedContext?.save()
            return true
        }
        catch let error {
            NSLog("Failed saving highscore: \(error)")
            return false
        }
    }
    
    // Fetch highscores from database
    func fetchHighScores() -> String {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        
        var highScoresStr = ""
        do {
            let highScores = try managedContext?.fetch(request) as! [HighScore]
            let sortedHighScores = highScores.sorted(by: {$0.score > $1.score})
            
            for highScore in sortedHighScores {
                highScoresStr.append("\(highScore.player!)\t\(highScore.score)\t\t[\(highScore.gameType!)]\n")
            }
        }
        catch let error {
            NSLog("Failed getting highscores: \(error)")
        }
        
        return highScoresStr
    }
    
    // Delete all high scores from database
    func deleteHighScores () -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try managedContext?.execute(deleteRequest)
            return true
        }
        catch let error {
            NSLog("Failed deleting highscores: \(error)")
            return false
        }
    }
}
