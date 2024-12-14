import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day13Tests {
    // Smoke test data provided in the challenge question
    let testData = """
                Button A: X+94, Y+34
                Button B: X+22, Y+67
                Prize: X=8400, Y=5400

                Button A: X+26, Y+66
                Button B: X+67, Y+21
                Prize: X=12748, Y=12176

                Button A: X+17, Y+86
                Button B: X+84, Y+37
                Prize: X=7870, Y=6450

                Button A: X+69, Y+23
                Button B: X+27, Y+71
                Prize: X=18641, Y=10279

                """

    @Test func testPart1() async throws {
        let challenge = Day13(data: testData)
        #expect(String(describing: challenge.part1()) == "480")
    }

    @Test func testPart2() async throws {
        let challenge = Day13(data: testData)
        #expect(String(describing: challenge.part2()) == "875318608908")
    }

    @Test func solves() async throws {
        let challenge = Day13()
        let button = Button(16, 74, cost: 3)
        let buttonb = Button(74, 74, cost: 1)

        let machine = Machine(buttons: [button, buttonb], prize: .init(6368, 10138))
        #expect(challenge.solveCost(machine) == 267)
        #expect(challenge.solveCostInflated(machine) == 0)
    }
}
