import Foundation
struct Robot {
    let uuid = UUID().uuidString
    let vX: Int
    let vY: Int
}

struct Day14: AdventDay {

    var data: String
    var bots: [[[Robot]]]
    var entities: [[[Robot]]] {
        bots
    }

    init(data: String) {
        self.init(data: data, small: false)
    }
    init(data: String, small: Bool) {
        self.data = data
        let rows = small ? 7 : 103
        let columns = small ? 11 : 101

        bots = .init(
            repeating: .init(
                repeating: [],
                count: columns
            ),
            count: rows
        )

        data.components(separatedBy: "\n")
            .filter { $0.count > 0}
            .forEach {
                let components = $0.components(separatedBy: " ")
                let positions = Self.extractScalars(from: components[0])
                let positionPt = Point(x: positions[0], y: positions[1])
                let veloStr = Self.extractScalars(from: components[1])

                bots[positionPt].append(.init(vX: veloStr[0], vY: veloStr[1]))

            }

    }

    static func extractScalars(from string: String) -> [Int] {
        string[string.index(string.startIndex, offsetBy: 2)..<string.endIndex]
            .components(separatedBy: ",").map { Int($0)! }

    }

    func moveRobot(from position: Point, bot: Robot, seconds: Int) -> Point {
        let x = position.x
        let y = position.y
        let width = bots[y].count
        let height = bots.count
        
        let newX = (x + (bot.vX + width) * seconds) % width
        let newY = (y + (bot.vY + height) * seconds) % height
        
        return Point(newX, newY)

    }

    func elapseTime(seconds: Int, _ grid: inout [[[Robot]]], shouldPrintGrid: Bool = false) {
        var moves = [(from: Point, to: Point)]()
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                guard grid[row][col].count > 0 else { continue }
                for index in 0..<grid[row][col].count {
                    let bot = grid[row][col][index]
                    let position = Point(col, row)
                    let newPosition = moveRobot(from: position, bot: bot, seconds: seconds)
                    moves.append((from: position, to: newPosition))
                }
            }
        }
        
        for move in moves {
            let bot = grid[move.from].removeLast()
            grid[move.to].append(bot)
        }
        
        if shouldPrintGrid {
            printGrid(grid, timeIndex: seconds)
        }
    }
     
    func part1() -> Any {
        var grid = bots
        elapseTime(seconds: 100, &grid, shouldPrintGrid: false)

        let topLeftBots = grid.robotCount(in: .topLeft)
        let topRightBots = grid.robotCount(in: .topRight)
        let bottomLeftBots = grid.robotCount(in: .bottomLeft)
        let bottomRightBots = grid.robotCount(in: .bottomRight)

        return topLeftBots * topRightBots * bottomLeftBots * bottomRightBots
    }

    func part2() -> Any {
        var grid = bots
        elapseTime(seconds: 10000, &grid, shouldPrintGrid: false)

        return 0
    }

    func printGrid(_ grid: [[[Robot]]], timeIndex: Int) {
        print("\u{001B}[2J")
        print("+!++!+!+!+!!+!+!+! Time Index:\(timeIndex) +!+!+!+!+!!+!+!+!+")
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                var symbol: String
                switch grid[row][col].count {
                case 1:
                    symbol = "🌲"
                case 2:
                    symbol = "🎄"
                default:
                    symbol = "🟦"
                        
                }
                print(symbol, terminator: "")
            }
            print("")
        }
        usleep(100_000)
    }

}

extension Array where Element == [[Robot]] {

    enum Quadrant {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    subscript(point: Point) -> [Robot] {
        get {
            return self[point.y][point.x]
        }
        set {
            self[point.y][point.x] = newValue
        }
    }

    func robotCount(in quadrant: Quadrant) -> Int {
        let verticalBoundary = self.count / 2
        let horizontalBoundary = self[0].count / 2

        var botCount = 0
        switch quadrant {
            case .topLeft:
            for row in 0..<verticalBoundary {
                for col in 0..<horizontalBoundary {
                    botCount += self[row][col].count
                }
            }
            case .topRight:
            for row in 0..<verticalBoundary {
                for col in horizontalBoundary+1..<self[0].count {
                    botCount += self[row][col].count
                }
            }
            case .bottomLeft:
            for row in verticalBoundary+1..<count {
                for col in 0..<horizontalBoundary {
                    botCount += self[row][col].count
                }
            }
            case .bottomRight:
            for row in verticalBoundary+1..<count {
                for col in horizontalBoundary+1..<self[0].count {
                    botCount += self[row][col].count
                }
            }
        }
        return botCount
    }

}
