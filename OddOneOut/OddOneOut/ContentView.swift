//
//  ContentView.swift
//  OddOneOut
//
//  Created by Jake Quinter on 1/6/23.
//

import SwiftUI

struct ContentView: View {
    static let gridSize = 10
    
    @State private var images = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
    @State private var layout = Array(repeating: "penguin", count: gridSize * gridSize)
    @State private var currentLevel = 1
    @State private var isGameOver = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Odd One Out")
                    .font(.system(size: 36, weight: .thin))
                    .fixedSize()
                
                ForEach(0..<Self.gridSize, id: \.self) { row in
                    HStack {
                        ForEach(0..<Self.gridSize, id: \.self) { column in
                            if image(row, column) == "empty" {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 64, height: 64)
                            } else {
                                Button {
                                    processAnswer(at: row, column)
                                } label: {
                                    Image(image(row, column))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }
            .opacity(isGameOver ? 0.2 : 1)
            
            if isGameOver {
                VStack {
                    Text("Game Over!")
                        .font(.largeTitle)
                    
                    Button("Play Again") {
                        currentLevel = 1
                        isGameOver = false
                        createLevel()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .buttonStyle(.borderless)
                    .padding(20)
                    .background(.blue)
                    .clipShape(Capsule())
                }
            }
        }
        .onAppear(perform: createLevel)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Start New Game") {
                currentLevel = 1
                isGameOver = false
                createLevel()
            }
        }
    }
    
    func generateLayout(items: Int) {
        // remove any existing layouts
        layout.removeAll(keepingCapacity: true)
        
        // randomize images
        images.shuffle()
        layout.append(images[0])
        
        var numUsed = 0
        var itemCount = 1
        
        for _ in 1..<items {
            layout.append(images[itemCount])
            numUsed += 1
            
            // if we already placed two, move to the next image
            if numUsed == 2 {
                numUsed = 0
                itemCount += 1
            }
            
            // if we placed all images, start at 1
            if itemCount == images.count {
                itemCount = 1
            }
        }
        
        // fill the rest of our array with "empty"
        layout += Array(repeating: "empty", count: 100 - layout.count)
        layout.shuffle()
    }
    
    func createLevel() {
        if currentLevel == 9 {
            withAnimation {
                isGameOver = true
            }
        } else {
            let numberOfItems = [0, 5, 15, 25, 35, 49, 65, 81, 100]
            generateLayout(items: numberOfItems[currentLevel])
        }
    }
    
    func processAnswer(at row: Int, _ column: Int) {
        if image(row, column) == images[0] {
            currentLevel += 1
            createLevel()
        } else {
            if currentLevel > 1 {
                currentLevel -= 1
            }
            
            createLevel()
        }
    }
    
    func image(_ row: Int, _ column: Int) -> String {
        layout[row * Self.gridSize + column]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
