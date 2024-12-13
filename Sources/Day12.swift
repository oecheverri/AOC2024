class Tile: @unchecked Sendable {
    let value: Character
    var included: Bool = false

    init(_ value: Character) {
        self.value = value
    }
}
struct Day12: AdventDay {

    var data: String
    var grid: [[Tile]]
    var regions: [Set<Point>] = []

    init(data: String) {
        self.data = data

        grid = data.components(separatedBy: "\n")
            .filter { !$0.isEmpty}
            .map {Array($0).map(Tile.init)}

        regions = findRegions()

    }
    var entities: [[Tile]] {
        grid
    }

    func isInBounds(_ point: Point) -> Bool {
        grid.indices.contains(point.y) && grid[point.y].indices.contains(point.x)
    }

    func fillRegion(startingAt point: Point, _ region: inout Set<Point>) {
        let value = grid[point].value
        region.insert(point)
        grid[point].included = true
        [
            point.up, point.down, point.left, point.right
        ]
        .filter(isInBounds)
        .filter { !grid[$0].included }
        .filter { !region.contains($0) }
        .filter { grid[$0].value == value }
        .forEach { fillRegion(startingAt: $0, &region)}
    }

    func findRegions() -> [Set<Point>] {
        var regions: [Set<Point>] = []
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                let point = Point(x, y)
                if !grid[point].included {
                    var region = Set<Point>()
                    fillRegion(startingAt: point, &region)
                    regions.append(region)
                }
            }
        }
        return regions
    }

    func numFences(_ point: Point) -> Int {
        let val: Character = grid[point].value
        return [point.up, point.down, point.left, point.right].count {
            grid[$0] == nil || grid[$0].value != val
        }
    }

    func part1() -> Any {
        return regions.reduce(0) {
            let fenceCount = $1.reduce(0) { $0 + numFences($1) }
            return $0 + $1.count * fenceCount
        }
    }

    func countCorner(in region: Set<Point>, _ point: Point) -> Int {
        let diagonals = [
            point.upLeft,
            point.upRight,
            point.downLeft,
            point.downRight
        ].filter { !region.contains($0) }

        var count =
        [
            (point.up, point.left),
            (point.up, point.right),
            (point.down, point.left),
            (point.down, point.right)
        ].reduce(0) {
            $0 + ((!region.contains($1.0) && !region.contains($1.1)) ? 1 : 0)
        }

        for diagonal in diagonals {
            if diagonal == point.upLeft {
                if region.contains(point.up) && region.contains(point.left) {
                    count+=1
                }
            } else if diagonal == point.upRight {
                if region.contains(point.up) && region.contains(point.right) {
                    count+=1
                }
            } else if diagonal == point.downRight {
                if region.contains(point.down) && region.contains(point.right) {
                    count+=1
                }
            } else if diagonal == point.downLeft {
                if region.contains(point.down) && region.contains(point.left) {
                    count+=1
                }
            }
        }

        return count
    }

    func part2() -> Any {
        return regions.reduce(0) { partial, region in
            partial + region.count * region.reduce(0) { $0 + countCorner(in: region, $1)}
        }
    }
}

extension Array where Element == [Tile] {
    subscript(point: Point) -> Element.Element {
        return self[point.y][point.x]
    }
    subscript(point: Point) -> Element.Element? {
        guard self.indices.contains(point.y), self[point.y].indices.contains(point.x) else { return nil }
        return self[point.y][point.x]
    }
}
