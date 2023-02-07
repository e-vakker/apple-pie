//
//  Game.swift
//  Apple Pie
//
//  Created by Jevgeni Vakker on 04.10.2022.
//

import Foundation


struct Game {
    var word: String
    var incorrectMovesRemaining: Int
    var guessedLetters: [Character]
    var win: Bool {
        var win = false
        if word == formattedWord {
            win = true
        }
        return win
    }
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
    
    mutating func playerGuessed(letter: Character) {
        guessedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemaining -= 1
        }
    }
    
}

struct Player {
    var totalWins = 0
    var totalLoses = 0
    var totalScore = 0
    
    mutating func addScore(score: Int) {
        totalScore += score
    }
    
    mutating func addWin() {
        totalWins += 1
    }
    
    mutating func addLose() {
        totalLoses += 1
    }
}


