import Foundation
struct Day03: AdventDay {
    var data: String

    private var _entities: String

    enum Conditional {
        case yes
        case dont

    }

    init(data: String) {
        self.data = data
        self._entities = data

    }
    var entities: String {
        return _entities
    }

    func part1() -> Any {
        let ranges = data.ranges(of: /mul\([0-9]{1,3},[0-9]{1,3}\)/)
        return ranges.map {
            data[(data.index($0.lowerBound, offsetBy: 4))...(data.index($0.upperBound, offsetBy: -2))]
                .components(separatedBy: ",")
        }.map {
            (Int($0[0])!, Int($0[1])!)
        }
        .reduce(0) {
            $0 + $1.0 * $1.1
        }
    }

    func part2() -> Any {
        var conditionalRanges = [(conditional: Conditional, range: Range<String.Index>)]()
        let ranges = data.ranges(of: /mul\([0-9]{1,3},[0-9]{1,3}\)/)
        let doRanges = data.ranges(of: /do\(\)/)
        let dontRanges = data.ranges(of: /don't\(\)/)

        for doRange in doRanges {
            conditionalRanges.append((.yes, doRange))
        }
        for dontRange in dontRanges {
            conditionalRanges.append((.dont, dontRange))
        }

        conditionalRanges.sort(by: { $0.range.lowerBound < $1.range.lowerBound })
        var enabledRanges = [Range<String.Index>]()

        var currentConditional = Conditional.yes
        var lastLowerBount = data.startIndex

        for i in 0..<conditionalRanges.count {
            let range = conditionalRanges[i]
            if currentConditional == range.conditional {
                continue
            }
            if currentConditional == .yes {
                enabledRanges.append(lastLowerBount..<range.range.lowerBound)
                currentConditional = .dont
            } else {
                currentConditional = .yes
            }
            lastLowerBount = range.range.upperBound
            if i == conditionalRanges.count - 1, currentConditional == .yes {
                enabledRanges.append(lastLowerBount..<data.endIndex)
            }
        }

        var entities = [(Int, Int)]()
        func isInEnabled(range: Range<String.Index>) -> Bool {
            for enabled in enabledRanges {
                if enabled.contains(range.lowerBound) {
                    return true
                }
            }
            return false
        }

        for range in ranges {
            if isInEnabled(range: range) {
                let str = data[(data.index(range.lowerBound, offsetBy: 4))...(data.index(range.upperBound, offsetBy: -2))]
                let nums = str.components(separatedBy: ",")
                entities.append((Int(nums[0])!, Int(nums[1])!))
            }

        }

        return entities.reduce(0) {
            $0 + $1.0 * $1.1
        }
    }
}
