struct HikingNode {
    
}
struct Day10: AdventDay {

    var data: String

    var entities: [[Int]] {
            data.components(separatedBy: "\n\n").map {
            $0.components(separatedBy: "\n").compactMap { Int($0) }
        }
    }

    
    func areNeighboursNine(_ point: Point) {
        
    }
    
    func part1() -> Any {
        entities.first?.reduce(0, +) ?? 0
    }

    func part2() -> Any {
        entities.map { $0.max() ?? 0 }.reduce(0, +)
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
            right,
            upLeft,
            downRight,
            upRight,
            downLeft
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
