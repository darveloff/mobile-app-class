//
//  ContentView.swift
//  week3app
//
//  Created by Darmen Aussarbekov on 25.09.2026.
//

import SwiftUI

// one diagonal line in the picture
struct Slash {
    var start: CGPoint // top point of the line
    var end: CGPoint // bottom point of the line
    var color: Color // color picked from the array
}

// first screen. shows two tabs at the bottom
struct ContentView: View {
    var body: some View {
        TabView {
            PatternView()
                .tabItem {
                    Label("Pattern", systemImage: "scribble")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}

// the drawing screen
struct PatternView: View {
    // colors a line can be. one is picked at random
    let colors: [Color] = [.red, .green, .yellow, .blue, .black]
    // how many cells fit across one row
    let columns = 8

    // every line in the picture. starts empty
    @State private var slashes: [Slash] = []
    // saved size of the drawing area, used by the button
    @State private var canvasSize: CGSize = .zero

    var body: some View {
        // stack the title, the canvas, and the button
        VStack(spacing: 16) {
            Text("Random Pattern")
                .font(.title2)

            // geo.size is the real width and height of this area
            GeometryReader { geo in
                // canvas draws the lines
                Canvas { context, _ in
                    // line thickness and round ends
                    let style = StrokeStyle(lineWidth: 8, lineCap: .round)
                    // draw each slash stored in the array
                    for slash in slashes {
                        var path = Path()
                        path.move(to: slash.start)
                        path.addLine(to: slash.end)
                        context.stroke(path, with: .color(slash.color), style: style)
                    }
                }
                .background(Color.white)
                // runs once when the canvas first shows
                .onAppear {
                    canvasSize = geo.size
                    slashes = makePattern(size: geo.size)
                }
            }
            .frame(height: 360)
            .border(Color.gray)

            // rebuild the array so the picture changes
            Button("New Pattern") {
                slashes = makePattern(size: canvasSize)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // build an array of random slashes. does not draw them
    func makePattern(size: CGSize) -> [Slash] {
        var result: [Slash] = []
        // width of one square
        let cell = size.width / CGFloat(columns)
        // how many squares fit down the canvas
        let rows = Int(size.height / cell)

        // visit every cell: down the rows, then across the columns
        for row in 0..<rows {
            for col in 0..<columns {
                // top left corner of this cell
                let x = CGFloat(col) * cell
                let y = CGFloat(row) * cell
                let color = colors.randomElement() ?? .black

                // true draws \ and false draws /
                if Bool.random() {
                    result.append(Slash(
                        start: CGPoint(x: x, y: y),
                        end: CGPoint(x: x + cell, y: y + cell),
                        color: color
                    ))
                } else {
                    result.append(Slash(
                        start: CGPoint(x: x + cell, y: y),
                        end: CGPoint(x: x, y: y + cell),
                        color: color
                    ))
                }
            }
        }
        return result
    }
}

// second tab. only text, no drawing
struct AboutView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("10 Print")
                .font(.title)
            Text("Each cell is a random slash, \\ or /, in a random color from an array. Tap New Pattern to build a new picture.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

// preview in xcode. not used when the app runs
#Preview {
    ContentView()
}
