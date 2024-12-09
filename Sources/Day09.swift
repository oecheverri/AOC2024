struct Day09: AdventDay {

    var data: String

    var dataArray = [Int?]()
    var entities: [Int?] {
        dataArray
    }

    init(data: String) {
        self.data = data.filter { !$0.isNewline }
        var left = data.startIndex
        var right = data.index(left, offsetBy: 1)
        var fileId = 0

        while left < self.data.endIndex {
            dataArray.append(
                contentsOf: Array(
                    repeating: fileId,
                    count: Int(String(data[left]))!
                )
            )
            if right < self.data.endIndex {
                dataArray.append(
                    contentsOf: Array(
                        repeating: nil,
                        count: Int(String(data[right]))!
                    )
                )
            }
            fileId+=1
            guard let newLeft = data.index(right, offsetBy: 1, limitedBy: data.endIndex),
                  let newRight = data.index(newLeft, offsetBy: 1, limitedBy: data.endIndex)
            else { break }
            left = newLeft
            right = newRight
        }

    }

    func compactedEntities() -> [Int] {
        var compactedEntities = entities
        var left = 0
        var right = compactedEntities.count-1
        while left < right {
            while compactedEntities[left] != nil {
                left+=1
                if left == right { break }
            }
            while compactedEntities[right] == nil {
                right-=1
                if left == right { break }
            }
            compactedEntities.swapAt(left, right)
        }

        return compactedEntities.compactMap(\.self)

    }
    func part1() -> Any {
        compactedEntities().enumerated()
            .reduce(0) {
                return $0 + $1.offset * $1.element
            }
    }

    func part2() -> Any {
        0
    }
}
