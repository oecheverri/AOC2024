import Testing

@testable import AdventOfCode

struct Day01Tests {

    @Test("Test Day1 Part1", arguments: [
            """
                3   4
                4   3
                2   5
                1   3
                3   9
                3   3
                """
    ])
    func testPart1(_ data: String) throws {
        let challenge = Day01(data: data)
        #expect(String(describing: challenge.part1()) == "11")
    }

    @Test("Test Day2 Part2", arguments: [
            """
                3   4
                4   3
                2   5
                1   3
                3   9
                3   3
                """
    ])
    func testPart2(_ data: String) throws {
        let challenge = Day01(data: data)
        #expect(String(describing: challenge.part2()) == "31")
    }
}
