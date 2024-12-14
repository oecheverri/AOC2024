import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day14Tests {
    // Smoke test data provided in the challenge question
    let testData = """
                p=0,4 v=3,-3
                p=6,3 v=-1,-3
                p=10,3 v=-1,2
                p=2,0 v=2,-1
                p=0,0 v=1,3
                p=3,0 v=-2,-2
                p=7,6 v=-1,-3
                p=3,0 v=-1,-2
                p=9,3 v=2,3
                p=7,3 v=-1,2
                p=2,4 v=2,-3
                p=9,5 v=-3,-3
                """

    @Test func testPart1() async throws {
        let challenge = Day14(data: testData, small: true)
        #expect(String(describing: challenge.part1()) == "12")
    }

    @Test func testPart2() async throws {
        let challenge = Day14(data: testData, small: true)
        #expect(String(describing: challenge.part2()) == "0")
    }
    
    @Test("Moves robots correctly", arguments: ["p=0,4 v=3,-3"])
    func movesRobotCorrectly(robot: String) {
        let challenge = Day14(data: robot, small: true)
        let bot = Robot(vX: 3, vY: -3)
        let newPosition = challenge.moveRobot(from: .init(x: 0, y: 4), bot: bot, seconds: 100)
        challenge.printGrid(challenge.bots, timeIndex: 100)
        #expect(newPosition.x == 3)
        #expect(newPosition.y == 5)
    }
}
