import Algorithms

struct Problem: Sendable {
    static let operands: [Operation] = [
        { $0 + $1},
        { $0 * $1}
    ]

    let solution: Int
    let values: [Int]

    func isSolvable(using operands: [Operation]) -> Bool {

        let operations = operands.combinations(elementCount: values.count - 1)

        for operationList in operations {

            var current = values[0]
            for i in 0..<operationList.count {
                current = operationList[i](current, values[i + 1])
            }
            if current == solution {
                return true
            }
        }
        return false
    }
}

nonisolated(unsafe) var operandMemo: [Int: [[Operation]]] = [:]

typealias Operation = @Sendable (Int, Int) -> Int
extension Array where Element == Operation {

    func combinations(elementCount: Int) -> [[Element]] {
        if let memoized = operandMemo[elementCount] {
            return memoized
        }
        if elementCount == 0 {
            return []
        }
        if elementCount == 1 {
            return self.map {
                [$0]
            }
        }

        let partial = combinations(elementCount: elementCount - 1)
        let result = self.flatMap { outer in
            partial.map {
                var inner = $0
                inner.append(outer)
                return inner
            }
        }
        operandMemo[elementCount] = result
        return result
    }

}

struct Day07: AdventDay {

    var data: String

    let problems: [Problem]
    var entities: [Problem] {
        return problems
    }

    init(data: String) {
        self.data = data
        problems = data.components(separatedBy: "\n")
            .compactMap { $0.isEmpty ? nil : $0.components(separatedBy: ":") }
            .map {
                Problem(
                    solution: Int($0[0])!,
                    values: $0[1].components(separatedBy: " ").compactMap(Int.init)
                )
            }
    }

    func part1() -> Any {
        operandMemo.removeAll(keepingCapacity: true)
        let operands: [Operation] = [{ $0 + $1}, { $0 * $1}]
        return entities.filter {$0.isSolvable(using: operands)}.reduce(0) { $0 + $1.solution }
    }

    func part2() -> Any {
        operandMemo.removeAll(keepingCapacity: true)
        let operands: [Operation] = [
            { $0 + $1},
            { $0 * $1},
            {
                Int(String($0) + String($1))!
            }
        ]
        return entities.filter {$0.isSolvable(using: operands)}.reduce(0) { $0 + $1.solution }
    }
}
