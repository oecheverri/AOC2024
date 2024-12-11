import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day11Tests {
    // Smoke test data provided in the challenge question
    let testData = "125 17"

    @Test func testPart1() async throws {
        let challenge = Day11(data: testData)
        #expect(String(describing: challenge.part1()) == "55312")
    }

    @Test func testEvolution() async throws {
        let challenge = Day11(data: testData)
        #expect(challenge.evolve(count: 9) == 68)
    }

    @Test("Test single evolutions work", arguments:
            zip(["20974 46912 28676032 40 48 4048 1 4048 8096 4 0 4 8 20 24 4 0 4 8 8 0 9 6 4048 16192 12144 14168 12144 1 6072 4048"],
                [42]))
    func testSingleEvolution(arg: String, exp: Int) async throws {
        let challenge = Day11(data: arg)
        #expect(challenge.evolve(count: 1) == exp)

    }

    @Test func testPart2() async throws {
        let challenge = Day11(data: testData)
        // #expect(String(describing: challenge.part2()) == "0")
    }
}
