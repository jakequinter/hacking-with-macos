//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Jake Quinter on 12/28/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("maximumGuesses") var maximumGuesses = 100
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false
    @AppStorage("showGuessCount") var showGuessCount = false
    
    @State private var isGameOver = false
    @State private var maxGuessesReached = false
    @State private var guess = ""
    @State private var guesses: [String] = []
    @State private var answer = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter a guess...", text: $guess)
                    .onSubmit(submitGuess)
                Button("Go", action: submitGuess)
            }
            .padding()
            
            List(0..<guesses.count, id: \.self) { index in
                let guess = guesses[index]
                let showShowResult = (enableHardMode == false) || (enableHardMode && index == 0)
                
                HStack {
                    Text(guess)
                    Spacer()
                    if showShowResult {
                        Text(result(for: guess))
                    }
                }
            }
            .listStyle(.sidebar)
        
            if showGuessCount {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
            }
        }
        .frame(width: 250)
        .frame(minHeight: 300)
        .onAppear(perform: startNewGame)
        .onChange(of: answerLength) { _ in startNewGame() }
        .alert("You win!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            Text("Congratulations! Click OK to play again.")
        }
        .alert("You've reached your maximum amount of guesses!", isPresented: $maxGuessesReached) {
            Button("OK", action: startNewGame)
        } message: {
            Text("Click OK to restart and try again")
        }
        .navigationTitle("Cows and Bulls")
    }
    
    func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8 else { return }
        
        guess = ""
        guesses.removeAll()
        answer = ""
        let numbers = (0...9).shuffled()
        
        for i in 0..<answerLength {
            answer.append(String(numbers[i]))
        }
    }
    
    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (idx, letter) in guessLetters.enumerated() {
            if letter == answerLetters[idx] {
               bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }
    
    func submitGuess() {
        guard Set(guess).count == answerLength else { return }
        guard guess.count == answerLength else { return }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        guesses.insert(guess, at: 0)
        
        if result(for: guess).contains("\(answerLength)b") {
            isGameOver = true
        }
        
        if guesses.count >= maximumGuesses {
            maxGuessesReached = true
        }
        guess = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
