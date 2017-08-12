//
//  GameViewController.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-03.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var gameTypePicker: UIPickerView!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var showHighScoreButton: UIButton!
    
    
    let itemCellID = "ItemCell" // Reusable cell ID for collection view
    
    let colors = [UIColor.blue, UIColor.red, UIColor.black, UIColor.brown, UIColor.cyan,
        UIColor.green, UIColor.yellow, UIColor.purple, UIColor.orange,UIColor.magenta]
    
    let gameTypes = ["color", "smiley", "number"]
    var selectedGameType = ""
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the selected game type
        let row = gameTypePicker.selectedRow(inComponent: 0)
        selectedGameType = gameTypes[row]
        
        // Style buttons
        newGameButton.layer.cornerRadius = 6
        showHighScoreButton.layer.cornerRadius = 6
    }
    
    // --- Functions for Game Type Picker ---
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gameTypes.count
    }
    
    // Shows game type in picker UI, i think
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        
        return gameTypes[row]
    }
    
    // Change game type
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGameType = gameTypes[row]
    }
    
    // --- Functions for Collection View ----
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.getBoardSize()
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellID, for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.imgItem.image = nil
        cell.backgroundColor = UIColor.lightGray
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // handles tap evens
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let item = game.getItem(position: indexPath.item)
        
        if selectedGameType == "color" {
            cell.backgroundColor = setItemColor(item: item)
        }
        else { // smiley, number
            cell.imgItem.image = setItemImage(item: item)
            cell.backgroundColor = UIColor.white
        }
        game.addSelection(position: indexPath.item)
        
        if game.isSelectedPair() {
            if game.areSelectedItemsEqual() {
                game.score += 2
                game.markSolvedItems()
            }else {
                game.score -= 1
                // get ref to previous item selected
                let prevCellIdxPath = IndexPath(item: self.game.getFirstSelection(), section: 0)
                let previousCell = collectionView.cellForItem(at: prevCellIdxPath) as! CollectionViewCell
                // call timer to turn back chosen items
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                    // remove images
                    cell.imgItem.image = nil
                    previousCell.imgItem.image = nil
                    // hide items
                    cell.backgroundColor = UIColor.lightGray
                    previousCell.backgroundColor = UIColor.lightGray
                }
            }
            game.clearSelection()
            scoreLabel.text = String(game.score)
        }
        
        if game.isGameOver() {
            alertPlayer()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        gameCollectionView.reloadData()
        scoreLabel.text = String(game.score)
        
    }
    
    private func setItemColor(item: Int) -> UIColor {
        return colors[item-1] // items is 1 to 10 but array index is 0 to 9
    }
    
    // Concat to make an image, e.g. "smilie3"
    private func setItemImage(item: Int) -> UIImage {
        return UIImage(named:"\(selectedGameType)\(item)")!
    }
    
    // Popups a window so player can enter a name. If button OK is pressed, high score view is shown
    private func alertPlayer(){
        // Create alert controller
        let alertController = UIAlertController(title: "Score: \(game.score)", message: "Enter your name", preferredStyle: UIAlertControllerStyle.alert)
        
        // Create button Ok
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in
            // create high score view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewCtrl = storyboard.instantiateViewController(withIdentifier: "HighScoreCtrl") as! HighScoreViewController
            
            // get the name of the player
            let name = alertController.textFields![0] as UITextField
            viewCtrl.player = name.text!
            viewCtrl.score = self.game.score
            
            // show the view
            self.navigationController?.show(viewCtrl, sender: self)
        })
        // Create button Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in}
        
        // add all buttons
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        // add text field that will hold players name
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in})
        
        self.present(alertController, animated: true, completion: nil)
    }
}
