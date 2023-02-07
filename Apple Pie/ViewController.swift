//
//  ViewController.swift
//  Apple Pie
//
//  Created by Jevgeni Vakker on 03.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var correctScoreLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet var treeImageView: UIImageView!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var gameView: UIStackView!
    @IBOutlet var winnerView: UIStackView!
    @IBOutlet var changePlayerView: UIStackView!
    @IBOutlet var startGameView: UIStackView!
    @IBOutlet var playerChangedLabel: UILabel!
    
    let listOfWords = ["Albania", "Andorra", "Armenia",
                       "Austria", "Azerbaijan", "Belarus",
                       "Belgium", "Bosnia_and_Herzegovina",
                       "Bulgaria", "Croatia", "Cyprus",
                       "Czechia", "Denmark", "Estonia",
                       "Finland", "France", "Georgia",
                       "Germany", "Greece", "Hungary",
                       "Iceland", "Ireland", "Italy",
                       "Kazakhstan", "Kosovo", "Latvia",
                       "Liechtenstein", "Lithuania", "Luxembourg",
                       "Malta", "Moldova", "Monaco",
                       "Montenegro", "Netherlands", "North_Macedonia",
                       "Norway", "Poland", "Portugal",
                       "Romania", "Russia", "San_Marino",
                       "Serbia", "Slovakia", "Slovenia",
                       "Spain", "Sweden", "Switzerland",
                       "Turkey", "Ukraine", "United_Kingdom",
                       "Vatican_City"]
    
    var currentGameWords: [String] = []
    
    let incorrectMovesAllowed = 7
    
    var currentGame: Game!
    
    var player = Player()
    
    var player2 = Player()
    
    var currentPlayer1 = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func newRound() {
        if !currentGameWords.isEmpty {
            enableLetterButtons(true)
            let newWord = currentGameWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            updateUI()
        } else {
            endGame()
        }
    }
    
    func newGame() {
        player.totalScore = 0
        player2.totalScore = 0
        gameView.isHidden = false
        winnerView.isHidden = true
        currentGameWords = listOfWords.shuffled().map {$0.lowercased()}.suffix(5)
        newRound()
    }
    
    func endGame() {
        let winner: String
        if player.totalScore > player2.totalScore {
            winner = "Player 1 win"
            player.addWin()
            player2.addLose()
        } else if player.totalScore == player2.totalScore {
            winner = "Tie"
        } else {
            winner = "Player 2 win"
            player.addLose()
            player2.addWin()
        }
        enableLetterButtons(false)
        gameView.isHidden = true
        winnerView.isHidden = false
        winnerLabel.text = "\(winner)! \nPlayer 1: Total scores: \(player.totalScore)\nPlayer 2: Total scores: \(player2.totalScore)\nPlayer 1: Total Wins: \(player.totalWins)\nPlayer 2: Total Wins: \(player2.totalWins)"
    }
    
    func changePlayer() {
        currentPlayer1.toggle()
        if currentPlayer1 {
            playerChangedLabel.text = "Player 1 your move"
        } else {
            playerChangedLabel.text = "Player 2 your move"
        }
        gameView.isHidden = true
        changePlayerView.isHidden = false
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func updateUI() {
        let letters = currentGame.formattedWord.map {String($0)}
        let wordWithSpacing = letters.joined(separator: " ")
        correctScoreLabel.text = wordWithSpacing
        if currentPlayer1 {
            playerLabel.text = "Player 1"
            scoreLabel.text = "Wins: \(player.totalWins), Losses: \(player.totalLoses), Total scores: \(player.totalScore)"
        } else {
            playerLabel.text = "Player 2"
            scoreLabel.text = "Wins: \(player2.totalWins), Losses: \(player2.totalLoses), Total scores: \(player2.totalScore)"
        }
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            changePlayer()
        } else if currentGame.win == true {
            if currentPlayer1 {
                player.addScore(score: 15)
            } else {
                player2.addScore(score: 15)
            }
            newRound()
        } else if currentGame.word.contains(currentGame.guessedLetters.last!) {
            if currentPlayer1 {
                player.addScore(score: 1)
            } else {
                player2.addScore(score: 1)
            }
        } else {
            updateUI()
        }
    }
    
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.configuration!.title!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
        updateUI()
    }
    
    @IBAction func restartGamePressed(_ sender: UIButton) {
        newGame()
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        startGameView.isHidden = true
        newGame()
    }
    
    @IBAction func changePlayerButton(_ sender: UIButton) {
        changePlayerView.isHidden = true
        gameView.isHidden = false
        newRound()
    }
}

