import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day05Tests {
    // Smoke test data provided in the challenge question
    let testData = """
                47|53
                97|13
                97|61
                97|47
                75|29
                61|13
                75|53
                29|13
                97|29
                53|29
                61|53
                97|53
                61|29
                47|13
                75|47
                97|75
                47|61
                75|61
                47|29
                75|13
                53|13

                75,47,61,53,29
                97,61,53,29,13
                75,29,13
                75,97,47,61,53
                61,13,29
                97,13,75,29,47
                """

    @Test func validatesReports() throws {
        let challenge = Day05(data: testData)
        let rules = challenge.rules

        #expect(challenge.isValid(update: [75, 47, 61, 53, 29], rules: rules))
        #expect(challenge.isValid(update: [97, 61, 53, 29, 13], rules: rules))
        #expect(challenge.isValid(update: [75, 29, 13], rules: rules))

    }

    @Test func repairsInValidReports() throws {
        let challenge = Day05(data: testData)
        let rules = challenge.rules
        var badReports = [ [75, 97, 47, 61, 53],
                           [61, 13, 29],
                           [97, 13, 75, 29, 47] ]
        #expect(challenge.repairIfInvalid(update: &badReports[0], rules: rules) == false)
        #expect(badReports[0] == [97, 75, 47, 61, 53])
        #expect(challenge.repairIfInvalid(update: &badReports[1], rules: rules) == false)
        #expect(badReports[1] == [61, 29, 13])
        #expect(challenge.repairIfInvalid(update: &badReports[2], rules: rules) == false)
        #expect(badReports[2] == [97, 75, 47, 29, 13])

    }

    @Test func testPart1() async throws {
        let challenge = Day05(data: testData)
        #expect(String(describing: challenge.part1()) == "143")
    }

    @Test func testPart2() async throws {
        let challenge = Day05(data: testData)
        #expect(String(describing: challenge.part2()) == "123")
    }
}
