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
    }

    func isInBounds(_ point: Point) -> Bool {
        grid.indices.contains(point.y)
        && grid[point.y].indices.contains(point.x)
    }

    func calculateAntiNodalPoints(_ pointA: Point, _ pointB: Point) -> [Point] {
        guard pointA != pointB else { return [] }
        let rowDiff = pointA.y - pointB.y
        let columnDiff = pointA.x - pointB.x

        return [.init(pointA.x - 2 * columnDiff, pointA.y - 2 * rowDiff),
                .init(pointA.x + columnDiff, pointA.y + rowDiff)]
    }

    func part1() -> Any {
        var locations = [Character: [Point]]()
        for (row, nodes) in grid.enumerated() {
            for (column, node) in nodes.enumerated() {
                guard let frequency = node.frequency else { continue }
                locations[frequency, default: []].append(.init(row, column))
            }
        }
        var antinodes: Set<Point> = []

        for frequency in locations.keys {
            guard let locations = locations[frequency], locations.count > 1 else { continue }
            var left = 0
            var right = 1
            while left < locations.count - 1 {
                antinodes.formUnion(calculateAntiNodalPoints(locations[left], locations[right]))
                right+=1
                if right == locations.count {
                    left += 1
                    right = left + 1
                }
            }
        }

        return antinodes.count(where: isInBounds)
    }

    func part2() -> Any {
        0
    }
}
