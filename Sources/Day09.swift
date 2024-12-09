struct DiskContent: Sendable, Equatable {
    var size: Int
    var fileId: Int?

    func merge(with other: DiskContent) -> Self? {
        guard other.fileId == fileId else { return nil }
        return DiskContent(size: size + other.size, fileId: fileId)
    }

    func reserve(blocks: Int) -> [DiskContent]? {
        guard blocks <= size, fileId == nil
        else { return nil }
        if blocks == size {
            return [self]
        }
        return [.init(size: blocks), .init(size: size-blocks)]
    }

}

extension Array where Element == DiskContent {
    func flatten() -> [Int?] {
        var flat = [Int?]()
        for content in self {
            guard let fileId = content.fileId else {
                flat.append(contentsOf: [Int?](repeating: nil, count: content.size))
                continue
            }
            flat.append(contentsOf: [Int](repeating: fileId, count: content.size))
        }
        return flat
    }
}
struct Day09: AdventDay {

    var data: String

    var dataArray = [DiskContent]()
    var entities: [DiskContent] {
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
                    repeating: DiskContent(size: 1, fileId: fileId),
                    count: Int(String(data[left]))!
                )
            )
            if right < self.data.endIndex {
                dataArray.append(
                    contentsOf: Array(
                        repeating: DiskContent(size: 1),
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

    func compactedEntities() -> [DiskContent] {
        var compactedEntities = entities
        var left = 0
        var right = compactedEntities.count-1
        while left < right {
            while compactedEntities[left].fileId != nil {
                left+=1
            }
            while compactedEntities[right].fileId == nil {
                right-=1
            }
            if right < left {
                break
            }
            compactedEntities.swapAt(left, right)
        }
        return compactedEntities
    }

    func mergeBlocks() -> [DiskContent] {
        var mergedBlocks: [DiskContent] = []

        var i = 0
        while i < dataArray.count {
            var merged: DiskContent = dataArray[i]
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
                guard let fileId = $1.element.fileId else { return $0 }
                return $0 + $1.offset * fileId
            }
    }

    func part2() -> Any {
        var blocks = mergeBlocks()
        var left = 0
        var right = blocks.count - 1

        while left < right {
            let file = blocks[right]
            guard file.fileId != nil else {
                right-=1
                continue
            }

            while left < right {
                guard blocks[left].fileId == nil,
                    blocks[left].size >= file.size,
                        let split = blocks[left].reserve(blocks: file.size)
                else {
                    left+=1
                    continue
                }
                if split.count > 1 {
                    blocks.remove(at: left)
                    blocks.insert(contentsOf: split, at: left)
                    right+=split.count-1
                }
                blocks.swapAt(left, right)
                break
            }
            left = 0
            right -= 1
        }
        return blocks.flatten().enumerated().reduce(0) {
            guard let value = $1.element else { return $0 }
            return $0 + $1.offset * value
        }

    }
}
