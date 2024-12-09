import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day08Tests {
    // Smoke test data provided in the challenge question
    let testData = """
                ............
                ........0...
                .....0......
                .......0....
                ....0.......
                ......A.....
                ............
                ............
                ........A...
                .........A..
                ............
                ............
                """

    @Test(
        "Can come up with antinodes"
    )
    func testAntinodes() async throws {
        let challenge = Day08(data: testData)
        let antinodes = challenge.calculateAntiNodalPoints(Point(5, 2), Point(4, 4)).sorted()
        #expect(antinodes == [.init(6, 0), .init(3, 6)].sorted())

    }
    @Test func testPart1() async throws {
        let challenge = Day08(data: testData)
        #expect(String(describing: challenge.part1()) == "14")
    }

    @Test func testPart2() async throws {
        let challenge = Day08(data: testData)
        #expect(String(describing: challenge.part2()) == "32000")
    }
}
