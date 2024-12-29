//
//  ContentViewModel.swift
//  Honeymoon
//
//  Created by Sergio Sánchez Sánchez on 29/12/24.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var showAlert: Bool = false
    @Published var showGuide: Bool = false
    @Published var showInfo: Bool = false
    @Published var lastCardIndex: Int = 1
    @Published var cardRemovalTransition = AnyTransition.trailingBottom
    @Published var cardViews: [CardView]  = {
        var views = [CardView]()
        for index in 0..<2 {
            views.append(CardView(honeymoon: honeymoonData[index]))
        }
        return views
    }()
    
    let dragAreaThreshold: CGFloat = 65.0
    
    func moveCards() {
        cardViews.removeFirst()
        self.lastCardIndex += 1
        let honeymoon = honeymoonData[lastCardIndex % honeymoonData.count]
        let newCardView = CardView(honeymoon: honeymoon)
        cardViews.append(newCardView)
    }
    
    func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }
}
