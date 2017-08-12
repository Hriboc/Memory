//
//  HighScoreViewController.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-08.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import UIKit
import CoreData

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTextView: UITextView!
    @IBOutlet weak var deleteHighScoreButton: UIButton!
    
    var player = ""
    var score = 0
    var gameType = ""
    
    private var managedContext : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style textView and button
        highScoreTextView.layer.cornerRadius = 8
        deleteHighScoreButton.layer.cornerRadius = 6
        
        // Create database connection
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        // Save highscore to database if any presented
        if !player.isEmpty {
            let description = NSEntityDescription.entity(forEntityName: "HighScore", in: managedContext!)!
            let entity = NSManagedObject(entity: description, insertInto: managedContext) as! HighScore
            
            entity.player = player
            entity.score = Int32(score)
            entity.gameType = gameType
            
            do {
                try managedContext?.save()
            }
            catch let error {
                NSLog("Failed saving highscore: \(error)")
            }
        }
        
        // Fetch highscores from database
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        
        do {
            let highScores = try managedContext?.fetch(request) as! [HighScore]
            let sortedHighScores = highScores.sorted(by: {$0.score > $1.score})
            
            var highScoresText = ""
            for highScore in sortedHighScores {
                highScoresText.append("\(highScore.player!)\t\(highScore.score)\t\t[\(highScore.gameType!)]\n"
)           }
            highScoreTextView.text = highScoresText
        }
        catch let error {
            NSLog("Failed getting highscores: \(error)")
        }
    }

    @IBAction func deleteHighScores(_ sender: UIButton) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try managedContext?.execute(deleteRequest)
            highScoreTextView.text = "";
        }
        catch let error {
            NSLog("Failed deleting highscores: \(error)")
        }
    }

}
