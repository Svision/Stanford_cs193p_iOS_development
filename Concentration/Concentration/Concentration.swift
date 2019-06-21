//
//  Concentration.swift
//  Concentration
//
//  Created by Changhao Song on 2019-06-01.
//  Copyright © 2019 Changhao Song. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    var flipCount = 0
    
//    func updateFlipCountLabel() {
//        let attributes: [NSAttributedString.Key: Any] = [
//            .strokeWidth = 5.0
//        ]
//    }
    
    
    var score = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func thisMatchScore(matchIndex: Int, index: Int) -> Int {
        if cards[matchIndex].isMatched && cards[index].isMatched {
            // if two cards match
            if cards[matchIndex].seenTime <= 2 && cards[index].seenTime <= 2 {
                return 2
            } else {
                return -1
            }
        } else {
            if cards[matchIndex].seenTime <= 1 && cards[index].seenTime <= 1 {
                return 0
            } else {
                return -1
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the index")
        cards[index].seenTime += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // Check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += thisMatchScore(matchIndex: matchIndex, index: index)
                } else {
                    score += thisMatchScore(matchIndex: matchIndex, index: index)
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of card")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
