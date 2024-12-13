import Foundation
class Stone: @unchecked Sendable {
    var value: Int
    var next: Stone?

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

    var dict: [Int: Int] = [:]
    var entities: [Int: Int] {
        dict
    }

    init(data: String) {
        self.data = data.filter { $0 != "\n"}

        let nums = self.data.components(separatedBy: " ").compactMap(Int.init)
        for num in nums {
            dict[num, default: 0]+=1
        }

    }

    func transform(value: Int, using splitMemo: inout [Int: [Int]]) -> [Int] {
        if let split = splitMemo[value] {
            return split
        }

        let valueStr = String(value)
        let middleIndex = valueStr.index(valueStr.startIndex, offsetBy: valueStr.count / 2)

        splitMemo[value] = [Int(valueStr[valueStr.startIndex..<middleIndex])!,
                            Int(valueStr[middleIndex..<valueStr.endIndex])!]
        return splitMemo[value]!
    }

    func evolve(count: Int) -> Int {
        var splitMemo: [Int: [Int]] = [:]
        var stones = dict
        for _ in 0..<count {
            var evolvedStones: [Int: Int] = [:]
            let keys = stones.keys
            for key in keys {
                let stoneCount = stones[key]!
                if key == 0 {
                    evolvedStones[1, default: 0]+=stoneCount
                } else if key.hasEvenDigits {
                    let split = transform(value: key, using: &splitMemo)
                    evolvedStones[split[0], default: 0]+=stoneCount
                    evolvedStones[split[1], default: 0]+=stoneCount
                } else {
                    let newKey = key * 2024
                    evolvedStones[newKey, default: 0]+=stoneCount
                }
                stones.removeValue(forKey: key)
            }
            stones.merge(evolvedStones, uniquingKeysWith: +)
        }
        return stones.values.reduce(0, +)
    }

    func part1() -> Any {
        evolve(count: 25)
    }

    func part2() -> Any {
        evolve(count: 75)
    }
}
