import Foundation
class Stone: @unchecked Sendable {
    var value: Int
    var next: Stone? = nil
    
    init(value: Int) {
        self.value = value
    }
}

extension Int {
    var hasEvenDigits: Bool {
        (Int(log10(Float(self))) % 2) == 1
    }
}
struct Day11: AdventDay {

    var data: String

    let stones: Stone
    var entities: Stone {
        stones
    }

    init(data: String) {
        self.data = data
        let numbers = data.components(separatedBy: "\n")[0]
            .components(separatedBy: " ")
            .compactMap(Int.init)
        
        stones = .init(value: numbers[0])
        var lastStone = stones
        for i in 1..<numbers.count {
            lastStone.next = .init(value: numbers[i])
        }
            
    }

    func evolveStones(count: Int) -> Int {
        var stoneEvoLine = stones.map{ [$0] }
        for i in 0..<stoneEvoLine.count {
            for counter in 0..<count {
                print("\(counter)", terminator: "...")
                var j = 0
                while j < stoneEvoLine[i].count {
                    let stone = stoneEvoLine[i][j]
                    if stone.value == 0 {
                        stone.value = 1
                        j += 1
                    } else if stone.value.hasEvenDigits {
                        let str = String(stone.value)
                        let middleIndex = str.index(str.startIndex, offsetBy: str.count/2)
                        guard let leftValue = Int(str[str.startIndex..<middleIndex]), let rightValue = Int(str[middleIndex..<str.endIndex]) else { continue }
                        stone.value = rightValue
                        stoneEvoLine[i].insert(.init(value: leftValue), at: j)
                        j+=2
                    } else {
                        stone.value *= 2024
                        j += 1
                    }
                }
            }
        }
        print("")
        return stoneEvoLine.flatMap(\.self).count
    }

    func part1() -> Any {
//        evolveStones(count: 25)
        return 0
    }

    func part2() -> Any {
        evolveStones(count: 75)
    }
}
