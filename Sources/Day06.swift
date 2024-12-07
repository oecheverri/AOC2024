import Foundation
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

    var turnedLeft: Direction {
        switch self {
        case .up: return .left
        case .left: return .down
        case .down: return .right
        case .right: return .up
        }
    }
}

struct Point: Equatable, Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    func nextPoint(facing direction: Direction) -> Point {
        switch direction {
        case .up:
            .init(x: x, y: y - 1)
        case .down:
            .init(x: x, y: y + 1)
        case .left:
            .init(x: x - 1, y: y)
        case .right:
            .init(x: x + 1, y: y)
        }
    }
}


enum MovementError: Error, Equatable {
    case Stuck(Point)
}

extension Array where Element == [Character] {
    subscript(point: Point) -> Character {
        get {
            self[point.y][point.x]
        }
        set {
            self[point.y][point.x] = newValue
        }
    }
}



struct Day06: AdventDay {
    
    var data: String

    let lab: [[Character]]
    var initialStartPosition = Point(x: 0, y: 0)

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
                    self.initialStartPosition = Point(x: x, y: y)
                    break
                }
            }
        }
    }
    
    var entities: [[Character]] {
        lab
    }
    
    func isInBounds(_ position: Point) -> Bool {
        lab.indices.contains(position.y) && lab[position.y].indices.contains(position.x)
    }
    
    func part1() -> Any {
        
        guard var currentDirection = Direction(rawValue: lab[initialStartPosition.y][initialStartPosition.x]) else {
            return 0
        }
        var currentPosition = self.initialStartPosition
        var nextPosition = currentPosition.nextPoint(facing: currentDirection)
        var visited: Set<Point> = [currentPosition]
        while isInBounds(nextPosition) {
            
            guard lab[nextPosition] != "#", lab[nextPosition] != "O" else {
                currentDirection = currentDirection.turnRight
                nextPosition = currentPosition.nextPoint(facing: currentDirection)
                continue
            }
            currentPosition = nextPosition
            nextPosition = currentPosition.nextPoint(facing: currentDirection)
            visited.insert(currentPosition)
        }
        
        return visited.count
    }

    func walk(
        lab: [[Character]],
        starting point: Point,
        startingDirection: Direction,
        shouldPlaceObstacles: Bool = true
    ) throws -> Int {
        var visited: [Point: Set<Direction>] = [:]
        var placedObstacles: Set<Point> = []
        var currentPosition = point
        var currentDirection = startingDirection
        var nextPosition = currentPosition.nextPoint(facing: currentDirection)

        while isInBounds(nextPosition) {
            
            guard lab[nextPosition] != "#", lab[nextPosition] != "O" else {
                currentDirection = currentDirection.turnRight
                nextPosition = currentPosition.nextPoint(facing: currentDirection)
                continue
            }
            
            if shouldPlaceObstacles {
                var modifiedLab = lab
                modifiedLab[nextPosition] = "O"
                do {
                    _ = try walk(
                        lab: modifiedLab,
                        starting: initialStartPosition,
                        startingDirection: .up,
                        shouldPlaceObstacles: false
                    )
                } catch {
                    placedObstacles.insert(nextPosition)
                }
            }
            
            if let arrivalDirections = visited[nextPosition],
                arrivalDirections.contains(currentDirection) {
                throw MovementError.Stuck(currentPosition)
            }
            
            visited[nextPosition, default: []].insert(currentDirection)
            currentPosition = nextPosition
            nextPosition = currentPosition.nextPoint(facing: currentDirection)
        }

        return placedObstacles.count
    }
    
    func part2() -> Any {
        guard let currentDirection = Direction(rawValue: lab[initialStartPosition.y][initialStartPosition.x]) else {
            return 0
        }
        let result = try! walk(lab: lab, starting: initialStartPosition, startingDirection: currentDirection, shouldPlaceObstacles: true)
        return result
    }

    func printLab(lab: [[Character]], _ visited: [Point: Set<Direction>], placedObstacles: Set<Point>, currentPosition: Point, currentDirection: Direction) {
        
        var logger = LogDestination()
        
        for (rIndex, row) in lab.enumerated() {
            for (cIndex, cell) in row.enumerated() {
                let point = Point(x: cIndex, y: rIndex)
                if point == currentPosition {
                    print(currentDirection.rawValue, terminator: ",", to: &logger)
                } else if placedObstacles.contains(point) {
                    print("O", terminator: ",", to: &logger)
                } else if let directions = visited[point] {
                    print(getTravelPath(directions: .init(directions)), terminator: ",", to: &logger)
                } else {
                    print(cell, terminator: ",", to: &logger)
                }
            }
            print("", to: &logger)
        }
    }

    func getTravelPath(directions: [Direction]) -> String {
        directions.reduce("") {
            switch $1 {
            case .left, .right:
                if $0 == "" {
                    return "-"
                } else
                if $0 == "|" {
                    return "+"
                }
            case .down, .up:
                if $0 == "" {
                    return "|"
                } else
                if $0 == "-" {
                    return "+"
                }
            }
            return $0
        }
    }

}

final class LogDestination: TextOutputStream {
  private let path: String
  init() {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    path = paths.first! + "/log"
      print("Logging to: \(path)")
  }

  func write(_ string: String) {
    if let data = string.data(using: .utf8), let fileHandle = FileHandle(forWritingAtPath: path) {
      defer {
        fileHandle.closeFile()
      }
      fileHandle.seekToEndOfFile()
      fileHandle.write(data)
    }
  }
}


