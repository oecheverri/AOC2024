import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day09Tests {
    // Smoke test data provided in the challenge question
    let testData = "2333133121414131402"

    @Test func parsesCorrectly() async throws {
        let expected = [0, 0, nil, nil, nil, 1, 1, 1, nil, nil, nil, 2, nil, nil, nil, 3, 3, 3, nil, 4, 4, nil, 5, 5, 5, 5, nil, 6, 6, 6, 6, nil, 7, 7, 7, nil, 8, 8, 8, 8, 9, 9]
        let challenge = Day09(data: testData)
        #expect(challenge.dataArray == expected)
    }
    @Test func testPart1() async throws {
        let challenge = Day09(data: testData)
        #expect(String(describing: challenge.part1()) == "1928")
    }

    @Test func testPart2() async throws {
        let challenge = Day09(data: testData)
        #expect(String(describing: challenge.part2()) == "0")
    }
}
