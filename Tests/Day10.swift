import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day10Tests {
    // Smoke test data provided in the challenge question
    let testData = """
                89010123
                78121874
                87430965
                96549874
                45678903
                32019012
                01329801
                10456732
                """

    @Test func parserWorks() {
        let challenge = Day10(data: testData)
        #expect(challenge.grid.count == 8)
        #expect(challenge.grid[0].count == 8)
        #expect(Day10.memo[0]?.count == 9)
        #expect(Day10.memo[9]?.count == 7)
        #expect(Day10.memo[1]?.count == 9)
        #expect(Day10.memo[2]?.count == 6)

    }
    @Test func testPart1() async throws {
        let challenge = Day10(data: testData)
        #expect(String(describing: challenge.part1()) == "36")
    }

    @Test func testPart2() async throws {
        let challenge = Day10(data: testData)
        #expect(String(describing: challenge.part2()) == "81")
    }
}
