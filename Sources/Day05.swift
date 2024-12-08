struct Day05: AdventDay {
    var data: String

    var parsed: [[Int]] = .init(repeating: [], count: 2)
    let rules: [Int: [Int]]
    init(data: String) {
        self.data = data

        let reports = data.components(separatedBy: "\n\n")
        rules = reports[0].components(separatedBy: "\n").map { $0.components(separatedBy: "|").compactMap(Int.init) }
            .reduce(into: [:]) { partial, element in
                partial[element[1], default: []].append(element[0])
            }
        parsed = reports[1].components(separatedBy: "\n").compactMap {
            let update = $0.components(separatedBy: ",").compactMap(Int.init)
            guard !update.isEmpty else { return nil }
            return update
        }

    }
    var entities: [[Int]] {
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

    @discardableResult
    func repairIfInvalid(update: inout [Int], rules: [Int: [Int]]) -> Bool {
        var seen = Set<Int>()
        var wasValid = true
        for var index in 0..<update.count {
            let page = update[index]
            seen.insert(page)
            let rulesForPage = rules[page]
            if let rulesForPage {
                for rule in rulesForPage {
                    let indexOfRule = update.firstIndex(of: rule)
                    if indexOfRule != nil && !seen.contains(rule) {
                        update.remove(at: indexOfRule!)
                        update.insert(rule, at: index)
                        seen.insert(rule)
                        index+=1
                        wasValid = false
                        repairIfInvalid(update: &update, rules: rules)
                    }
                }
            }
        }
        return wasValid
    }

    func part1() -> Any {
        var validEntities: [Int] = .init()
        for index in entities.indices {
            if isValid(update: entities[index], rules: rules) {
                validEntities.append(index)
            }
        }

        return validEntities.map {
            let middleIndex = entities[$0].count/2
            return entities[$0][middleIndex]
        }.reduce(0, +)
    }

    func part2() -> Any {
        var repaired = entities
        for i in stride(from: repaired.count-1, through: 0, by: -1) {
            if repairIfInvalid(update: &repaired[i], rules: rules) {
                repaired.remove(at: i)
            }
        }

        return repaired.reduce(0) {
            $0 + $1[$1.count/2]
        }
    }
}
