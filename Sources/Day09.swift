protocol DiskContent: Sendable, Equatable {
    var size: Int { get }
    func merge(with other: any DiskContent) -> Self?
}

struct File: DiskContent {
    let size: Int
    let fileId: Int

    func merge(with other: any DiskContent) -> Self? {
        guard let otherFile = other as? File, otherFile.fileId == fileId else { return nil }
        return File(size: size + otherFile.size, fileId: fileId)
    }
}

struct Empty: DiskContent {
    let size: Int
    func merge(with other: any DiskContent) -> Self? {
        guard let empty = other as? Empty else { return nil }
        return .init(size: size + empty.size)
    }

    func reserve(blocks: Int) -> [Empty]? {
        guard blocks <= size else { return nil }
        if blocks == size {
            return [self]
        }
        return [.init(size: blocks), .init(size: size-blocks)]
    }
}

extension Array where Element == any DiskContent {
    func flatten() -> [Int?] {
        var flat = [Int?]()
        for content in self {
            guard let file = content as? File else {
                flat.append(contentsOf: [Int?](repeating: nil, count: content.size))
                continue
            }
            flat.append(contentsOf: [Int](repeating: file.fileId, count: file.size))
        }
        return flat
    }
}
struct Day09: AdventDay {

    var data: String

    var dataArray = [any DiskContent]()
    var entities: [any DiskContent] {
        dataArray
    }

    init(data: String) {
        self.data = data.filter { !$0.isNewline }
        var left = data.startIndex
        var right = data.index(left, offsetBy: 1)
        var fileId = 0

        while left < self.data.endIndex {
            dataArray.append(
                contentsOf: Array(
                    repeating: File(size: 1, fileId: fileId),
                    count: Int(String(data[left]))!
                )
            )
            if right < self.data.endIndex {
                dataArray.append(
                    contentsOf: Array(
                        repeating: Empty(size: 1),
                        count: Int(String(data[right]))!
                    )
                )
            }
            fileId+=1
            guard let newLeft = data.index(right, offsetBy: 1, limitedBy: data.endIndex),
                  let newRight = data.index(newLeft, offsetBy: 1, limitedBy: data.endIndex)
            else { break }
            left = newLeft
            right = newRight
        }

    }

    func compactedEntities() -> [any DiskContent] {
        var compactedEntities = entities
        var left = 0
        var right = compactedEntities.count-1
        while left < right {
            while compactedEntities[left] is File {
                left+=1
            }
            while compactedEntities[right] is Empty {
                right-=1
            }
            if right < left {
                break
            }
            compactedEntities.swapAt(left, right)
        }
        return compactedEntities
    }

    func mergeBlocks() -> [any DiskContent] {
        var mergedBlocks: [any DiskContent] = []

        var i = 0
        while i < dataArray.count {
            var merged: any DiskContent = dataArray[i]
            while i < dataArray.count-1 {
                guard let tempMerge = merged.merge(with: dataArray[i+1]) else {
                    break
                }
                merged = tempMerge
                i+=1
            }
            mergedBlocks.append(merged)
            i=i+1
        }
        return mergedBlocks
    }

    func part1() -> Any {
        compactedEntities().enumerated()
            .reduce(0) {
                guard let file = $1.element as? File else { return $0 }
                return $0 + $1.offset * file.fileId
            }
    }

    func part2() -> Any {
        var blocks = mergeBlocks()
        var left = 0
        var right = blocks.count - 1

        while left < right {
            guard let file = blocks[right] as? File else {
                right-=1
                continue
            }

            while left < right {
                guard let empty = blocks[left] as? Empty,
                        let split = empty.reserve(blocks: file.size)
                else {
                    left+=1
                    continue
                }
                blocks.remove(at: left)
                blocks.insert(contentsOf: split, at: left)
                right+=split.count-1
                blocks.swapAt(left, right)
                break
            }
            left = 0
            right -= 1
        }

        return blocks.flatten().enumerated().reduce(0) {
            guard let val = $1.element else { return $0 }
            return $0 + $1.offset * val
        }

    }
}
