//
//  Deck.swift
//  SpiderColor
//
//  Created by Ailton Vieira Pinto Filho on 04/03/20.
//  Copyright © 2020 Veevaz. All rights reserved.
//

import Foundation

class Deck {
    private(set) var card: Card
    private(set) var childDeck: Deck?
    private(set) var parentDeck: Deck?

    var size: Int { 1 + (childDeck?.size ?? 0) }
    var cards: [Card] { [card] + (childDeck?.cards ?? []) }

    var isDraggable: Bool {
        if let deck = childDeck {
            return (deck.card.isNext(of: card)) && deck.isDraggable
        }
        return true
    }
    
    var lastCard: Card {
        childDeck?.lastCard ?? card
    }

    init(card: Card) {
        self.card = card
    }

    init(cards: [Card]) {
        self.card = cards[0]
        var deck = self
        for i in 1..<cards.count {
            deck = deck.add(card: cards[i])
        }
    }

    func add(card: Card) -> Deck {
        add(deck: Deck(card: card))
    }

    func add(deck: Deck) -> Deck {
        if childDeck != nil {
            _ = childDeck?.add(deck: deck)
        } else {
            childDeck = deck
            childDeck?.parentDeck = self
        }
        return self
    }

    func move(to deck: Deck) {
        detach()
        _ = deck.add(deck: self)
    }

    func detach() {
        parentDeck?.childDeck = nil
        parentDeck = nil
    }
}
