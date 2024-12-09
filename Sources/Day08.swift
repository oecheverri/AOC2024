struct Node {
    let frequency: Character?

    init(frequency: Character?, antinodeFor antinode: Character? = nil) {
        self.frequency = frequency != "." ? frequency : nil
    }
}

extension Array where Element == [Node] {
    subscript(point: Point) -> Node {
        get {
            self[point.y][point.x]
        }
        set {
            self[point.y][point.x] = newValue
        }
    }
}

struct Day08: AdventDay {

    var data: String
    var grid: [[Node]]
    var locations: [Character: [Point]] = [:]
    var entities: [[Node]] {
        grid
    }

    init(data: String) {
        self.data = data

        grid = data.components(separatedBy: "\n")
            .compactMap { $0.isEmpty ? nil : $0 }
            .map {
                $0.map { Node(frequency: $0) }
            }

        for (row, nodes) in grid.enumerated() {
            for (column, node) in nodes.enumerated() {
                guard let frequency = node.frequency else { continue }
                locations[frequency, default: []].append(.init(row, column))
            }
        }
    }

    func isInBounds(_ point: Point) -> Bool {
        grid.indices.contains(point.y)
        && grid[point.y].indices.contains(point.x)
    }

    func calculateAntiNodalPoints(_ pointA: Point, _ pointB: Point) -> Set<Point> {
        guard pointA != pointB else { return [] }
        let rowDiff = pointA.y - pointB.y
        let columnDiff = pointA.x - pointB.x
        var points = Set<Point>()

        let point1 = Point(pointA.x - 2 * columnDiff, pointA.y - 2 * rowDiff)
        if isInBounds(point1) {
            points.insert(point1)
        }

        let point2 = Point(pointA.x + columnDiff, pointA.y + rowDiff)
        if isInBounds(point2) {
            points.insert(point2)
        }
        return points
    }

    func calculateHarmonicAntinodalPoints(_ pointA: Point, _ pointB: Point) -> Set<Point> {
        guard pointA != pointB else { return [] }
        let rowDiff = pointA.y - pointB.y
        let columnDiff = pointA.x - pointB.x

        let nodes = [pointA, pointB].sorted()

        var points = Set([pointA, pointB])
        // add upwardly
        var lastPoint = nodes[0]
        while true {
            lastPoint = .init(lastPoint.x - columnDiff, lastPoint.y - rowDiff)
            if isInBounds(lastPoint) {
                points.insert(lastPoint)
            } else {
                break
            }
        }

        // add downwardly
        lastPoint = nodes[1]
        while true {
            lastPoint = .init(lastPoint.x + columnDiff, lastPoint.y + rowDiff)
            if isInBounds(lastPoint) {
                points.insert(lastPoint)
            } else {
                break
            }
        }
        return points
    }

    func seekAntinodes(using strategy: (Point, Point) -> Set<Point>) -> Int {
        var antinodes: Set<Point> = []
        for frequency in locations.keys {
            guard let locations = locations[frequency], locations.count > 1 else { continue }
            var left = 0
            var right = 1
            while left < locations.count - 1 {
                antinodes.formUnion(strategy(locations[left], locations[right]))
                right+=1
                if right == locations.count {
                    left += 1
                    right = left + 1
                }
            }
        }
        return antinodes.count
    }

    func part1() -> Any {
        seekAntinodes(using: calculateAntiNodalPoints)
    }

    func part2() -> Any {
        seekAntinodes(using: calculateHarmonicAntinodalPoints)
    }
}
