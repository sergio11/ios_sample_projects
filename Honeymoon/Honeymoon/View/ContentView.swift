//
//  ContentView.swift
//  Honeymoon
//
//  Created by Sergio Sánchez Sánchez on 27/12/24.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    @GestureState private var dragState = DragState.inactive
    @StateObject private var viewModel = ContentViewModel()
    
    // MARK: DRAG STATES
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .dragging:
                return true
            case .pressing, .inactive:
                return false
            }
        }
        
        var isPressing: Bool {
            switch self {
            case .pressing, .dragging:
                return true
            case .inactive:
                return false
            }
        }
    }
    
    var body: some View {
        VStack {
            // MARK: - HEADER
            HeaderView(
                showGuideView: $viewModel.showGuide,
                showInfoView: $viewModel.showInfo
            )
            .opacity(dragState.isDragging ? 0.0 : 1.0)
            .animation(.default)
            
            Spacer()
            
            // MARK: - CARDS
            ZStack {
                ForEach(viewModel.cardViews) { cardView in
                    cardView
                        .zIndex(viewModel.isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay(
                            ZStack {
                                Image(systemName: "x.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width < -viewModel.dragAreaThreshold && viewModel.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                
                                Image(systemName: "heart.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width > viewModel.dragAreaThreshold && viewModel.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                            }
                        )
                        .offset(x: viewModel.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0, y: viewModel.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                        .scaleEffect(self.dragState.isDragging && viewModel.isTopCard(cardView: cardView) ? 0.85 : 1.0)
                        .rotationEffect(Angle(degrees: viewModel.isTopCard(cardView: cardView) ?  Double(self.dragState.translation.width / 12) : 0))
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating(self.$dragState, body: { (value, state, transaction) in
                                switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(translation: drag?.translation ?? .zero)
                                default:
                                    break
                                }
                            }).onChanged({ (value) in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }
                                
                                if drag.translation.width < -viewModel.dragAreaThreshold {
                                    viewModel.cardRemovalTransition = .leadingBottom
                                }
                                
                                if drag.translation.width > viewModel.dragAreaThreshold {
                                    viewModel.cardRemovalTransition = .trailingBottom
                                }
                                
                            })
                                .onEnded({ (value) in
                                    guard case .second(true, let drag?) = value else {
                                        return
                                    }
                                    if drag.translation.width < -viewModel.dragAreaThreshold || drag.translation.width > viewModel.dragAreaThreshold {
                                        playSound(sound: "sound-rise", type: "mp3")
                                        viewModel.moveCards()
                                    }
                                })
                        ).transition(viewModel.cardRemovalTransition)
                }
            }
            .padding(.horizontal)
    
            
            Spacer()
            
            // MARK: - FOOTER
            FooterView(showBookingAlert: $viewModel.showAlert)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("SUCCESS"),
                message: Text("Whishing a lovely and most precious of the times together for the amazing couple."),
                dismissButton: .default(Text("Happy Honeymoon!"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
