import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day06Tests {
    // Smoke test data provided in the challenge question
    let testData = """
                ....#.....
                .........#
                ..........
                ..#.......
                .......#..
                ..........
                .#..^.....
                ........#.
                #.........
                ......#...
                """

    @Test func testPart1() async throws {
        let challenge = Day06(data: testData)
        #expect(String(describing: challenge.part1()) == "41")
    }

    @Test func testPart2() async throws {
        let challenge = Day06(data: testData)
        #expect(String(describing: challenge.part2()) == "6")
    }
    
    @Test(
        "Test can place obstacles"
        , arguments: zip([
            Point(4, 6),
            .init(6, 6),
            .init(4, 8),
            .init(2, 8),
            .init(6, 7),
            .init(7, 8)
        ],
        [
            Direction.left,
            .down,
            .left,
            .left,
            .right,
            .down
        ])
    )
    
    func testWalking(startingPosition: Point, startingDirection: Direction) throws {
        let challenge = Day06(data: testData)
        let insertedObstacle = startingPosition.nextPoint(facing: startingDirection)
        var modified = challenge.entities
        modified[insertedObstacle.y][insertedObstacle.x] = "#"
        
        #expect(
            throws: MovementError.Stuck(startingPosition)
        ) {
            try challenge.walk(
                lab: modified,
                starting: startingPosition,
                startingDirection: startingDirection,
                shouldPlaceObstacles: false
            )
        }
        
        
    }
}
