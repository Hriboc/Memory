//
//  Game.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-03.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import Foundation

class Game {
    var board = Array(repeating: 0, count: 20)
    var selectedPositions = [Int]()
    
    let items = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10]
    
    func newGame(){
        board = Array(repeating: 0, count: 20)
        
        for item in items{
            board[findFreePosition()] = item
        }
    }
    
    func addSelection(position: Int){
        selectedPositions.append(position)
    }
    
    func isSelectedPair() -> Bool {
        return selectedPositions.count == 2
    }
    
    func checkSelectedItems() -> Bool {
        return board[selectedPositions[0]] == board[selectedPositions[1]]
    }
    
    private func findFreePosition() -> Int {
        // random a position
        var pos = Int(arc4random_uniform(UInt32(board.count)))
        
        //find a free position
        while board[pos] != 0 {
            pos += 1;
            if pos >= 20 {
                pos -= 20
            }
        }
        return pos;
    }
}
