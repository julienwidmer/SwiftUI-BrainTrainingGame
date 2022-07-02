//
//  ContentView.swift
//  BrainTrainingGame
//
//  Created by Julien Widmer on 2022-07-01.
//

import SwiftUI

// Extension to make modifiers (declared in CustomModifiers.swift) easier to use
extension View {
    func italicTitleStyle() -> some View {
        modifier(ItalicTitle())
    }
    
    func italicBodyStyle() -> some View {
        modifier(ItalicBody())
    }
    
    func bodyStyle() -> some View {
        modifier(CustomBody())
    }
    
    func buttonStyle() -> some View {
        modifier(CustomButton())
    }
    
    func animatedTextViewStyle() -> some View {
        modifier(AnimatedTextView())
    }
}

struct ContentView: View {
    // Game
    private let gameMoves = ["👊", "✌️", "✋"]
    @State private var playerNeedsToWin = true
    @State private var computerMoveIndex = Int.random(in: 0...2)
    @State private var winningMove: String?
    
    // Alerts
    @State private var displayWrongMoveAlert = false
    @State private var displayEndOfGameAlert = false
    
    // Score and rounds
    @State private var displayRound = true
    @State private var score = 0
    @State private var round = 1
    private var finalRound = 10
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.red, .pink]),
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            // Main content
            VStack {
                HStack {
                    // MARK: Game Round
                    Text("Round \(round) / \(finalRound)")
                        .foregroundStyle(.white)
                        .bodyStyle()
                    
                    Spacer()
                    
                    // MARK: Game Score
                    Text("Score: \(score)")
                        .foregroundStyle(.white)
                        .bodyStyle()
                }
                .padding(.top, 10)
                
                Spacer()
                
                VStack(spacing: 50) {
                    // MARK: Game Title
                    Text("Brain Training Game")
                        .italicTitleStyle()
                    
                    // MARK: Game Objective
                    VStack(spacing: 15) {
                        Text("Tap the correct button to")
                            .italicBodyStyle()
                        
                        HStack(spacing: 18) {
                            if displayRound {
                                Text(playerNeedsToWin ? "WIN  🏆" : "LOSE  💣")
                                    .foregroundColor(.black)
                                    .bodyStyle()
                                    .frame(width: 120, height: 55)
                                    .padding(.top, 5)
                                    .animatedTextViewStyle()
                            
                                Text("VS")
                                    .bodyStyle()
                            
                                Text(gameMoves[computerMoveIndex])
                                    .font(.system(size: 33))
                                    .frame(width: 60, height: 60)
                                    .animatedTextViewStyle()
                            }
                        }
                        .frame(minHeight: 60)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Text("Choose your move")
                        .italicBodyStyle()
                    
                    // MARK: Player Move Selection
                    HStack(spacing: 20) {
                        ForEach(Array(gameMoves.enumerated()),
                                id: \.element) { index, option in
                            Button(option) {
                                buttonTapped(index)
                            }
                            .buttonStyle()
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 40)
        }
        // MARK: Alerts
        // Player selected the wrong move
        .alert("Wrong", isPresented: $displayWrongMoveAlert) {
            Button("Continue") {}
        } message: {
            Text("The right move was \(winningMove ?? "")!")
        }
        // Player played final round
        .alert("Game Over", isPresented: $displayEndOfGameAlert) {
            Button("Restart") {
                score = 0
                round = 1
            }
        } message: {
            if score > 0 {
                Text("Congratulations! You got \(score) point(s)!")
            } else {
                Text("Would you like to try again?")
            }
        }
    }
    
    func buttonTapped(_ move: Int) {
        withAnimation {
            displayRound.toggle()
        }
        
        let playerMove = gameMoves[move]
        let computerMove = gameMoves[computerMoveIndex]
        let previousScore = score
        
        // Debugging
        print("Objective: \(playerNeedsToWin ? "WIN  🏆" : "LOSE  💣")\tComputer: \(computerMove)\tPlayer: \(playerMove)")
        
        switch computerMove {
        case "👊":
            winningMove = playerNeedsToWin ? "paper" : "scissors"
            
            if (playerNeedsToWin && playerMove == "✋") ||
                (!playerNeedsToWin && playerMove == "✌️") {
                score += 1
            } else {
                score -= 1
            }
        case "✌️":
            winningMove = playerNeedsToWin ? "rock" : "paper"
            
            if (playerNeedsToWin && playerMove == "👊") ||
                (!playerNeedsToWin && playerMove == "✋") {
                score += 1
            } else {
                score -= 1
            }
        case "✋":
            winningMove = playerNeedsToWin ? "scissors" : "rock"
            
            if (playerNeedsToWin && playerMove == "✌️") ||
                (!playerNeedsToWin && playerMove == "👊") {
                score += 1
            } else {
                score -= 1
            }
        default:
            fatalError("Unexpected value \(computerMove)")
        }
        
        
        if score < previousScore { displayWrongMoveAlert.toggle() }
        
        if round == finalRound {
            displayEndOfGameAlert.toggle()
            
            withAnimation {
                displayRound.toggle()
            }
        } else {
            round += 1
            playerNeedsToWin.toggle() // alternate between a losing and winning move
            computerMoveIndex = Int.random(in: 0...2) // select a random move
            
            withAnimation {
                displayRound.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
