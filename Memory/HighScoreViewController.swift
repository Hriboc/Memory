//
//  HighScoreViewController.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-08.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import UIKit
//import CoreData

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTextView: UITextView!
    @IBOutlet weak var deleteHighScoreButton: UIButton!
    
    var player = ""
    var score = 0
    var gameType = ""
    
    let coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style textView and button
        highScoreTextView.layer.cornerRadius = 8
        deleteHighScoreButton.layer.cornerRadius = 6
        
        // Needed for Core Data, to access the database
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        coreDataManager.managedContext = appDelegate.persistentContainer.viewContext
        
        // Save high score
        if !player.isEmpty {
            coreDataManager.saveHighScore(player: player, score: score, gameType: gameType)
        }
        // show high scores
        highScoreTextView.text = coreDataManager.fetchHighScores()
    }

    @IBAction func deleteHighScores(_ sender: UIButton) {
        
        if coreDataManager.deleteHighScores() {
            highScoreTextView.text = ""
        }
    }

}
