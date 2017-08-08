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
    
    let gameTypes = ["colors", "smilies", "numbers"]
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // vet inte vad denna gör
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return gameTypes[row]
        
    }
    
    // använd denn för att hämta val av spel
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //self.textBox.text = self.list[row]
        //self.gameTypePicker.isHidden = true
        
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
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.imgItem.image = game.board[indexPath.item]
        cell.backgroundColor = UIColor.lightGray//setColor(item: game.board[indexPath.item]) // make cell more visible in our example project
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let cell = collectionView.cellForItem(at: indexPath)
        let item = game.getItem(position: indexPath.item)
        cell?.backgroundColor = setColor(item: item)

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
                let previousCell = collectionView.cellForItem(at: prevCellIdxPath)
                // call timer to turn back chosen items
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (timer) in
                    cell?.backgroundColor = UIColor.lightGray
                    previousCell?.backgroundColor = UIColor.lightGray
                }
            }
            game.clearSelection()
            scoreLabel.text = String(game.score)
        }
        
        if game.isGameOver() {
            // Show enter name
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        gameCollectionView.reloadData()
    }
    
    private func setColor(item: Int) -> UIColor {
        switch item {
            case 1:
                return UIColor.blue
            case 2:
                return UIColor.red
            case 3:
                return UIColor.black
            case 4:
                return UIColor.brown
            case 5:
                return UIColor.cyan
            case 6:
                return UIColor.green
            case 7:
                return UIColor.yellow
            case 8:
                return UIColor.purple
            case 9:
                return UIColor.orange
            case 10:
                return UIColor.magenta
            default:
                return UIColor.white
        }
    }
    
    /*func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }*/
    /*
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
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