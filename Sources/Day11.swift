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

    var entities: [Int] {
        [0]
    }

    init(data: String) {
        self.data = data
    }
    func createStones() -> Stone {
        let numbers = data.components(separatedBy: "\n")[0]
            .components(separatedBy: " ")
            .compactMap(Int.init)
        
        let stones: Stone = .init(value: numbers[0])
        var currentStone = stones
        for i in 1..<numbers.count {
            currentStone.next = .init(value: numbers[i])
            currentStone = currentStone.next!
        }
        return stones
    }
    func countStones(_ stones: Stone) -> Int {
        var stoneCount = 1
        var currentStone = stones
        while currentStone.next != nil {
            currentStone = currentStone.next!
            stoneCount += 1
        }
        return stoneCount
    }
    func evolveStones(count: Int) -> Int {
        let stone = createStones()
        var stoneCount = countStones(stone)
        for iteration in 0..<count {
            print(iteration, terminator: "... ")
            var nextStone: Stone? = stone
            while nextStone != nil {
                let currentStone = nextStone!
                nextStone = currentStone.next
                if currentStone.value == 0 {
                    currentStone.value = 1
                } else if currentStone.value.hasEvenDigits {
                    let str = String(currentStone.value)
                    let middleIndex = str.index(str.startIndex, offsetBy: str.count/2)
                    guard let leftValue = Int(str[str.startIndex..<middleIndex]), let rightValue = Int(str[middleIndex..<str.endIndex]) else { continue }
                    currentStone.value = leftValue
                    currentStone.next = .init(value: rightValue)
                    stoneCount+=1
                    currentStone.next?.next = nextStone
                } else {
                    currentStone.value *= 2024
                }

            }
        }
        print("")
        return stoneCount
    }

    func part1() -> Any {
        evolveStones(count: 25)
    }

    func part2() -> Any {
        evolveStones(count: 75)
    }
}
