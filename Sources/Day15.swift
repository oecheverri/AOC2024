enum Instruction: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"
    
    static func +(lhs: Point, rhs: Instruction) -> Point {
        switch rhs {
        case .up:
            return Point(x: lhs.x, y: lhs.y + 1)
        case .down:
            return Point(x: lhs.x, y: lhs.y - 1)
        case .left:
            return Point(x: lhs.x - 1, y: lhs.y)
        case .right:
            return Point(x: lhs.x + 1, y: lhs.y)
        }
    }
    
    static func +(lhs: Instruction, rhs: Point) -> Point {
        rhs + lhs
    }
}

extension Array where Element == Array<Character> {
    subscript (safe point: Point) -> Character? {
        guard self.indices.contains(point.y), self[point.y].indices.contains(
            point.x
        ) else { return nil }
        return self[point]
    }
}

struct Day15: AdventDay {

    let grid: [[Character]]
    let instructions: [Instruction]
    
    init(data: String) {
        
        let inputComponents = data.components(separatedBy: "\n\n")
        
        self.grid = inputComponents[0].components(separatedBy: "\n")
            .map { $0.filter { $0 != "\n" }}
            .filter { !$0.isEmpty }
            .map(Array.init)
        
        self.instructions = Array(inputComponents[1])
            .compactMap(Instruction.init)
        
    }


    func perform(instruction: Instruction, from startingPosition: Point, to grid: inout [[Character]]) -> Point {
        let targetPosition = startingPosition + instruction
        guard let targetValue = grid[safe: targetPosition], targetValue != "#" else { return startingPosition }
        
        let startingValue = grid[startingPosition]

        if targetValue == "O" {
            let newBoxPosition = perform(instruction: instruction, from: targetPosition, to: &grid)
            if newBoxPosition == targetPosition {
                return startingPosition
            } else {
                grid[targetPosition] = startingValue
                grid[startingPosition] = "."
                return targetPosition
            }
            
        }
        
        grid[targetPosition] = startingValue
        grid[startingPosition] = "."
        return targetPosition
        
    }
    
    func part1() -> Any {
        
        
        var robot: Point? = nil
        for row in 1..<grid.count {
            for col in 1..<grid[row].count {
                if grid[row][col] == "@" {
                    robot = .init(col, row)
                }
            }
        }
        guard let startingPosition = robot else { return 0 }
        
        
        var map = grid
        var ans = 0
        for row in 1..<map.count {
            for col in 1..<map[row].count {
                if map[row][col] == "O" {
                    ans += 100*row + col
                }
            }
        }
        return ans
    }

}
