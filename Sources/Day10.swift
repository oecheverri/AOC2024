struct TreeNode: Hashable, Equatable {

    nonisolated(unsafe) static var memo: [TreeNode: [TreeNode]] = [:]

    let value: Int?
    let location: Point

    func areNeighboursZero(_ grid: [[TreeNode]]) -> Bool {

        let neighbours = location.getInBoundsNeighbors(
            verticalRange: grid.indices,
            horizontalRange: grid[0].indices
        )

        for neighbour in neighbours {
            if grid[neighbour].value == 0 {
                return true
            }
        }
        return false
    }

    func calculatePathsToNine(in grid: [[TreeNode]]) -> Bool {
        if TreeNode.memo[self] != nil {
            return true
        }

        var nodesToNine: [TreeNode] = []
        if value == 9 {
            return true
        } else {
            guard let value else { return false }
            location.getInBoundsNeighbors(
                verticalRange: grid.indices,
                horizontalRange: grid[0].indices
            )
                .map { grid[$0]}
                .filter { $0.value == value + 1}
                .filter { $0.calculatePathsToNine(in: grid )}
                .forEach { nodesToNine.append($0)}
        }
        TreeNode.memo[self] = nodesToNine
        return nodesToNine.count > 0
    }

    func collectUniqueLeafNodes(_ collector: inout Set<TreeNode>) {
        if self.value == 9 {
            collector.insert(self)
        } else {
            let children = TreeNode.memo[self, default: []]
            for child in children {
                child.collectUniqueLeafNodes(&collector)
            }
        }
    }

    func collectAllLeafNodes(_ collector: inout [TreeNode]) {
        if self.value == 9 {
            collector.append(self)
        } else {
            let children = TreeNode.memo[self, default: []]
            for child in children {
                child.collectAllLeafNodes(&collector)
            }
        }
    }
}

struct Day10: AdventDay {
    nonisolated(unsafe) static var memo: [Int: [TreeNode]] = [:]
    var data: String

    var grid: [[TreeNode]]
    var entities: [[TreeNode]] {
        grid
    }

    init(data: String) {
        self.data = data
        let compoenents = data.components(separatedBy: "\n").filter { $0.count > 0 }
        grid = compoenents.enumerated().map { (y, row) in
            row.enumerated().compactMap { (x, value) in
                let tree = TreeNode(
                    value: Int(String(value)),
                    location: .init(x, y)
                )
                if let value = tree.value {
                    Day10.memo[value, default: []].append(tree)
                }
                return tree
            }
        }

        let flatNodes = grid.flatMap(\.self).filter { $0.value == 0 }
        flatNodes.forEach { _ = $0.calculatePathsToNine(in: grid)}

    }

    func part1() -> Any {
        let zeroNodes = Day10.memo[0, default: []]

        var count = 0
        for node in zeroNodes {
            var leafNodeSet = Set<TreeNode>()
            node.collectUniqueLeafNodes(&leafNodeSet)
            count+=leafNodeSet.count
        }
        return count
    }

    func part2() -> Any {
        let zeroNodes = Day10.memo[0, default: []]

        var count = 0
        for node in zeroNodes {
            var leafNodes = [TreeNode]()
            node.collectAllLeafNodes(&leafNodes)
            count+=leafNodes.count
        }
        return count
    }
}

extension Array where Element == [TreeNode] {
    subscript(point: Point) -> Element.Element {
        get {
            self[point.y][point.x]
        }
        set {
            self[point.y][point.x] = newValue
        }
    }
}
extension Point {

    func getInBoundsNeighbors(
        verticalRange: Range<Int>,
        horizontalRange: Range<Int>
    ) -> [Point] {
        return [
            up,
            down,
            left,
            right
        ].filter { verticalRange.contains($0.y) && horizontalRange.contains($0.x)}
    }

    var upLeft: Point {
        Point(x: x - 1, y: y - 1)
    }

    var downRight: Point {
        Point(x: x + 1, y: y + 1)
    }

    var upRight: Point {
        Point(x: x + 1, y: y - 1)
    }

    var downLeft: Point {
        Point(x: x - 1, y: y + 1)
    }

    var up: Point {
        Point(x: x, y: y - 1)
    }

    var down: Point {
        Point(x: x, y: y + 1)
    }

    var left: Point {
        Point(x: x - 1, y: y)
    }

    var right: Point {
        Point(x: x + 1, y: y)
    }
}
