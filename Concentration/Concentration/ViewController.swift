//
//  ViewController.swift
//  Concentration
//
//  Created by Changhao Song on 2019-06-01.
//  Copyright © 2019 Changhao Song. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var themeNameLabel: UILabel!
    @IBOutlet private weak var scoreBoardLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game.flipCount = 0
        game.score = 0
//        TODO: newGameButton
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        game.flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"

        scoreBoardLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiChoicesWithTheme = ["Animal": ["🐰", "🐥", "🐱", "🐷", "🐸", "🦄", "🐼", "🦁"],
                                         "Food": ["🌭", "🥩", "🍔", "🍕", "🧀", "🌰", "🍰", "🍗"],
                                         "Sport": ["⚽️", "🏀", "⚾️", "🎱", "🏓", "🏐", "🎾", "🏈"],
                                         "Face": ["😍", "😂", "🤭", "🥺", "😀", "🤪", "🙁", "😕"],
                                         "Fruit": ["🍎", "🍋", "🍓", "🍇", "🍉", "🍒", "🍍", "🍑"],
                                         "Car": ["🚑", "🚒", "🚐", "🏎", "🚓", "🚜", "🚕", "🚚"]]
    
    private lazy var themeChoices = Array(emojiChoicesWithTheme.keys)
    
    private lazy var randomThemeChoice = Int(arc4random_uniform(UInt32(emojiChoicesWithTheme.count)))
    private lazy var emojiChoices = emojiChoicesWithTheme[themeChoices[randomThemeChoice]]
    private lazy var themeName = themeChoices[randomThemeChoice]
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        themeNameLabel.text = "\(themeName)\(emojiChoicesWithTheme[themeName]![0])"
        if emoji[card] == nil, emojiChoicesWithTheme[themeChoices[randomThemeChoice]]!.count > 0 {
            emoji[card] = emojiChoices!.remove(at: emojiChoices!.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
