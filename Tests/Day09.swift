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

        for (expectedVal, challengeValue) in zip(expected, challenge.dataArray) {
            #expect(challengeValue.size == 1)
            guard let expectedVal else {
                #expect(challengeValue is Empty)
                continue
            }

            if let file = challengeValue as? File {
                #expect(expectedVal == file.fileId)
            } else {
                Issue.record("Challenge Value was an Empty")
            }

        }
    }

    @Test func mergesBlocksCorrectly() async throws {
        let expected: [any DiskContent] = [
            File(size: 2, fileId: 0),
            Empty(size: 3),
            File(size: 3, fileId: 1),
            Empty(size: 3),
            File(size: 1, fileId: 2),
            Empty(size: 3),
            File(size: 3, fileId: 3),
            Empty(size: 1),
            File(size: 2, fileId: 4),
            Empty(size: 1),
            File(size: 4, fileId: 5),
            Empty(size: 1),
            File(size: 4, fileId: 6),
            Empty(size: 1),
            File(size: 3, fileId: 7),
            Empty(size: 1),
            File(size: 4, fileId: 8),
            File(size: 2, fileId: 9)
        ]
        let challenge = Day09(data: testData)
        for (expectedVal, challengeValue) in zip(expected, challenge.mergeBlocks()) {
            #expect(type(of: expectedVal) == type(of: challengeValue))
            #expect(expectedVal.size == challengeValue.size)

            guard let expectedFile = expectedVal as? File, let challengeFile = challengeValue as? File else { return }
            #expect(expectedFile.fileId == challengeFile.fileId)
        }

    }

    @Test func testPart1() async throws {
        let challenge = Day09(data: testData)
        #expect(String(describing: challenge.part1()) == "1928")
    }

    @Test func testPart2() async throws {
        let challenge = Day09(data: testData)

        #expect(String(describing: challenge.part2()) == "2858")
    }
}
