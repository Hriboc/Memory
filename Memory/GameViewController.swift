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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // --- Game Type Picker
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
    
    // använd denn för att hämta val av spel
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //self.textBox.text = self.list[row]
        //self.gameTypePicker.isHidden = true
        //let row = gameTypePicker.selectedRow(inComponent: 0)
        selectedGameType = gameTypes[row]
    }
    
    // --- Collection View
    let reuseIdentifier = "ItemCell" // also enter this string as the cell identifier in the storyboard
    //var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.getBoardSize() // self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.imgItem.image = nil
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let item = game.getItem(position: indexPath.item)
        
        if selectedGameType == "color" {
            cell.backgroundColor = setItemColor(item: item)
        }
        else { // smiley, number
            cell.imgItem.image = setItemImage(item: item)
            cell.backgroundColor = UIColor.white
        }

        print("You selected cell #\(indexPath.item)!")
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
            // Show enter name
            alert()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        gameCollectionView.reloadData()
        scoreLabel.text = String(game.score)
        
    }
    
    private func setItemColor(item: Int) -> UIColor {
        return colors[item-1]
    }
    
    // Concat to make an image, e.g. image "smilie3"
    private func setItemImage(item: Int) -> UIImage {
        return UIImage(named:"\(selectedGameType)\(item)")!
    }
    
    private func alert(){
        // Create alert controller
        let alertController = UIAlertController(title: "Score: \(game.score)", message: "Enter your name", preferredStyle: UIAlertControllerStyle.alert)
        // Create button Ok
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in
            
            //print(nameTextField.text ?? "Unknown")
            // show high score view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewCtrl = storyboard.instantiateViewController(withIdentifier: "HighScoreCtrl") as! HighScoreViewController
            let name = alertController.textFields![0] as UITextField
            viewCtrl.player = name.text!
            viewCtrl.score = self.game.score
            self.navigationController?.show(viewCtrl, sender: self)
        })
        // Create button Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("you have pressed the No button")
            //Call another alert here
        }
        // add buttons to controller
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        // add text field
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
