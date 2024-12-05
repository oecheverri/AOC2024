struct Day05: AdventDay {
    var data: String

    var parsed: [[[Int]]] = .init(repeating: [], count: 2)
    init(data: String) {
        self.data = data

        let reports = data.components(separatedBy: "\n\n")
        parsed[0] = reports[0].components(separatedBy: "\n").map { $0.components(separatedBy: "|").compactMap(Int.init) }
        parsed[1] = reports[1].components(separatedBy: "\n").compactMap {
            let update = $0.components(separatedBy: ",").compactMap(Int.init)
            guard !update.isEmpty else { return nil }
            return update
        }

    }
    var entities: [[[Int]]] {
        parsed
    }

    func isValid(update: [Int], rules: [Int: [Int]]) -> Bool {
        var seen = Set<Int>()
        for page in update {
            seen.insert(page)
            let rule = rules[page]
            if rule != nil && !rule!.allSatisfy({!update.contains($0) || seen.contains($0)}) {
                return false
            }
        }
        return true
    }

    func makeRules() -> [Int: [Int]] {
        var rules = [Int: [Int]]()
        for entity in entities[0] {
            var rule = rules[entity[1], default: []]
            rule.append(entity[0])
            rules[entity[1]] = rule
        }
        return rules
    }

    func part1() -> Any {
        let rules = makeRules()

        var validEntities: [Int] = .init()
        for index in entities[1].indices {
            if isValid(update: entities[1][index], rules: rules) {
                validEntities.append(index)
            }
        }

        return validEntities.map {
            let middleIndex = entities[1][$0].count/2
            return entities[1][$0][middleIndex]
        }.reduce(0, +)
    }

    func part2() -> Any {
        return 0
    }
}
