//
//  HighScoreViewController.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-08.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {

    @IBOutlet weak var highScoreTextView: UITextView!
    
    var player = "Unknown"
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        highScoreTextView.text = "\(player)\t\t\(score)\n"
        highScoreTextView.isEditable = false
        highScoreTextView.allowsEditingTextAttributes = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Will be called every time View is about to appear on the screen.
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
