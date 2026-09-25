import Foundation

// blank columns between a drawing and whatever sits beside it
let gap = 4
// how many empty rows push a bubble or the sun down from the top
let bubbleDrop = 1

// reading a text file out of the playground Resources folder
func load(_ file: String) -> String {
    let path = Bundle.main.path(forResource: file, ofType: nil)
    let text = try? String(contentsOfFile: path!, encoding: .utf8)
    return text!
}

// cutting a block of ascii into separate lines, keeping blank ones
func splitLines(_ text: String) -> [String] {
    let pieces = text.split(separator: "\n", omittingEmptySubsequences: false)
    return pieces.map { String($0) }
}

// the short drawing is the sun, the tall one is the eagle
let sun = splitLines(load("ASCII Art from Draw Studio.txt"))
let eagle = splitLines(load("ASCII Art from Draw Studio (1).txt"))

// widest row in a block, so later rows can be padded to the same edge
func widestLine(of block: [String]) -> Int {
    var widest = 0
    for line in block {
        if line.count > widest {
            widest = line.count
        }
    }
    return widest
}

// empty rows above a block, used to lower a bubble or the sun
func blankAbove(_ block: [String], rows: Int) -> [String] {
    var result: [String] = []
    for _ in 0..<rows {
        result.append("")
    }
    for line in block {
        result.append(line)
    }
    return result
}

// two ascii blocks drawn on the same rows, part2 starting after a margin
func combine(_ part1: [String], _ part2: [String], margin: Int) -> [String] {
    let edge = widestLine(of: part1) + margin
    // max keeps the taller drawing when the left side is shorter
    let rows = max(part1.count, part2.count)
    var result: [String] = []

    for index in 0..<rows {
        var line = index < part1.count ? part1[index] : ""
        line += String(repeating: " ", count: max(0, edge - line.count))
        if index < part2.count {
            line += part2[index]
        }
        result.append(line)
    }
    return result
}

// a three-line speech bubble sized to the text
func bubble(saying text: String) -> [String] {
    let width = text.count + 2
    let top = " " + String(repeating: "_", count: width)
    let middle = "< " + text + " >"
    let bottom = " " + String(repeating: "-", count: width)
    return [top, middle, bottom]
}

// printing one panel, then a blank line before the next
func show(_ block: [String]) {
    for line in block {
        print(line)
    }
    print("")
}

// the sun claims the sky
show(combine(sun, blankAbove(bubble(saying: "hey. you are in my sky."), rows: bubbleDrop), margin: gap))
// the eagle answers
show(combine(eagle, blankAbove(bubble(saying: "i was here first, bird."), rows: bubbleDrop), margin: gap))
// both of them, eagle on the left and sun up on the right
show(combine(eagle, blankAbove(sun, rows: bubbleDrop), margin: gap))
print("the sun stays. the eagle also stays. awkward.")
