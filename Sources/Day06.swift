
struct Point: Equatable, Hashable {
    let x: Int
    let y: Int
}

struct Day06: AdventDay {
    
    var data: String

    let lab: [[Character]]
    var startingPosition = Point(x: 0, y: 0)

    init(data: String) {
        self.data = data
        self.lab = data.components(separatedBy: "\n\n")[0]
            .components(separatedBy: .newlines)
            .map(Array.init)
            .filter {
                !$0.isEmpty
            }
        
        for y in 0..<lab.count {
            for (x, char) in lab[y].enumerated() {
                if Direction(rawValue: char) != nil {
                    self.startingPosition = Point(x: x, y: y)
                    break
                }
            }
        }
    }
    
    var entities: [[Character]] {
        lab
    }

    enum Direction: Character {
        case up = "^"
        case down = "v"
        case left = "<"
        case right = ">"
        
        var turnRight: Direction {
            switch self {
            case .up: return .right
            case .right: return .down
            case .down: return .left
            case .left: return .up
            }
        }
    }
    
    func isInBounds(_ position: Point) -> Bool {
        lab.indices.contains(position.y) && lab[position.y].indices.contains(position.x)
    }
    
    func part1() -> Any {
        
        guard var currentDirection = Direction(rawValue: lab[startingPosition.y][startingPosition.x]) else {
            return 0
        }
        var currentPosition = self.startingPosition
        var visited: Set<Point> = [currentPosition]

        while true {
            let nextPos: Point
            switch currentDirection {
            case .up:
                nextPos = Point(x: currentPosition.x, y: currentPosition.y - 1)
            case .down:
                nextPos = Point(x: currentPosition.x, y: currentPosition.y + 1)
            case .left:
                nextPos = Point(x: currentPosition.x - 1, y: currentPosition.y)
            case .right:
                nextPos = Point(x: currentPosition.x + 1, y: currentPosition.y)
            }
            
            guard isInBounds(nextPos) else { return visited.count }
            
            if lab[nextPos.y][nextPos.x] == "#" {
                currentDirection = currentDirection.turnRight
            } else {
                currentPosition = nextPos
                visited.insert(currentPosition)
            }
        }
        
        return visited.count
    }

    func part2() -> Any {
        0
    }
}


