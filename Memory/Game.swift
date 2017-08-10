//
//  Game.swift
//  Memory
//
//  Created by Hristijan Bocevski on 2017-08-03.
//  Copyright © 2017 Hristijan Bocevski. All rights reserved.
//

import Foundation

class Game {
    private let items = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10]
    
    private var board = [Int]()//= Array(repeating: 0, count: 20)
    private var selectedPositions = [Int]()
    private var nSolvedItems = 0
    
    var score = 0
    
    init() {
        //board = Array(repeating: 0, count: items.count)
        newGame()
    }
    
    func newGame(){
        board = Array(repeating: 0, count: items.count)
        
        for item in items{
            board[findFreePosition()] = item
        }
        score = 0
        nSolvedItems = 0
        clearSelection()
    }
    
    func getItem(position: Int) -> Int{
        return board[position]
    }
    
    func addSelection(position: Int){
        selectedPositions.append(position)
    }
    
    func getFirstSelection() -> Int {
        return selectedPositions[0]
    }
    
    func clearSelection() {
        selectedPositions.removeAll()
    }
    
    func isSelectedPair() -> Bool {
        return selectedPositions.count == 2
    }
    
    func areSelectedItemsEqual() -> Bool {
        return board[selectedPositions[0]] == board[selectedPositions[1]]
    }
    
    func getBoardSize() -> Int {
        return board.count
    }
    
    func markSolvedItems() {
        nSolvedItems += 2
    }
    
    func isGameOver() -> Bool {
        return nSolvedItems == items.count // 2
    }
    
    private func findFreePosition() -> Int {
        // random a position
        var pos = Int(arc4random_uniform(UInt32(board.count)))
        
        //find a free position
        while board[pos] != 0 {
            pos += 3;
            if pos >= 20 {
                pos -= 20
            }
        }
        return pos;
    }
}
