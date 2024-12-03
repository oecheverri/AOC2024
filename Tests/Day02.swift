import Testing

@testable import AdventOfCode

struct Day02Tests {

    @Test("Test Day2 Part1", arguments: [
            """
                7 6 4 2 1
                1 2 7 8 9
                9 7 6 2 1
                1 3 2 4 5
                8 6 4 4 1
                1 3 6 7 9
                """
    ])
    func testPart1(_ data: String) throws {
        let challenge = Day02(data: data)
        #expect(String(describing: challenge.part1()) == "2")
    }

    @Test("Determines unsafe")
    func testDeterminesUnsafe() {
        let challenge = Day02(data: "")
        #expect(!challenge.determineSafety([1, 2, 7, 8, 9]))
        #expect(!challenge.determineSafety([9, 7, 6, 2, 1]))
        #expect(!challenge.determineSafety([1, 3, 2, 4, 5]))
        #expect(!challenge.determineSafety([8, 6, 4, 4, 1]))
        #expect(!challenge.determineSafety([82, 81, 79, 77, 72, 73]))
    }

    @Test("Determines safe")
    func testDeterminesSafe() {
        let challenge = Day02(data: "")
        #expect(challenge.determineSafety([7, 6, 4, 2, 1]))
        #expect(challenge.determineSafety([1, 3, 6, 7, 9]))
    }

    @Test("Determines unsafe with dampner")
    func testDeterminesUnsafeDampened() {
        let challenge = Day02(data: "")
        #expect(!challenge.determineSafety([1, 2, 7, 8, 9], dampened: true))
        #expect(!challenge.determineSafety([9, 7, 6, 2, 1], dampened: true))
        #expect(!challenge.determineSafety([82, 81, 79, 77, 72, 73], dampened: true))
    }

    @Test("Determines safe with dampner")
    func testDeterminesSafeDampened() {
        let challenge = Day02(data: "")
        #expect(challenge.determineSafety([7, 6, 4, 2, 1], dampened: true))
        #expect(challenge.determineSafety([1, 3, 6, 7, 9], dampened: true))
        #expect(challenge.determineSafety([1, 3, 2, 4, 5], dampened: true))
        #expect(challenge.determineSafety([8, 6, 4, 4, 1], dampened: true))

    }

    @Test("Test Day2 Part2", arguments: [
            """
                7 6 4 2 1
                1 2 7 8 9
                9 7 6 2 1
                1 3 2 4 5
                8 6 4 4 1
                1 3 6 7 9
                """
    ])
    func testPart2(_ data: String) throws {
        let challenge = Day02(data: data)
        #expect(String(describing: challenge.part2()) == "4")
    }
}
